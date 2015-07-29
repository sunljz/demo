//
//  ViewController.swift
//  SpringAnimation
//
//  Created by 李剑钊 on 15/7/28.
//  Copyright © 2015年 sunli. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let spring = CASpringAnimation(keyPath: "position.x")
        spring.damping = 5;
        spring.stiffness = 100;
        spring.mass = 1;
        spring.initialVelocity = -30;
        spring.fromValue = label.layer.position.x;
        spring.toValue = label.layer.position.x + 50;
        spring.duration = spring.settlingDuration;
        label.layer.addAnimation(spring, forKey: spring.keyPath);
    }
/*
	mass 质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
    stiffness 刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
    damping 阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
    initialVelocity 初始速率
    settlingDuration 结算时间 返回弹簧动画到停止时的估算时间，根据当前的动画参数估算
*/
}

