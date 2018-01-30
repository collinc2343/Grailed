//
//  SecondViewController.swift
//  GrailedTest
//
//  Created by Collin Chandler on 1/28/18.
//  Copyright © 2018 Collin Chandler. All rights reserved.
//

import UIKit

class MerchandiseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ManagerDelegate
{
    @IBOutlet weak var merchTable: UITableView!
    var shouldReloadOnScrollToBottom = false
    var bottomReached = false
    var reloadTimer:Timer?
    var savedContentOffset:CGPoint?
    let merchManager = MerchandiseManager.sharedInstance
    var indicator:UIActivityIndicatorView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        merchTable.delegate = self
        merchTable.dataSource = self
        //Setup indicator
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator?.activityIndicatorViewStyle = .gray
        indicator?.center = self.view.center
        indicator?.hidesWhenStopped = true
        indicator?.backgroundColor = UIColor.white
        self.view.addSubview(indicator!)
        //Set the image width so it caches correctly sized images when creating the merchandis
        merchManager.imageWidth = Int(self.merchTable.frame.width)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //Request the next page of articles
        if(merchManager.merch.count < 1)
        {
            //Request the merchandise
            self.beginRequest()
        }
        else
        {
            merchTable.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        indicator?.stopAnimating()
        reloadTimer?.invalidate()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //Further images load at half height
        merchManager.imageWidth = merchManager.imageWidth / 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageLabelCell", for: indexPath) as? ImageLabelCell
        let merch = merchManager.merch[indexPath.item]
        cell?.loadCell(_title: merch.name, _image: merch.image)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        //When all of our cells are displayed, stop the progress indicator. Delayed until this is done so it doesn't request multiple pages at a time
        if(indexPath.row == tableView.indexPathsForVisibleRows?.last?.row)
        {

        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return merchManager.merch.count
    }
    
    func beginRequest()
    {
        merchManager.delegate = self
        if(merchManager.requestMerch())
        {
            indicator?.startAnimating()
        }
    }
    
    @objc func stopIndicator()
    {
        indicator?.stopAnimating()
    }
    
    //Since the results are streaming in, I want to start the progress indicator if the user scrolls to the bottom of the table
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset
        if(distanceFromBottom < height)
        {
            indicator?.startAnimating()
            if(shouldReloadOnScrollToBottom)
            {
                self.merchTable.isUserInteractionEnabled = false
                bottomReached = true
            }
        }
        
    }
    
    //Since the results are streaming in, I want to stop the progress indicator now that scrolling has ended and reload the table
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        self.merchTable.isUserInteractionEnabled = true
        if(shouldReloadOnScrollToBottom && bottomReached)
        {
            //Reset these bools
            shouldReloadOnScrollToBottom = false
            bottomReached = false
            self.merchTable.reloadData()
            self.merchTable.layoutIfNeeded()
            indicator?.stopAnimating()
        }
    }
    
    //ManagerDelegate function when we have completed our request to the manager
    func requestComplete()
    {
        //Get rid of our indicator since we won't need it anymore
        indicator?.removeFromSuperview()
        indicator = nil
    }
    
    func requestProgress()
    {
        //The first few we can just reload data for each. After that let's wait till we scroll to the bottom to reload
        if(merchManager.merch.count < 6)
        {
            self.merchTable.reloadData()
            self.merchTable.layoutIfNeeded()
        }
        else
        {
            indicator?.stopAnimating()
            shouldReloadOnScrollToBottom = true
        }
    }
    
    func requestError(_error: Error?)
    {
        let errMsg = UIAlertController(title: "Error", message: _error?.localizedDescription, preferredStyle: .alert)
        errMsg.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(errMsg, animated: true, completion: nil)
    }

}

