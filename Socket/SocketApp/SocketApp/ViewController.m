//
//  ViewController.m
//  SocketApp
//
//  Created by 李剑钊 on 15/6/15.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import "ViewController.h"
#import "SocketHandle.h"
#import "GetIpAddress.h"

@interface ViewController ()<SocketDelegate>

@property (nonatomic, strong) SocketHandle *socketHan;
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITextView *outputTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_inputTextField resignFirstResponder];
    [_ipTextField resignFirstResponder];
}

- (IBAction)connectBtnTouch:(id)sender {
    [self.socketHan initSocket:_ipTextField.text];
}

- (IBAction)closeBtnTouch:(id)sender {
    [_socketHan closeSocket];
}

- (IBAction)sendBtnTouch:(id)sender {
    NSString *text = [NSString stringWithFormat:@"App: %@",_inputTextField.text];
    [_socketHan sendData:text];
    [_inputTextField resignFirstResponder];
}

#pragma mark - socket delegate

- (void)socketDidReceiveText:(NSString *)text {
    NSString *string = _outputTextField.text;
    if (!string) {
        string = @"";
    }
    if (string.length > 0) {
        string = [string stringByAppendingString:@"\n"];
    }
    string = [string stringByAppendingString:text];
    _outputTextField.text = string;
}

#pragma mark - getter and setter

- (SocketHandle *)socketHan {
    if (!_socketHan) {
        _socketHan = [SocketHandle new];
        _socketHan.delegate = self;
    }
    return _socketHan;
}

@end
