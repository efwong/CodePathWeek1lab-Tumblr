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
    
    // max rows for table
    private let rowIncrement: Int = 3
    private var currentRowCount:Int = 3
    private var loadingView: UIActivityIndicatorView? = nil
    override func viewDidLoad() {
        var testSet:Set<String>=[]
        testSet.insert("hello")
        testSet.insert("hello")
        testSet.insert("gada")
        
        for obj in testSet{
            print(obj)
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // initial load of table
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
        
        
        // add footer to table view
        let tableFooterView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 10))
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView?.startAnimating()
        loadingView?.hidesWhenStopped = true
        loadingView?.center = tableFooterView.center
        tableFooterView.addSubview(loadingView!)
        self.photoTableView.tableFooterView = tableFooterView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.codepath.DemoPrototypeCell", for: indexPath) as! PhotoTableViewCell
        
        if(indexPath.section == currentRowCount-1){
            let count = TumblrApiService.service.getCountOfPosts()
            
            // if at max, don't load anymore
            if currentRowCount == count{
                loadingView?.stopAnimating()
            }else{
                // load more rows if at max row
                loadingView?.startAnimating()
                incrementNumberOfRows()
            }
        }
        // get photo URL
        
        // update photo image with URL
        if let post = TumblrApiService.service.getPostById(id: indexPath.section) {
            cell.photoImageView.setImageWith(post.imageUrl!)
            cell.photoUrl = post.imageUrl
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // set number of rows = number of Tumblr Posts received
        //let count = TumblrApiService.service.getCountOfPosts()
        //return (count <= currentRowCount) ? count : currentRowCount// load currentRowCount at most, rest will be represented by infinite scroll
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        let count = TumblrApiService.service.getCountOfPosts()
        return (count <= currentRowCount) ? count : currentRowCount// load currentRowCount at most, rest will be represented by infinite scroll
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let post = TumblrApiService.service.getPostById(id: section){
            if post.displayAvatar && post.date != nil{
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
                headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
                
                let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
                profileView.clipsToBounds = true
                profileView.layer.cornerRadius = 15;
                profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
                profileView.layer.borderWidth = 1;
                
                // set the avatar
                profileView.setImageWith(URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
                headerView.addSubview(profileView)
                
                // add blog label
                let blogLabel = UILabel(frame: CGRect(x: 50, y: 10, width: 150,height: 30))
                blogLabel.text = post.name
                headerView.addSubview(blogLabel)
                
                // Add a UILabel for the date here
                // Use the section number to get the right URL
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM-dd-yyyy"
                let dateString = dateFormatter.string(from: post.date!)
                
                let dateLabel = UILabel(frame: CGRect(x: 200, y: 10, width: 200, height:30))
                dateLabel.text = dateString
                headerView.addSubview(dateLabel)
                
                return headerView
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // take care of segues to other views
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
    
    // increment row count until max count reached
    // used for infinite scroll
    private func incrementNumberOfRows(){
        let count = TumblrApiService.service.getCountOfPosts()
        
        let prevCurrentRowCount = self.currentRowCount
        // only increment until count
        self.currentRowCount = min(count, self.currentRowCount + self.rowIncrement)
        
        // only reload table if there are new data
        if prevCurrentRowCount != currentRowCount{
            self.photoTableView.reloadData()
        }
    }

}

