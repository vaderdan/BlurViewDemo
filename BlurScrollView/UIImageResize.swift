//
//  UIImageResize.swift
//  BlurScrollView
//
//  Created by Danny on 9/25/15.
//  Copyright © 2015 Danny. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    func resizeWithSize(size:CGSize) -> UIImage{
        let horizontalRatio:CGFloat = size.width / self.size.width;
        let verticalRatio:CGFloat = size.height / self.size.height;
        let ratio:CGFloat = max(horizontalRatio, verticalRatio);
        let newSize:CGSize = CGSizeMake(ceil(self.size.width * ratio), ceil(self.size.height * ratio));
        
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        
        if(UIGraphicsGetCurrentContext() == nil){
            return self;
        }

        self.drawInRect(CGRectMake(ceil((size.width - newSize.width) / 2), ceil((size.height - newSize.height) / 2), newSize.width, newSize.height));
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        return newImage;
    }
}