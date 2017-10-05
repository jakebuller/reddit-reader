//
//  RedditPostsService.swift
//  RedditReader
//
//  Created by Jake Buller on 2017-04-13.
//  Copyright © 2017 Jake Buller. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON

class RedditPostsService {
    var sortType = Constants.SortType.Hot;
    var subReddit = String();
    
    func get(subreddit: SubReddit, after: Post? = nil, completion: @escaping (_ result: Array<Post>) -> Void) {
        var postsUrl = Constants.RedditApi.baseUrl + subreddit.url
        if (subreddit.sortOrder != "") {
            postsUrl += subreddit.sortOrder + "/"
        }
        
        postsUrl += Constants.RedditApi.jsonApiExt
        
        if subreddit.filter != "" {
            postsUrl = Constants.RedditApi.baseUrl + subreddit.url + "search.json?q=" + subreddit.filter + "&restrict_sr=on"
        }
        
        if (after != nil) {
            postsUrl += "?after=" + after!.name
        }
        
        Alamofire.request(postsUrl).responseJSON { response in
            var posts = Array<Post>()
            
            if (response.result.value != nil) {
                let postsJson = JSON(response.result.value!)["data"]["children"]
                
                for (_,obj) in postsJson {
                    let postJson = obj["data"]
                    let post = Post()
                    post.id = postJson["id"].string!
                    post.author = postJson["author"].string!
                    post.commentCount = postJson["num_comments"].int!
                    post.createdAt = Date(timeIntervalSince1970: TimeInterval(postJson["created"].int!))
                    post.title = postJson["title"].string!
                    post.isSelf = postJson["is_self"].bool!
                    post.imageUrl = postJson["thumbnail"].string!
                    post.permaLink = postJson["permalink"].string!
                    post.linkUrl = postJson["url"].string!
                    post.name = postJson["name"].string!
                    
                    do {
                        post.imageUrl = try self.extractImageUrl(postJson: postJson).convertHtmlSymbols()!
                    } catch {
                        print(error.localizedDescription)
                    }
                    
//                    self.save(id: post.id)
                    posts.append(post)
                }
            }
            
            subreddit.posts.append(contentsOf: posts)
            completion(subreddit.posts)
        }
    }
    
    func save(id: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "ManagedPost",
                                       in: managedContext)!
        
        let managedPost = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        managedPost.setValue(id, forKeyPath: "id")
        
        do {
            print("Trying to save post " + id)
            try managedContext.save()
//            people.append(managedPost)
            print("Successfully saved post to core data")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func extractImageUrl(postJson: JSON) -> String{
        var imgUrl = ""
        if let resolutions = postJson["preview"]["images"][0]["resolutions"].array {
            // Find the most appropriate resolution
            imgUrl = (resolutions.last?["url"].string!)!
        } else if let sourceImg = postJson["preview"]["images"][0]["source"]["url"].string {
            imgUrl = sourceImg
        }
        
        return imgUrl
    }
}
