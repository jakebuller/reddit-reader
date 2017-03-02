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

class HomeViewController: UITableViewController {

    var posts: NSArray = NSArray();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        refreshPosts()
    }
    
    func refreshPosts() {
//        let searchTerm = searchInput.text!
        let searchUrl = "https://www.reddit.com/.json"
        
        Alamofire.request(searchUrl).responseJSON { response in
            
            if let json = response.result.value {
                let obj = json as! NSDictionary
                let data = obj["data"] as! NSDictionary
                let children = data["children"] as! NSArray
                self.posts = children
                let c = self.posts.count
                print("count of dictionary \(c)")
            }
            
            self.tableView.reloadData()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let c = self.posts.count
        print("count of dictionary in table method \(c)")
        return self.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Updating cell at index \(indexPath.row)\n")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeViewTableCell
        let post = self.posts[indexPath.row] as! NSDictionary
        let postData = post["data"] as! NSDictionary
        cell.cellTitle.text = postData["title"] as? String
        
        let imgURL = postData["thumbnail"] as! String
        print("title: \(postData["title"])\n")
        print("imgURL: \(imgURL)\n")
        
        if imgURL.range(of:"http") != nil {
            print("before request \(imgURL)\n")
            let url = URL(string: imgURL)
            cell.cellImage.kf.setImage(with: url)
        } else {
            cell.cellImage.image = UIImage(named: "list-thumbnail")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = self.posts[indexPath.row] as! NSDictionary
        let postData = post["data"] as! NSDictionary
        let url_string = postData["url"] as! String
        loadWebView(url: url_string)
    }
    
    func loadWebView(url:String) {
        let newView = WebviewViewController(nibName: "WebviewViewController", bundle: nil)
        newView.urlstring = url
        newView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(newView, animated: true, completion: nil)
    }
    
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
