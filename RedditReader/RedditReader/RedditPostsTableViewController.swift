//
//  HomeViewController.swift
//  
//
//  Created by Jake Buller on 2017-01-24.
//
//

import UIKit
import Alamofire
import Kingfisher

class RedditPostsTableViewController: UITableViewController {

    @IBOutlet var sortTypeControl: UISegmentedControl!

    var subreddit = SubReddit()
    var sortType = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.view.addGestureRecognizer(longPressRecognizer)

         // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        let subRedditService = SubRedditService()
        subRedditService.get(subreddit: "hockey", completion: self.subredditLoadedHandler)
    }
    
    func subredditLoadedHandler(subreddit: SubReddit) {
        self.subreddit.loadPosts(completion: self.postsLoaded)
    }
    
    func postsLoaded(posts: Array<Post>) {
        self.tableView.reloadData()
    }
  
    //Called, when long press occurred
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            print("a long press gesture was recognized")
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                print(String(indexPath.row))
                // your code here, get the row for the indexPath or do whatever you want
            }
        }
    }
    
//    @IBAction func SortTypeChanged(_ sender: Any) {
//        switch sortTypeControl.selectedSegmentIndex {
//            case 1:
//                sortType = Constants.SortType.New
//            default:
//                sortType = Constants.SortType.Hot
//                break
//        }
//
//        posts.removeAll()
//        self.loadPosts();
//    }
    
//    func loadPosts(after: String = "") {
//        self.posts = RedditPostsService().getPosts(sortType: sortType)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subreddit.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RedditPostsTableViewCell
        if (self.subreddit.posts.isEmpty) {
            return cell;
        }

        let post = self.subreddit.posts[indexPath.row]
        cell.cellTitle.text = post.title
        cell.cellPostAuthor.text = post.author
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        cell.cellPostDate.text = formatter.string(from: post.createdAt)
        

        let imgURL = post.imageUrl

        if imgURL.range(of:"http") != nil {
            let url = URL(string: imgURL)
            cell.cellImage.kf.setImage(with: url)
        } else {
            cell.cellImage.image = UIImage(named: "list-thumbnail")
        }

        // Start loading more posts when we are 3 away to make scrolling smoother
        if indexPath.row == self.subreddit.posts.count - 3 {
            print("Scrolling last cell")
            
            let lastPost = self.subreddit.posts[self.subreddit.posts.count - 1]
            self.subreddit.loadPosts(after: lastPost, completion: self.postsLoaded)
//            let lastPostData = lastPost["data"] as! NSDictionary
//            loadPosts(after: lastPostData["name"] as! String)
        }
//
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let post = self.posts[indexPath.row] as NSDictionary
//        let postData = post["data"] as! NSDictionary
//        let url_string = postData["url"] as! String
//        loadWebView(url: url_string)
//    }
    
    func loadWebView(url:String) {
        let newView = WebviewViewController(nibName: "WebviewViewController", bundle: nil)
        newView.urlstring = url
        newView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(newView, animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let indexPath = tableView.indexPathForSelectedRow{
//            let selectedRow = indexPath.row
//            let post = self.posts[selectedRow]
//            
//            
//            let postData = post["data"] as! NSDictionary
//            let subReddit = postData["permalink"] as? String
//            
//            
//            if let nextViewController = segue.destination as? CommentsTableViewController{
//                nextViewController.permalink = subReddit! //Or pass any values
//            }
//        }
//    }

     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print ("deleting row")
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
     }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
