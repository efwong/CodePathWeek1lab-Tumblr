//
//  TumblrApiService.swift
//  Tumblr
//
//  Created by Edwin Wong on 10/11/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import Foundation

class TumblrApiService{
    static let service = TumblrApiService()
    
    private var updateJsonLock:Bool = false // indicate wheter or not request is already in progress
    
    let apiKey:String = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
    var postData:NSArray? = nil
    
    private init(){
        
    }
    
    func updateJsonData(completion: @escaping () -> Void){
        if(!self.updateJsonLock){
            self.updateJsonLock = true
            let url:URL? = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
            
            let request = URLRequest(url: url!)
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
            
            let task: URLSessionDataTask = session.dataTask(with: request){
                (dataOrNil, response, error) in
                if let data = dataOrNil{
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        NSLog("response: \(responseDictionary)")
                        let responseData = responseDictionary["response"] as? NSDictionary
                        self.postData = responseData?["posts"] as? NSArray
                        completion()
                        self.updateJsonLock = false
                    }
                }
                
            }
            
            task.resume()
        }
    }
    
    func getRawPostData() -> NSArray?{
        return self.postData
    }
    
    func getCountOfPosts() -> Int{
        if let post =  self.postData{
            return post.count
        }
        return 0
    }
    
    func getPosts() -> [Post]{
        let postArr = self.postData
        if postArr != nil{
            var newPostArr: [Post]=[]
            for (index, _) in postArr!.enumerated(){
                if let newPost = getPostById(id: index){
                    newPostArr.append(newPost)
                }
            }
            return newPostArr
        }
        return []
    }
    
//    func getPhotoPostUrl(id: Int) ->URL?{
//        let post = self.postData
//        if post != nil && (post?.count)! > 0{
//            if let firstPost:NSDictionary = post?[id] as? NSDictionary{
//            //alt
//                if let photos = firstPost["photos"] as? NSArray{
//                    if let chosenPhoto = photos[0] as? NSDictionary{
//                        if let altPhoto = chosenPhoto["alt_sizes"] as? NSArray{
//                            if let firstAltphoto = altPhoto[2] as? NSDictionary{
//                                if let altPhotoUrl = firstAltphoto["url"] as? String{
//                                    return URL(string: altPhotoUrl)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        return nil
//    }

    // Get Post by Id by querying self.postData
    func getPostById(id: Int) -> Post?{
        let post = self.postData
        if post != nil && (post?.count)! > 0{
            
            let newPost = Post()
            if let firstPost:NSDictionary = post?[id] as? NSDictionary{
                if let blogName = firstPost["blog_name"] as? String{
                    newPost.name = blogName
                }
                if let postId = firstPost["id"] as? Double{
                    newPost.id = postId
                }
                if let summary = firstPost["summary"] as? String{
                    newPost.summary = summary
                }
                if let displayAvatar = firstPost["display_avatar"] as? Bool{
                    newPost.displayAvatar = displayAvatar
                }
                if let dateString = firstPost["date"] as? String{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
                    newPost.date = dateFormatter.date(from: dateString)
                }
                //alt
                if let photos = firstPost["photos"] as? NSArray{
                    if let chosenPhoto = photos[0] as? NSDictionary{
                        if let altPhoto = chosenPhoto["alt_sizes"] as? NSArray{
                            if let firstAltphoto = altPhoto[2] as? NSDictionary{
                                if let altPhotoUrl = firstAltphoto["url"] as? String{
                                    newPost.imageUrl = URL(string: altPhotoUrl)
                                }
                            }
                        }
                    }
                }
            }
            if newPost.id != 0{
                return newPost
            }
        }
        return nil
        
    }
}
