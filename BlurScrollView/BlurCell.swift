//
//  BlurCell.swift
//  BlurScrollView
//
//  Created by Danny on 9/25/15.
//  Copyright © 2015 Danny. All rights reserved.
//

import Foundation
import UIKit

class BlurCell :UITableViewCell{

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var containerView: UIView!
    
    @IBAction func likeAction(sender: AnyObject) {
        likeButton.selected = !likeButton.selected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(firstName firstName:String, lastName:String, avatar:UIImage, coverImage:UIImage, liked:Bool){
        
        self.firstName.text = firstName
        self.lastName.text = lastName
        self.avatar.image = avatar.resizeWithSize(self.frame.size)
        self.coverImage.image = coverImage.resizeWithSize(self.frame.size)
        
        self.likeButton.setImage(UIImage.init(named: "like_clear.png"), forState: .Normal)
        self.likeButton.setImage(UIImage.init(named: "like.png"), forState: .Selected)
    }
    
    func show(){
        contentView.transform = CGAffineTransformIdentity
    
        let animation = CAKeyframeAnimation.init()
        animation.keyPath = "transform.scale";
        animation.values = [ 1, 1.1, 1 ];
        animation.keyTimes = [ 0.1, 0.4, 1 ];
        animation.duration = 0.4;
    
        contentView.layer.addAnimation(animation, forKey: "shake")
        

        UIView.animateWithDuration(0.2) { () -> Void in
            self.containerBottomConstraint.constant = -60
            self.containerView.layoutIfNeeded()
        }
    }
    
    func hide(){
        containerView.autoresizesSubviews = false
        UIView.animateWithDuration(0.2) { () -> Void in
            self.containerBottomConstraint.constant = 0
            self.containerView.layoutIfNeeded()
        }
    }
}


