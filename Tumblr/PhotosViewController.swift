//
//  ViewController.swift
//  Tumblr
//
//  Created by Edwin Wong on 10/11/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var photoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TumblrApiService.service.updateJsonData(completion:self.photoTableView.reloadData);
        photoTableView.dataSource = self
        photoTableView.delegate = self
        photoTableView.rowHeight = 500;
        //photoTableView.estimatedRowHeight = 500
        //photoTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.codepath.DemoPrototypeCell", for: indexPath) as! PhotoTableViewCell
        
        let photoUrl:URL? = TumblrApiService.service.getPhotoPostUrl(id: indexPath.row)
        if photoUrl != nil {
            cell.photoImageView.setImageWith(photoUrl!)
        }
        //let post = TumblrApiService.service.getPostData()
        //if post != nil && (post?.count)! > 0{
            //let firstPost:NSDictionary = post?[0] as! NSDictionary;
            
            //let firstPhoto = (firstPost["photos"] as! NSArray)[0] as! NSDictionary
            //let altPhoto = firstPhoto["alt_sizes"] as! NSArray
            
            
            //let origPhoto = firstPhoto["original_size"] as! NSDictionary
            //let origPhotoUrl = origPhoto["url"] as! String
            //cell.photoImageView.setImageWith(URL(string: origPhotoUrl)!)
            
//            let firstAltphoto = altPhoto[1] as! NSDictionary
//            let altPhotoUrl = firstAltphoto["url"] as! String
//            cell.photoImageView.setImageWith(URL(string: altPhotoUrl)!)
           // print(1)
       // }
        //let firstPost:NSDictionary = post?[0] as! NSDictionary;
        //let photosFirst = postFirst["photos"] as NSDictionary
        //let altSizesPhotos = photosFirst[0]
        //let photos = post["photos"] as NSArray?
        
//        let cityState = data[indexPath.row].componentsSeparatedByString(", ")
//        cell.cityLabel.text = cityState.first
//        cell.stateLabel.text = cityState.last
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let posts = TumblrApiService.service.getPostData()
        let count = (posts != nil) ? posts!.count : 0
        return count
        //return 1
    }


}

