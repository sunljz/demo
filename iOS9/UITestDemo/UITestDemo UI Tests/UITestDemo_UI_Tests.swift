//
//  UITestDemo_UI_Tests.swift
//  UITestDemo UI Tests
//
//  Created by 李剑钊 on 15/6/17.
//  Copyright © 2015年 sunli. All rights reserved.
//

import Foundation
import XCTest

class UITestDemo_UI_Tests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
		testLoginView()
    }
    
    func testLoginView() {
        let app = XCUIApplication()
        
        // 由于UITextField的id有问题，所以只能通过label的方式遍历元素来读取
        let nameField = self.getFieldWithLbl("nameField")
        if self.canOperateElement(nameField) {
            nameField!.tap()
            nameField!.typeText("xiaoming")
        }
        
        let psdField = self.getFieldWithLbl("psdField")
        if self.canOperateElement(psdField) {
            psdField!.tap()
            psdField!.typeText("1234321")
        }
        
        // 通过UIButton的预设id来读取对应的按钮
        let loginBtn = app.buttons["Login"]
        if self.canOperateElement(loginBtn) {
            loginBtn.tap()
        }
        
        // 开始一段延时，由于真实的登录是联网请求，所以不能直接获得结果，demo通过延时的方式来模拟联网请求
        let window = app.windows.elementAtIndex(0)
        if self.canOperateElement(window) {
            // 延时3秒, 3秒后如果登录成功，则自动进入信息页面，如果登录失败，则弹出警告窗
            window.pressForDuration(3)
        }
        
        // alert的id和labe都用不了，估计还是bug，所以只能通过数量判断
        if app.alerts.count > 0 {
            // 登录失败
            app.alerts.collectionViews.buttons["确定"].tap()
            
            let clear = app.buttons["Clear"]
            if self.canOperateElement(clear) {
                clear.tap()
                
                if self.canOperateElement(nameField) {
                    nameField!.tap()
                    nameField!.typeText("sun")
                }
                
                if self.canOperateElement(psdField) {
                    psdField!.tap()
                    psdField!.typeText("111111")
                }
                
                if self.canOperateElement(loginBtn) {
                    loginBtn.tap()
                }
                if self.canOperateElement(window) {
                    // 延时3秒, 3秒后如果登录成功，则自动进入信息页面，如果登录失败，则弹出警告窗
                    window.pressForDuration(3)
                }
                self.loginSuccess()
            }
        } else {
            // 登录成功
            self.loginSuccess()
        }
    }
    
    func loginSuccess() {
        let app = XCUIApplication()
        let window = app.windows.elementAtIndex(0)
        if self.canOperateElement(window) {
            // 延时1秒, push view需要时间
            window.pressForDuration(1)
        }
        self.testInfo()
    }
    
    func testInfo() {
        let app = XCUIApplication()
        let window = app.windows.elementAtIndex(0)
        if self.canOperateElement(window) {
            // 延时2秒, 加载数据需要时间
            window.pressForDuration(2)
        }
        
        let modifyBtn = app.buttons["modify"];
        modifyBtn.tap()
        
        let sexSwitch = app.switches["sex"]
        sexSwitch.tap()
        
        let incrementButton = app.buttons["Increment"]
        incrementButton.tap()
        incrementButton.tap()
        incrementButton.tap()
        app.buttons["Decrement"].tap()
        
        let textView = app.textViews["feeling"]
        textView.tap()
        app.keys["Delete"].tap()
        app.keys["Delete"].tap()
        textView.typeText(" abc ")
        
        // 点击空白区域
        let clearBtn = app.buttons["clearBtn"]
        clearBtn.tap()
		
        // 保存数据
        modifyBtn.tap()
        window.pressForDuration(2)
        
        let messageBtn = app.buttons["message"]
        messageBtn.tap();
        
        // 延时1秒, push view需要时间
        window.pressForDuration(1)
        
        self.testMessage()
    }
    
    func testMessage() {
        let app = XCUIApplication()
        let window = app.windows.elementAtIndex(0)
        if self.canOperateElement(window) {
            // 延时2秒, 加载数据需要时间
            window.pressForDuration(2)
        }
        
        let table = app.tables
        table.childrenMatchingType(.Cell).elementAtIndex(8).tap()
        table.childrenMatchingType(.Cell).elementAtIndex(1).tap()
        
    }
    
    func getFieldWithLbl(label:String) -> XCUIElement? {
        var result:XCUIElement? = nil
        return self.getElementWithLbl(label, type: XCUIElementType.TextField)
    }
    
    func getElementWithLbl(label:String, type:XCUIElementType) -> XCUIElement? {
        let app = XCUIApplication()
        let query = app.descendantsMatchingType(type)
        var result:XCUIElement? = nil
        for var i:UInt = 0; i < query.count; i++ {
            let element:XCUIElement = query.elementAtIndex(i)
            let subLabel:String? = element.label;
            if subLabel != nil {
                if subLabel == label {
                    result = element
                }
            }
        }
        return result
    }
	
    func canOperateElement(element:XCUIElement?) -> Bool {
        if element != nil {
            if element!.exists {
                return true
            }
        }
        return false
    }
}
