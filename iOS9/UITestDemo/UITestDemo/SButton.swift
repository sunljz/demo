//
//  SButton.swift
//  UITestDemo
//
//  Created by 李剑钊 on 15/6/19.
//  Copyright © 2015年 sunli. All rights reserved.
//

import UIKit

/// 仅仅是为了测试子类而创建的
class SButton: UIButton {
    override func awakeFromNib() {
        self.layer.cornerRadius = 4;
        self.layer.borderColor = UIColor.grayColor().CGColor;
        self.layer.borderWidth = 1;
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
