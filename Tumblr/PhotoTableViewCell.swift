//
//  PhotoTableViewCell.swift
//  Tumblr
//
//  Created by Edwin Wong on 10/11/16.
//  Copyright © 2016 edwin. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var photoImageView: UIImageView!
    
    public var photoUrl:URL? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
