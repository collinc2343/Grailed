//
//  FirstViewController.swift
//  GrailedTest
//
//  Created by Collin Chandler on 1/28/18.
//  Copyright © 2018 Collin Chandler. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ManagerDelegate
{
    @IBOutlet weak var articlesTable: UITableView!
    
    let articlesManager = ArticlesManager.sharedInstance
    var indicator:UIActivityIndicatorView?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        articlesTable.delegate = self
        articlesTable.dataSource = self
        
        //Setup indicator
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator?.activityIndicatorViewStyle = .gray
        indicator?.center = self.view.center
        indicator?.hidesWhenStopped = true
        indicator?.backgroundColor = UIColor.white
        self.view.addSubview(indicator!)
        //Set the image width so it caches correctly sized images when creating the articles
        articlesManager.imageWidth = Int(articlesTable.frame.width)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //Request the next page of articles
        if(articlesManager.articles.count < 1)
        {
            self.beginRequest()
        }
        else
        {
            self.articlesTable.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        indicator?.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //Further images load at half height
        articlesManager.imageWidth = articlesManager.imageWidth / 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageLabelCell", for: indexPath) as? ImageLabelCell
        let article = articlesManager.articles[indexPath.item]
        cell?.loadCell(_title: article.title, _image: article.image)
        return cell!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset
        //If we're close to the bottom and not already loading, request another page
        if(distanceFromBottom < height)
        {
            indicator?.startAnimating()
            self.beginRequest()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return articlesManager.articles.count
    }
    
    func beginRequest()
    {
        articlesManager.delegate = self
        //If we successfully request a page from the articles manager, start the progress indicator
        if(articlesManager.requestPage())
        {
            indicator?.startAnimating()
        }
    }
    //ManagerDelegate function when we have completed our request to the manager
    func requestComplete()
    {
        self.articlesTable.reloadData()
        self.articlesTable.layoutIfNeeded()
        indicator?.stopAnimating()
    }
    
    func requestProgress()
    {
        
    }
    
    func requestError(_error: Error?)
    {
        indicator?.stopAnimating()
        if(_error != nil)
        {
            let errMsg = UIAlertController(title: "Error", message: _error?.localizedDescription, preferredStyle: .alert)
            errMsg.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(errMsg, animated: true, completion: nil)
        }
    }
    
}

