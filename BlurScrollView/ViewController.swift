//
//  ViewController.swift
//  BlurScrollView
//
//  Created by Danny on 9/25/15.
//  Copyright © 2015 Danny. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let firstNames = ["Ivan", "Chirs", "Vlado"]
    let lastNames = ["Mury", "Todd", "Rundeldav"]
    var animationHelper:BlurAnimationHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animationHelper = BlurAnimationHelper.init(tableView: tableView)
        animationHelper.configure()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: tableview methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:BlurCell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! BlurCell
        
        let coverImage = String.init(format: "%d.png", arc4random()%9+1)
        let firstName = firstNames[Int(arc4random()%3)]
        let lastName = lastNames[Int(arc4random()%3)]
        cell.setup(firstName:firstName, lastName:lastName, avatar:UIImage.init(named: "man.png")!, coverImage:UIImage.init(named: coverImage)!, liked: true)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        animationHelper.tableOnSelect(indexPath)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        animationHelper.tableOnAnimate()
    }
}

