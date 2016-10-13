//
//  FullScreenPhotoViewController.swift
//  Tumblr
//
//  Created by Edwin Wong on 10/12/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit

class FullScreenPhotoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var photoImageURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.delegate = self
        // Do any additional setup after loading the view.
        if self.photoImageURL != nil {
            self.photoImageView.setImageWith(self.photoImageURL!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeModal(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoImageView
    }

}
