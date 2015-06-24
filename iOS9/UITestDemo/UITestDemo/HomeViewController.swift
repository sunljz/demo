//
//  ViewController.swift
//  UITestDemo
//
//  Created by 李剑钊 on 15/6/17.
//  Copyright © 2015年 sunli. All rights reserved.
//

import UIKit

let name = "sun"
let psd = "111111"

let myTitle = "登录"
let loadingText = "登录中.."

var firstAppear = true;

class HomeViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var psdField: UITextField!
	
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = myTitle;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginBtnTouch(sender: UIButton) {
        self.nameField.resignFirstResponder();
        self.psdField.resignFirstResponder();
        self.title = loadingText;
        sender.enabled = false
        let queue = NSOperationQueue.init();
        queue.addOperationWithBlock { () -> Void in
            // 模拟验证的过程
            NSThread.sleepForTimeInterval(2)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.title = myTitle;
                sender.enabled = true
                if self.nameField.text == name && self.psdField.text == psd {
                    let userDef = NSUserDefaults.standardUserDefaults()
                    userDef.setObject(self.nameField.text!, forKey: "name");
                    let sb = UIStoryboard.init(name:"Main",bundle:NSBundle.mainBundle())
                    let viewCro = sb.instantiateViewControllerWithIdentifier("InfoViewController")
                    self.navigationController!.pushViewController(viewCro, animated: true)
                } else {
                    let alert = UIAlertView.init(title:"",message:"登录失败",delegate:nil,cancelButtonTitle:"确定")
                    alert.accessibilityIdentifier = "loginAlert"
                    alert.accessibilityLabel = "loginAlert"
                    alert.show()
                }
            })
        }
    }

    @IBAction func clearBtnTouch(sender: UIButton) {
        self.nameField.text = nil;
        self.psdField.text = nil;
        self.nameField.resignFirstResponder();
        self.psdField.resignFirstResponder();
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.nameField.resignFirstResponder();
        self.psdField.resignFirstResponder();
    }
    
    override func viewDidAppear(animated: Bool) {
        /* 系统以外的测试方式，有兴趣可以了解一下
        if firstAppear {
            firstAppear = false
            CustomTestCode.loginTest()
        }
        */
    }
}

extension HomeViewController: UIAlertViewDelegate {
    
}