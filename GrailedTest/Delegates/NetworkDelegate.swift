//
//  NetworkDelegate.swift
//  GrailedTest
//
//  Created by Collin Chandler on 1/28/18.
//  Copyright © 2018 Collin Chandler. All rights reserved.
//

import Foundation

protocol NetworkDelegate
{
    func networkResult(_json: NSDictionary)
    func networkError(_error: Error?)
}
