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
    var scrollPosition:CGPoint!
    var selectedCell:BlurCell!
    var tapGesture:UITapGestureRecognizer!
    
    lazy var cellContainer:UIView = {
        let cellContainer = UIView.init(frame: self.view.frame)
        self.view.addSubview(cellContainer)
        
        return cellContainer
    }()
    
    lazy var blurView:UIVisualEffectView = {
        let darkBlur = UIBlurEffect(style: .Dark)
        let darkBlurView = UIVisualEffectView(effect: darkBlur)
        self.view.addSubview(darkBlurView)
        darkBlurView.frame = self.view.frame
        
        return darkBlurView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        blurView.alpha = 0
        
        self.tapGesture = UITapGestureRecognizer.init(target: self, action: "tap:")
        self.blurView.addGestureRecognizer(self.tapGesture)
        
        
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
    
    //MARK: Gesture recognizers
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView.cellForRowAtIndexPath(indexPath)?.frame.origin == CGPointZero){
            setup(indexPath)
            print("\(tableView.contentOffset)")
        }
        
        scrollPosition = tableView.contentOffset
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if let indexPath = tableView.indexPathForSelectedRow {
            setup(indexPath)
        }
    }
    
    func tap(recognize:UITapGestureRecognizer){
        if let indexPath = tableView.indexPathForSelectedRow  {
            teardown(indexPath)
        }
    }
    
    func setup(indexpath:NSIndexPath) {
        cellContainer.alpha = 1;
        

        
        
        for view in  cellContainer.subviews {
            view.removeFromSuperview()
        }
        
        if let cell = tableView.cellForRowAtIndexPath(indexpath) as? BlurCell {
            selectedCell = cell
            
            cellContainer.addSubview(selectedCell.contentView)
            
            var rect = tableView.rectForRowAtIndexPath(indexpath)
            rect.origin.y -= tableView.contentOffset.y
            cellContainer.frame = rect
            
            cell.show()
        }
        
        UIView.animateWithDuration(0.4) {
            self.blurView.alpha = 1
        }
    }
    
    func teardown(indexPath:NSIndexPath) {
        UIView.animateWithDuration(0.4) {
            self.blurView.alpha = 0
        }
        
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? BlurCell
        cell?.addSubview(selectedCell.contentView)
        tableView.setContentOffset(scrollPosition, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        cellContainer.alpha = 0;
        
        cell?.hide();
    }
}

