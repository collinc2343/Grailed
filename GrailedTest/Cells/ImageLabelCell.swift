//
//  ImageLabelCell.swift
//  GrailedTest
//
//  Created by Collin Chandler on 1/28/18.
//  Copyright © 2018 Collin Chandler. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ImageLabelCell: UITableViewCell
{
    var indexPath:IndexPath?
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    
    func loadCell(_title: String?, _image: UIImage?)
    {
        cellTitle.text = _title
        cellImage.image = _image
    }
}
