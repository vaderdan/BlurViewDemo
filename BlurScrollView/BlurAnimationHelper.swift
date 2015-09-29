//
//  BlurAnimationHelper.swift
//  BlurScrollView
//
//  Created by Danny on 9/28/15.
//  Copyright © 2015 Danny. All rights reserved.
//

import Foundation
import UIKit

infix operator <^> { associativity left }
func <^><A, B>(a: A?, f: (A -> B)?) -> B? {
    if let a = a, let f = f {
        return f(a)
    }
    else{
        return nil
    }
}

infix operator <*> { associativity left }
func <*><A, B>(optionalTransform: (A -> B)?, optionalValue: A?) -> B? {
    if let transform = optionalTransform {
        if let value = optionalValue {
            return transform(value)
        }
    }
    return nil
}

func curry<A, B, C>(f: (A, B) -> C) -> A -> B -> C {
    return { x in { y in f(x, y) } }
}

func uncurry<A, B, C>(f: A -> B -> C) -> (A, B) -> C {
    return { x, y in f(x)(y) }
}

func flipOr<B, C>(b:Bool, f: (B, B) -> C) -> (B, B) -> C {
    if(b == true){
        return { (x, y) in f(y, x) }
    }
    else{
        return { (x, y) in f(x, y) }
    }
}

func runFirst<A, B>(f1: A, f2: B) -> A  {
    return f1
}


class BlurAnimationHelper: NSObject, UITableViewDelegate {
    var tableView:UITableView
    var scrollPosition:CGPoint!
    var selectedCell:BlurCell!
    var tapGesture:UITapGestureRecognizer!
    
    lazy var cellContainer:UIView = {
        let cellContainer = UIView.init(frame: self.tableView.frame)
        if let superview = self.tableView.superview{
            superview.addSubview(cellContainer)
            superview.bringSubviewToFront(cellContainer)
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
            setupanimate(true, indexPath:indexPath)
        }
        
        scrollPosition = tableView.contentOffset
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
    }
    
    func tableOnAnimate() {
        if let indexPath = tableView.indexPathForSelectedRow {
            setupanimate(false, indexPath:indexPath)
        }
    }
    
    func tap(recognize:UITapGestureRecognizer){
        if let indexPath = tableView.indexPathForSelectedRow  {
            setupanimate(true, indexPath:indexPath)
        }
    }
    
    //MARK: setup and teardown

    func putView(fromView:UIView, toView:UIView){
        print("\(fromView) \(toView)")
        toView.addSubview(fromView)
    }

    func animateAlpha(fromValue:CGFloat, toValue:CGFloat){
        cellContainer.alpha = toValue;
        cellContainer.backgroundColor = UIColor.redColor()
        self.blurView.alpha = fromValue
        UIView.animateWithDuration(0.4) {
            self.blurView.alpha = toValue
        }
    }

    func setupanimate(teardown:Bool, indexPath:NSIndexPath){
        if(teardown == false){
            curry(putView) <*>  tableView.cellForRowAtIndexPath(indexPath)?.contentView <*> cellContainer
        }
        else{
            curry(putView) <*>  cellContainer.subviews[0] <*> tableView.cellForRowAtIndexPath(indexPath)
        }

        curry(flipOr(teardown, f: animateAlpha)) <*> 0 <*> 1

        
        
        (tableView.cellForRowAtIndexPath(indexPath) as? BlurCell) <^> { (cell:BlurCell) in
            var rect = cell.frame
            rect.origin.y -= self.tableView.contentOffset.y
            self.cellContainer.frame = rect
            
            return cell
        } <^> { (cell: BlurCell) in
            let a = (teardown == true) ? cell.hide : cell.show
            a()
        }
    }
}

