//
//  ManagerDelegate.swift
//  GrailedTest
//
//  Created by Collin Chandler on 1/28/18.
//  Copyright © 2018 Collin Chandler. All rights reserved.
//

import Foundation

protocol ManagerDelegate
{
    func requestComplete()
    func requestProgress()
    func requestError(_error: Error?)
}
