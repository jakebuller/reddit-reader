//
//  SubReddit.swift
//  RedditReader
//
//  Created by Patrick West on 2017-04-13.
//  Copyright © 2017 Jake Buller. All rights reserved.
//

import Foundation


class SubReddit {
    var name: String = ""
    var subscribers: Int = 0
    var description: String = ""
    var url: String = ""
    var imageUrl: String = ""
    
    func posts() {
        RedditPostsService().get(subreddit: self, completion: self.postsLoaded)
    }

    func postsLoaded(posts: Array<Post>) {
        for post in posts {
            print(post)
        }
    }
}
