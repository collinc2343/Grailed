//
//  MerchandiseManager.swift
//  GrailedTest
//
//  Created by Collin Chandler on 1/28/18.
//  Copyright © 2018 Collin Chandler. All rights reserved.
//

import Foundation
import SDWebImage

class MerchandiseManager: NetworkDelegate
{
    static let sharedInstance = MerchandiseManager()
    private let networkManager = NetworkingManager()
    public var delegate:ManagerDelegate?
    //Set initial value to 350 but should be set by view controller
    public var imageWidth:Int = 350
    //Our list of fully loaded merchandise objects
    public private(set) var merch:[Merchandise] = []
    private var imagesToLoad = 0
    private var loadingMerch = false
    
    func requestMerch() -> Bool
    {
        if(loadingMerch != true)
        {
            if(networkManager.requestMerchandise(_delegate: self))
            {
                loadingMerch = true
                return true
            }
        }
        return false
    }
    
    internal func networkError(_error: Error?)
    {
        self.delegate?.requestError(_error: _error)
    }
    
    //Network delegate function. Goes through returned JSON data and loads images. Request completes when images are loaded.
    internal func networkResult(_json: NSDictionary)
    {
        //Let's go through our JSON dictionary
        if let data:[Dictionary<String, Any>] = _json["data"] as? [ Dictionary<String, Any> ]
        {
            for item in data
            {
                var newMerch:Merchandise = Merchandise()
                //Load the item
                newMerch.load(_merchData: item)
                //Check it's published
                if(newMerch.published != true)
                {
                    continue
                }
                //It's published so we'll load the image and add it to our
                imagesToLoad += 1
                let formattedURL = ImageUtil.sharedInstance.formatURL(_url: newMerch.image_url, _width: String(imageWidth))
                SDWebImageManager.shared().loadImage(with: URL(string: formattedURL), options: .continueInBackground, progress: { (receivedSize, expectedSize, url) in
                    
                }) { (image, data, error, cachetype, finished, url) in
                    //Decrement our images to load
                    self.imagesToLoad -= 1
                    //Check for errors
                    if(error != nil)
                    {
                        self.delegate?.requestError(_error: error)
                        return
                    }
                    newMerch.image = image
                    //Add the fully loaded new merch
                    self.merch.append(newMerch)
                    //Call request complete when each image loads to allow for streaming results
                    self.delegate?.requestProgress()
                    if(self.imagesToLoad <= 0)
                    {
                        self.loadingMerch = false
                        self.imagesToLoad = 0
                        self.delegate?.requestComplete()
                    }
                }
            }
        }
    }
    
}
