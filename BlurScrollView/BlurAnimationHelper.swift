//
//  BlurAnimationHelper.swift
//  BlurScrollView
//
//  Created by Danny on 9/28/15.
//  Copyright © 2015 Danny. All rights reserved.
//

import Foundation
import UIKit


class BlurAnimationHelper: NSObject, UITableViewDelegate {
    var tableView:UITableView
    var scrollPosition:CGPoint!
    var selectedCell:BlurCell!
    var tapGesture:UITapGestureRecognizer!
    
    lazy var cellContainer:UIView = {
        let cellContainer = UIView.init(frame: self.tableView.frame)
        if let superview = self.tableView.superview{
            superview.addSubview(cellContainer)
        }
    
        return cellContainer
    }()
    
    lazy var blurView:UIVisualEffectView = {
        let darkBlur = UIBlurEffect(style: .Dark)
        let darkBlurView = UIVisualEffectView(effect: darkBlur)
        darkBlurView.frame = self.tableView.frame
        if let superview = self.tableView.superview{
            superview.addSubview(darkBlurView)
        }
        
        return darkBlurView
    }()
    
    init(tableView:UITableView) {
        self.tableView = tableView
    }
    
    func configure(){
        self.tapGesture = UITapGestureRecognizer.init(target: self, action: "tap:")
        self.blurView.addGestureRecognizer(self.tapGesture)
        
        blurView.alpha = 0
    }
    
    //MARK: Gesture recognizers
    func tableOnSelect(indexPath: NSIndexPath) {
        if(tableView.cellForRowAtIndexPath(indexPath)?.frame.origin == CGPointZero){
            setup(indexPath)
        }
        
        scrollPosition = tableView.contentOffset
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
    }
    
    func tableOnAnimate() {
        if let indexPath = tableView.indexPathForSelectedRow {
            setup(indexPath)
        }
    }
    
    func tap(recognize:UITapGestureRecognizer){
        if let indexPath = tableView.indexPathForSelectedRow  {
            teardown(indexPath)
        }
    }
    
    //MARK: setup and teardown
    
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

