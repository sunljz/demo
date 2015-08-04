//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by 李剑钊 on 15/7/30.
//  Copyright © 2015年 sunli. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var tipsLabel: WKInterfaceLabel!
    @IBOutlet var colorBtn: WKInterfaceButton!
    var colorStyle = 0;
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.configTipsLabel()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func configTipsLabel() {
        let font = UIFont.systemFontOfSize(16)
        let helloDic = [NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        let mAttr = NSMutableAttributedString(string: "Hello World!", attributes: helloDic)
        
        let nameDic = [NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.yellowColor()]
        let nameAttr = NSAttributedString(string: " I'm a Developer", attributes: nameDic)
        
        mAttr.appendAttributedString(nameAttr)
    	tipsLabel.setAttributedText(mAttr)
    }

    @IBAction func buttonTouched() {
        if colorStyle == 0 {
            colorStyle = 1;
            colorBtn.setBackgroundColor(UIColor.grayColor())
        } else {
            colorStyle = 0;
            colorBtn.setBackgroundColor(UIColor.clearColor())
        }
    }
    
}
