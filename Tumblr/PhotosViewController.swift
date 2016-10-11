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
        
        if(indexPath.row == currentRowCount-1){
            let posts = TumblrApiService.service.getPostData()
            let count = (posts != nil) ? posts!.count : 0
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
        return (count <= currentRowCount) ? count : currentRowCount// load currentRowCount at most, rest will be represented by infinite scroll
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
        let posts = TumblrApiService.service.getPostData()
        let count = (posts != nil) ? posts!.count : 0
        
        let prevCurrentRowCount = self.currentRowCount
        // only increment until count
        self.currentRowCount = min(count, self.currentRowCount + self.rowIncrement)
        
        // only reload table if there are new data
        if prevCurrentRowCount != currentRowCount{
            self.photoTableView.reloadData()
        }
    }

}

