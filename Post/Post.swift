//
//  Post.swift
//  Post
//
//  Created by Bradley GIlmore on 4/11/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import Foundation

//MARK: - Keys

fileprivate let kUsername = "username"
fileprivate let KText = "text"
fileprivate let kTimeStamp = "timestamp"

struct Post {
    
    //MARK: - Properties
    
    let username: String
    let text: String
    let timestamp: TimeInterval
    let identifier: UUID
    
    //MARK: - Inits
    
    init(username: String, text: String, timestamp: TimeInterval = Date().timeIntervalSince1970, identifier: UUID = UUID()){
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    init?(jsonDictionary: [String: Any], identifier: String){
        guard let username = jsonDictionary[kUsername] as? String,
            let text = jsonDictionary[KText] as? String,
            let timestamp = jsonDictionary[kTimeStamp] as? Double,
            let identifier = UUID(uuidString: identifier) else { return nil }
        
        self.username = username
        self.text = text
        self.timestamp = TimeInterval(floatLiteral: timestamp)
        self.identifier = identifier
    }
}
