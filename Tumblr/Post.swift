//
//  Post.swift
//  Tumblr
//
//  Created by Edwin Wong on 10/12/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import Foundation

class Post{
    var id:Double
    var name:String
    var summary:String
    var imageUrl: URL?
    var displayAvatar: Bool
    var date: Date?
    
    init(){
        self.id = 0
        self.name = ""
        self.summary = ""
        self.imageUrl = nil
        self.displayAvatar = false
        self.date = nil
    }
    init(id: Double, name: String, summary:String, imageUrl: URL?, displayAvatar: Bool, date: Date?){
        self.id = id
        self.name = name
        self.summary = summary
        self.imageUrl = imageUrl
        self.displayAvatar = displayAvatar
        self.date = date
    }
    
}
