//
//  IpAddress.h
//  SocketServer
//
//  Created by 李剑钊 on 15/6/16.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#ifndef __SocketServer__IpAddress__
#define __SocketServer__IpAddress__

#include <stdio.h>

#define MAXADDRS    32
extern char *if_names[MAXADDRS];
extern char *ip_names[MAXADDRS];
extern char *hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];
// Function prototypes
void InitAddresses();
void FreeAddresses();
void GetIPAddresses();
void GetHWAddresses();

#endif /* defined(__SocketServer__IpAddress__) */
