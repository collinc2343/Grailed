//
//  ImageManager.swift
//  GrailedTest
//
//  Created by Collin Chandler on 1/29/18.
//  Copyright © 2018 Collin Chandler. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ImageUtil
{
    static let sharedInstance = ImageUtil()
    private let FORMAT_URL = "https://cdn.fs.grailed.com/AJdAgnqCST4iPtnUxiGtTz/rotate=deg:exif/rotate=deg:0/resize=width:"
    private let FORMAT_URL_2 = ",fit:crop/output=format:jpg,compress:true,quality:95/"
    
    init()
    {

    }
    
    func formatURL(_url: String?, _width: String) -> String
    {
        if(_url != nil)
        {
            let formattedURL = FORMAT_URL + _width + FORMAT_URL_2 + _url!
            return formattedURL
        }
        
        return ""
    }
    
}
