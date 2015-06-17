//
//  GetIpAddress.m
//  SocketServer
//
//  Created by 李剑钊 on 15/6/16.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import "GetIpAddress.h"
#import "IpAddress.h"

@implementation GetIpAddress

+ (NSString *)getDeviceIpAddress {
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    NSString *ip = [NSString stringWithFormat:@"%s", ip_names[1]];
    FreeAddresses();
    return ip;
}

@end
