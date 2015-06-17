//
//  SocketHandle.m
//  SocketApp
//
//  Created by 李剑钊 on 15/6/15.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import "SocketHandle.h"
#include<stdio.h>
#include<unistd.h>
#include<strings.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<netdb.h>

#define PORT 6677

@interface SocketHandle () {
	
}

@property (nonatomic, assign) BOOL isIniting;
@property (nonatomic, assign) int app_socket;

@end

@implementation SocketHandle

- (instancetype)init
{
    self = [super init];
    if (self) {
		
    }
    return self;
}

- (void)initSocket:(NSString *)serverIp {
    if (_isIniting) {
        return;
    } else if (_isSocketOpened) {
        return;
    }
    
    self.isIniting = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *host = serverIp;
        
        // 创建socket
        int app_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
        if (app_socket < 0) {
            NSLog(@"create socket failed");
            return;
        }
        self.app_socket = app_socket;
        
        struct hostent *remoteHostEnt = gethostbyname([host UTF8String]);
        if (remoteHostEnt == NULL) {
            NSLog(@"host name is error");
            return;
        }
        struct in_addr *remoteInAddr = (struct in_addr *)remoteHostEnt->h_addr_list[0];
        // 服务器socket地址结构
        struct sockaddr_in server_addr;
        bzero(&server_addr, sizeof(server_addr));
        server_addr.sin_family = AF_INET;
        server_addr.sin_addr.s_addr = remoteInAddr->s_addr;
        server_addr.sin_port = htons(PORT);
        int connect_result = connect(app_socket, (struct sockaddr *)&server_addr, sizeof(server_addr));
        if (connect_result < 0) {
            NSLog(@"connect error");
            return;
        }
        
        _isSocketOpened = YES;
        _isIniting = NO;
        
        while (_isSocketOpened) {
            char buffer[30000];
            int lenght = sizeof(buffer);
            
            ssize_t result = recv(app_socket, buffer, 30000, 0);
            if (result > 0) {
                [self didReceiveBuffer:(const char *)buffer];
                NSLog(@"receive data:%s",buffer);
            } else {
                NSLog(@"receive data failed");
            }
        }
        [self closeSocket];
    });
}

- (void)sendData:(NSString *)str {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        const char *buffer = [str UTF8String];
        ssize_t result = send(_app_socket, buffer, strlen(buffer), 0);
        if (result > 0) {
            NSLog(@"send data success");
        } else {
            NSLog(@"send data failed");
        }
    });
}

- (void)didReceiveBuffer:(const char *)buffer {
    NSString *text = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
    if ([_delegate respondsToSelector:@selector(socketDidReceiveText:)]) {
        if ([NSThread isMainThread]) {
            [_delegate socketDidReceiveText:text];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate socketDidReceiveText:text];
            });
        }
    }
}

- (void)closeSocket {
    if (_isSocketOpened) {
        close(_app_socket);
        _isSocketOpened = NO;
        _isIniting = NO;
    }
}

@end
