//
//  ArticlesManager.swift
//  GrailedTest
//
//  Created by Collin Chandler on 1/28/18.
//  Copyright © 2018 Collin Chandler. All rights reserved.
//

import Foundation
import SDWebImage

class ArticlesManager: NetworkDelegate
{
    static let sharedInstance = ArticlesManager()
    private let networkManager = NetworkingManager()
    private var maxPageReached = false
    public var delegate:ManagerDelegate?
    //Set initial value to 350 but should be set by view controller
    public var imageWidth:Int = 350
    public private(set) var articlesPage = 1
    public private(set) var articles:[Article] = []
    private var imagesToLoad = 0
    private var loadingArticlePage = false
    init()
    {
        SDWebImageManager.shared().imageDownloader?.downloadTimeout = 30
    }
    
    deinit
    {

    }
    
    func requestPage() -> Bool
    {
        if(!loadingArticlePage)
        {
            if(!maxPageReached)
            {
                if(networkManager.requestArticles(_delegate: self, _page: articlesPage))
                {
                    loadingArticlePage = true
                    articlesPage += 1
                    return true
                }
            }
            else
            {
                self.delegate?.requestError(_error: nil)
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
        if let data:[Dictionary<String, Any>] = _json["data"] as? [ Dictionary<String, Any> ]
        {
            var articleFound = false
            var articleLoadingComplete = false
            for item in data
            {
                articleFound = true
                var newArticle:Article = Article()
                newArticle.load(_articleData: item)
                if(newArticle.published != true)
                {
                    continue
                }
                //Add to the number of images to load, when this number decrements back to 0 the request will be completed
                imagesToLoad += 1
                let formattedURL = ImageUtil.sharedInstance.formatURL(_url: newArticle.image_url, _width: String(imageWidth))
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
                    newArticle.image = image
                    self.articles.append(newArticle)
                    
                    if(self.imagesToLoad <= 0 && articleLoadingComplete)
                    {
                        self.delegate?.requestComplete()
                        self.loadingArticlePage = false
                        self.imagesToLoad = 0
                    }
                }
                
            }
            articleLoadingComplete = true
            if(!articleFound)
            {
                self.loadingArticlePage = false
                maxPageReached = true
            }
            
        }
    }
    
    
}
