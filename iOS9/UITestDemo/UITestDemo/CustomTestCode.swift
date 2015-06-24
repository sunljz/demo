//
//  CustomTestCode.swift
//  UITestDemo
//
//  Created by 李剑钊 on 15/6/24.
//  Copyright © 2015年 sunli. All rights reserved.
//

import UIKit

/// 这里使用UI Tests以外的api进行自动化测试，限制比UI Tests小一些，但目前还有很多基础api没有建立起来
class CustomTestCode: NSObject {
    
    /// 根据accessibilityIdentifier查询view
    static func getViewWithId(identifier:String) -> UIView? {
        let window = UIApplication.sharedApplication().keyWindow
        if window == nil {
            return nil
        }
        let keyWin = window!
        var view:UIView? = nil
        
        /// 递归查询UI元素
        func querySubView(parentView:UIView) -> UIView? {
            let subViewArr = parentView.subviews
            
            for subView in subViewArr {
                /// 屏幕以外的直接忽略
                let rect = subView.convertRect(subView.frame, toView: keyWin)
                if CGRectIntersectsRect(keyWin.bounds, rect) == false {
                    continue
                }
                
                if subView.accessibilityIdentifier == identifier {
                    view = subView;
                    return view
                } else {
                    querySubView(subView)
                }
            }
            return nil;
        }
        
        querySubView(keyWin)
        
        return view
    }
    
    static func loginTest() {
        let nameF:UITextField? = self.getViewWithId("nameField") as? UITextField
        if nameF == nil {
            return
        }
        nameF!.becomeFirstResponder()
        nameF!.text = "sun"
        
        let psdF:UITextField? = self.getViewWithId("psdField") as? UITextField
        if psdF == nil {
            return
        }
        psdF!.becomeFirstResponder()
        psdF!.text = "111111"
        
        let view = self.getViewWithId("myView")
        view!.touchesEnded([], withEvent: nil)
        
        let loginBtn:UIButton? = self.getViewWithId("Login") as? UIButton
        loginBtn!.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
}
