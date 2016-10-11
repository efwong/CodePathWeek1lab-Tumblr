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
    
    let apiKey:String = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
    var postData:NSArray? = nil
    
    private init(){
        
    }
    
    func updateJsonData(completion: @escaping () -> Void){
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
                }
            }
            
        }
        
        task.resume()
    }
    
    func getPostData() -> NSArray?{
        return self.postData;
    }
    
    func getPhotoPostUrl(id: Int) ->URL?{
        let post = self.postData
        if post != nil && (post?.count)! > 0{
            let firstPost:NSDictionary = post?[id] as! NSDictionary;
            //alt
            let chosenPhoto = (firstPost["photos"] as! NSArray)[0] as! NSDictionary
            let altPhoto = chosenPhoto["alt_sizes"] as! NSArray
            let firstAltphoto = altPhoto[2] as! NSDictionary
            let altPhotoUrl = firstAltphoto["url"] as! String
            return URL(string: altPhotoUrl)
            
            // orig
            //let firstPhoto = (firstPost["photos"] as! NSArray)[0] as! NSDictionary
            //let origPhoto = firstPhoto["original_size"] as! NSDictionary
            //let origPhotoUrl = origPhoto["url"] as! String
            //return URL(string: origPhotoUrl)!
            //cell.photoImageView.setImageWith(URL(string: origPhotoUrl)!)
            
            //            let firstAltphoto = altPhoto[1] as! NSDictionary
            //            let altPhotoUrl = firstAltphoto["url"] as! String
            //            cell.photoImageView.setImageWith(URL(string: altPhotoUrl)!)
            // print(1)
        }
        return nil
    }
}
