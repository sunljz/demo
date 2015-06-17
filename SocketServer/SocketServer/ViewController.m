//
//  ViewController.m
//  SocketServer
//
//  Created by 李剑钊 on 15/6/15.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import "ViewController.h"
#import "MyServer.h"
#import "GetIpAddress.h"

@interface ViewController ()<SocketDelegate>

@property (nonatomic, strong) MyServer *server;
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _ipLabel.text = [GetIpAddress getDeviceIpAddress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event

- (IBAction)initSocketBtnTouch:(id)sender {
    [self.server initSocket];
}

- (IBAction)closeBtnTouch:(id)sender {
    [_server closeSocket];
}
- (IBAction)sendBtnTouch:(id)sender {
    NSString *text = [NSString stringWithFormat:@"Server: %@",_inputTextField.text];
    [_server sendData:text];
    [_inputTextField resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_inputTextField resignFirstResponder];
}

#pragma mark - socket delegate

- (void)socketDidReceiveText:(NSString *)text {
    NSString *string = _outputTextView.text;
    if (!string) {
        string = @"";
    }
    if (string.length > 0) {
        string = [string stringByAppendingString:@"\n"];
    }
    string = [string stringByAppendingString:text];
    _outputTextView.text = string;
}

#pragma mark - getter and setter

- (MyServer *)server {
    if (!_server) {
        _server = [MyServer new];
        _server.delegate = self;
    }
    return _server;
}

@end
