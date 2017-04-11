//
//  PostListTableViewController.swift
//  Post
//
//  Created by Bradley GIlmore on 4/11/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController,PostControllerDelegate {
    
    let postController = PostController()
    
    
    @IBAction func refreshControllerPulled(_ sender: Any) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        postController.fetchPosts(completion: { (newPosts) in
            self.refreshControl?.endRefreshing()
            //MARK: - Is this right?
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
        
        
        
    }
    
    
    
    func postsWereUpdatedTo(posts: [Post], on postController: PostController) {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        postController.delegate = self
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let post = postController.posts[indexPath.row]
        
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "Author: \(post.username) \n Time: \(post.timestamp)"
    
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
