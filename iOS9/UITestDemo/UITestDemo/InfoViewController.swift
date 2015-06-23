//
//  InfoViewController.swift
//  UITestDemo
//
//  Created by 李剑钊 on 15/6/17.
//  Copyright © 2015年 sunli. All rights reserved.
//

import UIKit

let sexKey = "sex"
let agekey = "age"
let feelingKey = "feeling"

class InfoViewController: UIViewController {
    @IBOutlet weak var sexSwitch: UISwitch!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageStep: UIStepper!
    @IBOutlet weak var feelingTxtView: UITextView!
    @IBOutlet weak var modifyBtn: UIButton!
    
    var isChangingInfo = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ageStep.accessibilityIdentifier = "ageStep"
        self.ageStep.minimumValue = 0
        self.ageStep.maximumValue = 100
        self.sexSwitch.enabled = false;
        self.ageStep.enabled = false;
        self.feelingTxtView.userInteractionEnabled = false;
        
        self.title = "读取中.."
        let queue = NSOperationQueue.init();
        queue.addOperationWithBlock { () -> Void in
            // 模拟读取数据的过程
            NSThread.sleepForTimeInterval(2)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.configInfoView()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configInfoView() {
        let userDef = NSUserDefaults.standardUserDefaults()
        self.title = userDef.stringForKey("name")
        self.sexSwitch.on = userDef.boolForKey(sexKey)
        let age = userDef.stringForKey(agekey)
        self.ageLabel.text = age;
        if age != nil {
            self.ageStep.value = Double(age!)!
        }
        self.feelingTxtView.text = userDef.stringForKey(feelingKey)
    }
    
    @IBAction func modifyBtnTouch(sender: UIButton) {
        if self.isChangingInfo {
            self.toSaveInfo()
        } else {
            self.toModifyInfo()
        }
    }
    
    func toModifyInfo() {
        self.isChangingInfo = true;
        self.modifyBtn.setTitle("完成", forState: UIControlState.Normal)
        self.sexSwitch.enabled = true;
        self.ageStep.enabled = true;
        self.feelingTxtView.userInteractionEnabled = true;
    }
    
    func toSaveInfo() {
        self.isChangingInfo = false;
        self.feelingTxtView.resignFirstResponder()
        self.modifyBtn.setTitle("修改", forState: UIControlState.Normal)
        self.sexSwitch.enabled = false;
        self.ageStep.enabled = false;
        self.feelingTxtView.userInteractionEnabled = false;
        
        let myTitle = self.title
        self.title = "保存中.."
        self.modifyBtn.enabled = false
        
        let queue = NSOperationQueue.init()
        queue.addOperationWithBlock { () -> Void in
            // 模拟网络请求过程
            NSThread.sleepForTimeInterval(2)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.title = myTitle;
                self.modifyBtn.enabled = true
                
                let userDef = NSUserDefaults.standardUserDefaults()
                userDef.setBool(self.sexSwitch.on, forKey: sexKey)
                let age = String(Int(self.ageStep.value))
                userDef.setObject(age, forKey: agekey)
                let text = self.feelingTxtView.text;
                if text != nil {
                    userDef.setObject(text, forKey: feelingKey)
                } else {
                    userDef.removeObjectForKey(feelingKey)
                }
            })
        }
    }
    
    @IBAction func ageStepValueChanged(sender: UIStepper) {
        let age = String(Int(self.ageStep.value))
        self.ageLabel.text = age;
    }
    
    @IBAction func clearBtnTouch(sender: AnyObject) {
        self.feelingTxtView.resignFirstResponder()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.feelingTxtView.resignFirstResponder()
    }
}
