//
//  Article.swift
//  GrailedTest
//
//  Created by Collin Chandler on 1/28/18.
//  Copyright © 2018 Collin Chandler. All rights reserved.
//

import Foundation
import UIKit

struct Article
{
    var id:             Int?
    var url:            String?
    var title:          String?
    var publishDate:    Date?
    var published:      Bool?
    var image_url:      String?
    var image:          UIImage?
    var listings:       Array<Any>?
    var taglist:        Array<Any>?
    var franchise:      String?
    var slug:           String?
    var author:         String?
    var content_type:   String?
    var position:       String?
    
    mutating func load(_articleData: Dictionary<String, Any>)
    {
        self.id           = _articleData["id"] as? Int
        self.image_url    = _articleData["hero"] as? String
        self.title        = _articleData["title"] as? String
        self.published    = _articleData["published"] as? Bool
    }
}
