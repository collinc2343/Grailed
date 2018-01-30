//
//  NetworkingManager.swift
//  GrailedTest
//
//  Created by Collin Chandler on 1/28/18.
//  Copyright © 2018 Collin Chandler. All rights reserved.
//

import Foundation
import Alamofire

public class NetworkingManager
{
    private let SERVER_URL = "https://www.grailed.com/"
    private let ARTICLES_ENDPOINT = "api/articles/ios_index"
    private let MERCHANDISE_ENDPOINT = "api/merchandise/marquee"
    private let PAGE_PARAMETER = "?page="
    
    func requestArticles(_delegate: NetworkDelegate, _page: NSInteger) -> Bool
    {
        let url = SERVER_URL + ARTICLES_ENDPOINT + PAGE_PARAMETER + String(_page)
        return self.request(_url: url, _delegate: _delegate)
    }
    
    func requestMerchandise(_delegate: NetworkDelegate) -> Bool
    {
        let url = SERVER_URL + MERCHANDISE_ENDPOINT
        return self.request(_url: url, _delegate: _delegate)
    }
    
    private func request(_url: String, _delegate: NetworkDelegate) -> Bool
    {
        Alamofire.request(_url).responseJSON { _response in
            if let json:NSDictionary = _response.result.value as? NSDictionary
            {
                _delegate.networkResult(_json: json)
            }
            else
            {
                _delegate.networkError(_error: _response.error)
            }
        }
        
        return true
    }
    
}
