//
//  PostListTableViewController.swift
//  Post
//
//  Created by Bradley GIlmore on 4/11/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController,PostControllerDelegate {
    
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        presentNewPostAlert()
    }
    
    
    func presentNewPostAlert(){
        var usernameTextField: UITextField?
        var messageTextField: UITextField?
        
        let alertController = UIAlertController(title: "Add Message", message: "Please add a message", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            usernameTextField = textField
            textField.placeholder = "Enter UserName" }
        
        //MARK: - Can I add placement text?
        
        alertController.addTextField { (textField) in
            messageTextField = textField
            textField.placeholder = "Enter Message" }
        
        let postAction = UIAlertAction(title: "Post", style: .default) { _ in
            guard let username = usernameTextField?.text, !username.isEmpty else { self.presentErrorAlert(); return }
            guard let text = messageTextField?.text, !text.isEmpty else { self.presentErrorAlert(); return }
            self.postController.addNewPostWith(username: username, text: text)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(postAction)
        
        present(alertController, animated: true, completion: nil)

    }
    
    func presentErrorAlert(){
        
        let alertController = UIAlertController(title: "Error", message: "Invalid title or text please try again", preferredStyle: .alert)
        
        let postError = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(postError)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
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
