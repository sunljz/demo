//
//  MyServer.m
//  SocketServer
//
//  Created by 李剑钊 on 15/6/15.
//  Copyright (c) 2015年 ;. All rights reserved.
//

#import "MyServer.h"
#include<stdio.h>
#include<unistd.h>
#include<strings.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<netdb.h>
#define PORT 6677
#define MAXDATASIZE 100
#define LENGTH_OF_LISTEN_QUEUE  20
#define BUFFER_SIZE 30000
#define THREAD_MAX    5

@interface MyServer ()

@property (nonatomic, assign) BOOL isIniting;
@property (atomic, assign) int server_socket;
@property (nonatomic, assign) int client_socket;

@end

@implementation MyServer

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initSocket {
    if (_isIniting) {
        return;
    } else if (_isSocketOpened) {
        return;
    }
    
    self.isIniting = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 服务器socket地址结构
        struct sockaddr_in server_addr;
        bzero(&server_addr, sizeof(server_addr));
        server_addr.sin_family = AF_INET;
        server_addr.sin_addr.s_addr = htons(INADDR_ANY);
        server_addr.sin_port = htons(PORT);
        
        // 创建socket
        int server_socket = socket(server_addr.sin_family, SOCK_STREAM, IPPROTO_TCP);
        if (server_socket < 0) {
            NSLog(@"create socket failed");
            return;
        }
        self.server_socket = server_socket;
        
        // 绑定socket
        int bind_socker = bind(server_socket, (const struct sockaddr *)&server_addr, sizeof(server_addr));
        if (bind_socker) {
            NSLog(@"bind socket failed");
            return;
        }
        
        int listen_socker = listen(server_socket, LENGTH_OF_LISTEN_QUEUE);
        if (listen_socker) {
            NSLog(@"listen socket failed");
            return;
        }
        
        _isSocketOpened = YES;
        _isIniting = NO;
        
        while (_isSocketOpened) {
            NSLog(@"socket star");
            struct sockaddr_in client_addr;
            socklen_t lenght = sizeof(client_addr);
            
            int new_client_socket = accept(server_socket, (struct sockaddr *)&client_addr, &lenght);
            if (new_client_socket < 0) {
                NSLog(@"server accept failed");
                break;
            }
            self.client_socket = new_client_socket;
            
            NSLog(@"once client connected");
            [self readSocket:new_client_socket];
        }
        
        [self closeSocket];
    });
}

- (void)readSocket:(int)clientSocket {
    char buffer[BUFFER_SIZE];
    buffer[0] = ' ';
    
    while (buffer[0] != '\0') {
        bzero(buffer, BUFFER_SIZE);
        // 接收客户端的信息到buffer中
        recv(clientSocket, buffer, BUFFER_SIZE, 0);
        NSLog(@"client buffer:%s",buffer);
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
    
//    NSLog(@"client close");
//    close(clientSocket);
}

- (void)sendData:(NSString *)text {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        const char *buffer = [text UTF8String];
        ssize_t result = send(_client_socket, buffer, strlen(buffer), 0);
        if (result < 0) {
            NSLog(@"send data failed");
        }
    });
}

- (void)closeSocket {
    if (_isSocketOpened) {
        close(_server_socket);
        _isSocketOpened = NO;
        _isIniting = NO;
    }
}

@end
