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
        TumblrApiService.service.updateJsonData(completion:self.photoTableView.reloadData)
        photoTableView.dataSource = self
        photoTableView.delegate = self
        photoTableView.rowHeight = 300;
        //photoTableView.estimatedRowHeight = 500
        //photoTableView.rowHeight = UITableViewAutomaticDimension
        
        // Initialize UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        
        photoTableView.insertSubview(refreshControl, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.codepath.DemoPrototypeCell", for: indexPath) as! PhotoTableViewCell
        
        // get photo URL
        let photoUrl:URL? = TumblrApiService.service.getPhotoPostUrl(id: indexPath.row)
        
        // update photo image with URL
        if photoUrl != nil {
            cell.photoImageView.setImageWith(photoUrl!)
            cell.photoUrl = photoUrl
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // set number of rows = number of Tumblr Posts received
        let posts = TumblrApiService.service.getPostData()
        let count = (posts != nil) ? posts!.count : 0
        return count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoDetails"{
            // for segues to photo details
            if let photoDetailsViewController = segue.destination as? PhotoDetailsViewController,
                let photoTableCell = sender as? PhotoTableViewCell
                {
                photoDetailsViewController.photoUrl = photoTableCell.photoUrl
                    
            }
            
        }
    }
    
    // on pull down to refresh, trigger this action to reload data
    func refreshControlAction(refreshControl: UIRefreshControl){
        TumblrApiService.service.updateJsonData(completion:reloadTableAndRefreshControl(refreshControl: refreshControl))

    }
    
    // returns function to be passed to updateJsonData in the TumblrApiService
    private func reloadTableAndRefreshControl(refreshControl: UIRefreshControl) -> ()->Void{
        return { ()
        self.photoTableView.reloadData()
        refreshControl.endRefreshing()
        }
    }

}

