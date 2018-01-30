//
//  Merchandise.swift
//  GrailedTest
//
//  Created by Collin Chandler on 1/28/18.
//  Copyright © 2018 Collin Chandler. All rights reserved.
//

import Foundation
import UIKit

struct Merchandise
{
    var id:             Int?
    var name:           String?
    var image_url:      String?
    var image:          UIImage?
    var item_type:      String?
    var published:      Bool?
    var publishDate:    Date?
    var article:        String?
    var search:         Dictionary<String, Any>?
    
    mutating func load(_merchData: Dictionary<String, Any>)
    {
        self.id = _merchData["id"] as? Int
        self.image_url = _merchData["image_url"] as? String
        self.name = _merchData["name"] as? String
        self.published    = _merchData["published"] as? Bool
    }
    
}
