//
//  MyServer.h
//  SocketServer
//
//  Created by 李剑钊 on 15/6/15.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocketDelegate <NSObject>
@optional
- (void)socketDidReceiveText:(NSString *)text;

@end

@interface MyServer : NSObject

@property (nonatomic, assign, readonly) BOOL isSocketOpened;
@property (nonatomic, weak) id<SocketDelegate>delegate;

- (void)initSocket;

- (void)sendData:(NSString *)text;

- (void)closeSocket;

@end
