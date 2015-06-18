//
//  LogoController.swift
//  yousdt
//
//  Created by You.Xiang on 15/6/16.
//  Copyright (c) 2015年 You.Xiang. All rights reserved.
//

import UIKit

class LogoController: UIImageView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //设置logo圆角
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
        
        //边框
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7).CGColor
    }
    //logo旋转
    func FlipForLogo(){
        //动画实例
        var animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = M_PI*2.0
        animation.duration = 20
        animation.repeatCount = 1000
        self.layer.addAnimation(animation, forKey: nil)
    }
}
