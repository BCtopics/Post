//
//  PostController.swift
//  Post
//
//  Created by Bradley GIlmore on 4/11/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import Foundation

class PostController {
    
     let baseURL = URL(string: "https://devmtn-post.firebaseio.com/posts/")

    //MARK: - Properties
    
    weak var delegate: PostControllerDelegate?
    
    
    var posts: [Post] = [] {
        didSet {
            delegate?.postsWereUpdatedTo(posts: posts, on: self)
        }
    }
    
    //MARK: - CRUD
    
    func addNewPostWith(username: String, text: String){
        
        let post = Post(username: username, text: text)
        
       guard let putEndpoint = baseURL?.appendingPathComponent(username).appendingPathExtension("json") else { return }
        
        NetworkController.performRequest(for: putEndpoint, httpMethod: .put, body: post.jsonData) { (data, error) in
            
            guard let data = data, let responseDataString = String(data: data, encoding: .utf8) else { return }
            
            if error != nil {
                print("Error: \(error)")
            } else if responseDataString.contains("error") {
                print("Error: \(responseDataString)")
            } else {
                print("Success: \nResponse: \(responseDataString)")
            }
            self.fetchPosts()
            //MARK: - ^^ This right?
        }
        
        
        
    }
    
    //MARK: - Fetch Requests
    
    func fetchPosts(reset: Bool = true, completion: (([Post]) -> Void)? = nil) {
        let getterEndpoint = baseURL?.appendingPathExtension("json")
        
        let queryEndInterval = reset ? Date().timeIntervalSince1970 : posts.last?.queryTimestamp ?? Date().timeIntervalSince1970
        
        guard let requestedURL = getterEndpoint else { fatalError("Endpoint URL Invalid/Failed") }
        
        let urlParameters = [
            "orderBy": "\"timestamp\"",
            "endAt": "\(queryEndInterval)",
            "limitToLast": "15",
            ]
        
        NetworkController.performRequest(for: requestedURL, httpMethod: .get, urlParameters: urlParameters) { (data, error) in
         
            let responseDataString = String(data: data!, encoding: .utf8)
            
            guard let data = data,
                let postDictionaries = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: [String: Any]] else {
                        NSLog("Failure Serializing data: \(responseDataString)")
                        completion?([])
                        return
            }
            
            let posts = postDictionaries.flatMap { Post(jsonDictionary: $0.1, identifier: $0.0) }
            let sortedPosts = posts.sorted(by: { $0.0.timestamp > $0.1.timestamp })
            
            DispatchQueue.main.async {
                if reset {
                    self.posts = sortedPosts
                } else {
                    self.posts.append(contentsOf: sortedPosts)
                }
                completion?(sortedPosts)
            }
        }
        
    }
    
    //MARK: - Inits
    
    init() {
        fetchPosts()
    }
    
}

//MARK: - Protocols

protocol PostControllerDelegate: class {
    
    func postsWereUpdatedTo(posts: [Post], on postController: PostController)
}
