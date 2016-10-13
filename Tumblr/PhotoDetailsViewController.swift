//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by Edwin Wong on 10/11/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    
    public var photoUrl:URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(self.photoUrl != nil){
            self.photoView.setImageWith(self.photoUrl!)
        }
        
        photoView.isUserInteractionEnabled = true
        //now you need a tap gesture recognizer
        //note that target and action point to what happens when the action is recognized.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onPhotoTap))
        //Add the recognizer to your view.
        photoView.addGestureRecognizer(tapRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func onPhotoTap(gestureRecognizer: UITapGestureRecognizer){
        performSegue(withIdentifier: "photoDetailsToFullScreen", sender: gestureRecognizer)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "photoDetailsToFullScreen"{
            if let destinationVC = segue.destination as? FullScreenPhotoViewController{
                destinationVC.photoImageURL = self.photoUrl
            }
        }
    }
 

}
