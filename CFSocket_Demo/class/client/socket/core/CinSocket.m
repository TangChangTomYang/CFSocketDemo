//
//  CinSocket.m
//  CFSocket_Demo
//
//  Created by edz on 2020/7/27.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "CinSocket.h"
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>

@interface CinSocket(){
    BOOL _isAddress;
    CFSocketRef _socketRef;
    SCNetworkReachabilityRef _reachability;
}


@property (nonatomic, strong) CinRunLoop *sRunLoop;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, assign) int port;
@property (nonatomic, assign) BOOL isIPv6;
@property (nonatomic, strong) NSData *addr6Data;
@property (nonatomic, strong) NSData *addr4Data;
@property (nonatomic, copy) NSString *sockAddr;
@property (nonatomic, assign) BOOL isSocketConnected;

@end

@implementation CinSocket
  
- (void)dealloc {
    [self performSelector:@selector(innerDealloc) onThread:[self.sRunLoop getThread] withObject:nil waitUntilDone:YES];
}

- (void)innerDealloc {
    _sockAddr = nil;
    [self releaseSocket];
    [self releaseRearch];
}



- (id)initAddress:(NSString *)address withRunLoop:(CinRunLoop *)runLoop {
    NSArray *temp = [address componentsSeparatedByString:@":"];
    NSAssert((temp != nil && [temp count] > 1), [@"Illegal argument: address, " stringByAppendingString:address]);
    NSString *port = [temp objectAtIndex:temp.count - 1];
    NSString *ip = [address substringToIndex:(address.length - port.length - 1)];
    ip = [self getDNSWithDomain:ip];
    
    return [self initIP:ip withPort:[port intValue] withRunLoop:runLoop];
}

- (id)initIP:(NSString *)ip withPort:(int)port withRunLoop:(CinRunLoop *)runLoop {
    self = [super init];
    if (self) {
        self.ip = ip;
        self.port = port;
        self.sRunLoop = runLoop;
        self.isSocketConnected = NO;
        self.enableLog = NO;
        [self initAddress];
    }
    return self;
}

- (void)initAddress {
    if ([_ip rangeOfString:@":"].location == NSNotFound) {//ipv4地址
        self.isIPv6 = NO;
        struct sockaddr_in addr4;
        memset(&addr4, 0, sizeof(addr4));
        addr4.sin_len = sizeof(addr4);
        addr4.sin_family = AF_INET;
        addr4.sin_port = htons(_port);
        addr4.sin_addr.s_addr = inet_addr([_ip UTF8String]);
        self.addr4Data = [NSData dataWithBytes:&addr4 length:sizeof(addr4)];
    }
    else {
        //ipv6地址
        self.isIPv6 = YES;
        struct sockaddr_in6 addr6;
        memset(&addr6, 0, sizeof(addr6));
        addr6.sin6_len = sizeof(addr6);
        addr6.sin6_family = AF_INET6;
        addr6.sin6_port = htons(_port);
        inet_pton(AF_INET6, _ip.UTF8String, &addr6.sin6_addr);
        self.addr6Data = [NSData dataWithBytes:&addr6 length:sizeof(addr6)];
    }
}

- (NSString *)getDNSWithDomain:(NSString *)ip {
    NSString *ipStr = [self getIPWithHostName:ip];
    
    NSArray *ipv6Array = [self getIPv6WithHostName:ip];
    if (ipv6Array && ipv6Array.count > 0) {
        ipStr = [ipv6Array objectAtIndex:0];
    }
    
    return ipStr;
}

- (NSString *)getIPWithHostName:(const NSString *)hostName{
    
    const char *hostN= [hostName UTF8String];
    struct hostent* phot;
    
    @try {
        phot = gethostbyname(hostN);
    }
    @catch (NSException *exception) {
        return nil;
    }
    
    struct in_addr ip_addr;
    //域名情况下断网重连崩溃问题修复
    if(phot!=NULL){
        memcpy(&ip_addr, phot->h_addr_list[0], 4);
        _isAddress = YES;
    }
    else {
        _isAddress = NO;
        return @"";
    }
//    else{
//        memcpy(&ip_addr, "0.0.0.0", 4);
//    }
//    memcpy(&ip_addr, phot->h_addr_list[0], 4);
    char ip[20] = {0};
    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    return strIPAddress;
}


- (NSArray *)getIPv6WithHostName:(const NSString *)hostName {
    const char *hostN= [hostName UTF8String];
    struct hostent* phot;
    
    @try {
        phot = gethostbyname2(hostN, AF_INET6);
        
    }
    @catch (NSException *exception) {
        return nil;
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    int j = 0;
    while (phot && phot->h_addr_list && phot->h_addr_list[j]) {
        struct in6_addr ip6_addr;
        memcpy(&ip6_addr, phot->h_addr_list[j], sizeof(struct in6_addr));
        NSString *strIPAddress = [self formatIPV6Address: ip6_addr];
        [result addObject:strIPAddress];
        j++;
        _isAddress = YES;
    }
    
    return [NSArray arrayWithArray:result];
}

- (NSString *)formatIPV6Address:(struct in6_addr)ipv6Addr{
    NSString *address = nil;
    
    char dstStr[INET6_ADDRSTRLEN];
    char srcStr[INET6_ADDRSTRLEN];
    memcpy(srcStr, &ipv6Addr, sizeof(struct in6_addr));
    if(inet_ntop(AF_INET6, srcStr, dstStr, INET6_ADDRSTRLEN) != NULL){
        address = [NSString stringWithUTF8String:dstStr];
    }
    
    return address;
}

#pragma mark- getter


-(BOOL)isAddress{
    return _isAddress;
}

-(NSString *)socketAddress{
    return _sockAddr;
}

-(BOOL)isConnected{
    return _isSocketConnected;
}

-(CinRunLoop *)runLoop{
    return self.sRunLoop;
}

- (void)connect {
    [self performSelector:@selector(innerConnect) onThread:[self.sRunLoop getThread] withObject:nil waitUntilDone:NO];
}

- (void)disconnect {
    if(_socketRef)
        CFSocketInvalidate(_socketRef);
    
    if (!_isSocketConnected)
        return;
    
    _isSocketConnected = NO;
    [self releaseSocket];
    [self releaseRearch];
    [self writeLog:@"Start to disconnect."];
    [self performSelector:@selector(processDisconnected) onThread:[self.sRunLoop getThread] withObject:nil waitUntilDone:NO];
}

- (BOOL)sendData:(NSData*)data {
    if (_socketRef == nil)
        return false;
    CFDataRef Data = CFDataCreate(nil, (const UInt8*)[data bytes], [data length]);
    CFSocketError ret = CFSocketSendData(_socketRef, nil, Data, 10);
    CFRelease(Data);
    if (ret)
        [self writeLog:[NSString stringWithFormat:@"Send %lu bytes data on %@.", (unsigned long)[data length], _sockAddr]];
    else
        [self writeLog:[NSString stringWithFormat:@"Send failed on %@.", _sockAddr]];
    return ret == kCFSocketSuccess;
}

- (void)innerConnect {
    
    [self releaseRearch];
    [self releaseSocket];
    
    [self initReachability];
    [self initSocket];
    
    NSLog(@"%@",[NSString stringWithFormat:@"Start to connect. Address:/%@:%d", _ip, _port]);
    
    [self writeLog:[NSString stringWithFormat:@"Start to connect. Address:/%@:%d", _ip, _port]];
    CFSocketError error;
    if (self.isIPv6) {
        error = CFSocketConnectToAddress(_socketRef, (__bridge CFDataRef)_addr6Data, 5);
    }
    else
        error = CFSocketConnectToAddress(_socketRef, (__bridge CFDataRef)_addr4Data, 5);//超时时间修改 原为30
    
    
    switch (error) {
        case kCFSocketSuccess:
            [self processConnect];
            break;
        case kCFSocketTimeout:
        case kCFSocketError:
        default:
            [self writeLog:[NSString stringWithFormat:@"Connection timeout or error. Address:/%@:%d", _ip, _port]];
            [self releaseSocket];
            [self releaseRearch];
            [self processDisconnected];
            break;
    }
}





 
- (void)enableCallback:(CFOptionFlags)flag {
    CFSocketEnableCallBacks(_socketRef, flag);
}

- (void)initReachability {
    if (self.isIPv6) {
        struct sockaddr_in6 reachAddress6;
        memset(&reachAddress6, 0, sizeof(reachAddress6));
        reachAddress6.sin6_len       = sizeof(struct sockaddr_in6);
        reachAddress6.sin6_family    = AF_INET6;
        inet_pton(AF_INET6, _ip.UTF8String, &reachAddress6.sin6_addr);
        SCNetworkReachabilityContext reachContent = {0, (__bridge void *)self, nil, nil, nil};
        
        _reachability = SCNetworkReachabilityCreateWithAddress(NULL,
                                                               (struct sockaddr *)&reachAddress6);
        
        if (SCNetworkReachabilitySetCallback(_reachability, reachabilityCallback, &reachContent) &&
            SCNetworkReachabilityScheduleWithRunLoop(_reachability, [self.sRunLoop getCFRunLoop], kCFRunLoopDefaultMode)) {
            
        }
        else {
            [self writeLog:@"SCNetworkReachabilitySetCallback failed.-ipv6"];
        }
        
    }
    else {
        struct sockaddr_in reachAddress;
        bzero(&reachAddress, sizeof(reachAddress));
        reachAddress.sin_len = sizeof(reachAddress);
        reachAddress.sin_family = AF_INET;
        reachAddress.sin_addr.s_addr = inet_addr([_ip UTF8String]);
        
        SCNetworkReachabilityContext reachContent = {0, (__bridge void *)self, nil, nil, nil};
        
        _reachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&reachAddress);
        
        if (SCNetworkReachabilitySetCallback(_reachability, reachabilityCallback, &reachContent) &&
            SCNetworkReachabilityScheduleWithRunLoop(_reachability, [self.sRunLoop getCFRunLoop], kCFRunLoopDefaultMode)) {
        }
        else {
            [self writeLog:@"SCNetworkReachabilitySetCallback failed.-ipv4"];
        }
    }
}

- (void)releaseRearch {
    @synchronized(self) {
        if (_reachability == nil)
            return;
        SCNetworkReachabilitySetCallback(_reachability, nil, nil);
        CFRelease(_reachability);
        _reachability = nil;
    }
}

- (void)initSocket {
    if (self.isIPv6) {
        struct sockaddr *pSockAddr = (struct sockaddr *)[self.addr6Data bytes];
        int addressFamily = pSockAddr->sa_family;
        //创建套接字
        CFSocketContext CTX = {0, (__bridge void *)self, NULL, NULL, NULL};
        _socketRef = CFSocketCreate(kCFAllocatorDefault, addressFamily, SOCK_STREAM, IPPROTO_TCP,
                                 kCFSocketDataCallBack, socketProcesser, &CTX);
        
        CFSocketSetSocketFlags(_socketRef, (CFSocketGetSocketFlags(_socketRef) & ~kCFSocketAutomaticallyReenableReadCallBack & ~kCFSocketAutomaticallyReenableWriteCallBack) | kCFSocketAutomaticallyReenableDataCallBack);
        
        CFRunLoopSourceRef sourceLoop = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socketRef, 0);
        CFRunLoopAddSource([self.sRunLoop getCFRunLoop], sourceLoop, kCFRunLoopDefaultMode);
        CFRelease(sourceLoop);
    }
    else {
        CFSocketContext sockContent = {0, (__bridge void *)self, nil, nil, nil};
        _socketRef = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketDataCallBack, socketProcesser, &sockContent);
        CFSocketSetSocketFlags(_socketRef, (CFSocketGetSocketFlags(_socketRef) & ~kCFSocketAutomaticallyReenableReadCallBack & ~kCFSocketAutomaticallyReenableWriteCallBack) | kCFSocketAutomaticallyReenableDataCallBack);
        
        CFRunLoopSourceRef sourceLoop = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socketRef, 0);
        CFRunLoopAddSource([self.sRunLoop getCFRunLoop], sourceLoop, kCFRunLoopDefaultMode);
        CFRelease(sourceLoop);
    }
}

- (void)releaseSocket {
    @synchronized(self) {
        if (_socketRef == nil)
            return;
        
        CFSocketDisableCallBacks(_socketRef, kCFSocketDataCallBack);
        CFRelease(_socketRef);
        _socketRef = nil;
    }
}


- (void)writeLog:(NSString*)log {
    if (self.enableLog) {
        NSLog(@"[CinSocket]--%@", log);
    }
}



- (void)processConnect {
    CFDataRef lData = CFSocketCopyAddress(_socketRef);
    CFDataRef rData = CFSocketCopyPeerAddress(_socketRef);
    if (lData != nil && rData != nil) {
//        struct sockaddr_in local;
//        memcpy(&local, CFDataGetBytePtr(lData), CFDataGetLength(lData));
//
//        struct sockaddr_in remote;
//        memcpy(&remote, CFDataGetBytePtr(rData), CFDataGetLength(rData));
        
        //IPV4
        if (self.isIPv6) {
            //IPV6
            struct sockaddr_in6 local;
            memcpy(&local, CFDataGetBytePtr(lData), CFDataGetLength(lData));
            struct sockaddr_in6 remote;
            memcpy(&remote, CFDataGetBytePtr(rData), CFDataGetLength(rData));
            char str[INET6_ADDRSTRLEN];
            char str1[INET6_ADDRSTRLEN];
            _sockAddr = [NSString stringWithFormat:@"L/%s:%d-R/%s:%d",
                         inet_ntop(AF_INET6, &local.sin6_addr, str, INET6_ADDRSTRLEN),
                         ntohs(local.sin6_port),
                         inet_ntop(AF_INET6, &remote.sin6_addr, str1, INET6_ADDRSTRLEN),
                         ntohs(remote.sin6_port)];
        }
        else {
            struct sockaddr_in local;
            memcpy(&local, CFDataGetBytePtr(lData), CFDataGetLength(lData));
            
            struct sockaddr_in remote;
            memcpy(&remote, CFDataGetBytePtr(rData), CFDataGetLength(rData));
            _sockAddr = [NSString stringWithFormat:@"L/%s:%d-R/%s:%d",
                         inet_ntoa(local.sin_addr),
                         ntohs(local.sin_port),
                         inet_ntoa(remote.sin_addr),
                         ntohs(remote.sin_port)];
        }
        
    }
    if (lData)
        CFRelease(lData);
    if (rData)
        CFRelease(rData);
    
    [self writeLog:[NSString stringWithFormat:@"Connection has been connected, %@", _sockAddr]];
    _isSocketConnected = YES;
    [self.delegate socketDidConnected:self];
}

- (void)processDisconnected {
    [self writeLog:[NSString stringWithFormat:@"Connection has been disconnected,%@",_sockAddr]];
    _isSocketConnected = NO;
    [self.delegate socketDidDisconnected:self];
    _sockAddr = nil;
}

- (void)processRead:(const void *)data {
    NSData *nsData = [[NSData alloc] initWithBytes:CFDataGetBytePtr(data) length:CFDataGetLength(data)];
    [self writeLog:[NSString stringWithFormat:@"ReceiveData: %d bytes data on %@.", [nsData length], _sockAddr]];
    [self.delegate socket:self didRecieveData:nsData];
}




#pragma mark c function C 语言方法
static void socketProcesser(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    CinSocket *cinSocket = (CinSocket*)CFBridgingRelease(info);
    if (cinSocket == nil)
        return;
    
    [cinSocket writeLog:[NSString stringWithFormat:@"Receive CFSocketCallBackType: %d", (int)type]];
    switch (type) {
        case kCFSocketDataCallBack:
            if (CFDataGetLength(data) != 0)
                [cinSocket processRead:data];
            else
                [cinSocket processDisconnected];
            break;
        default:
            NSLog(@"Unkown CFSocketCallBackType: %d", (int)type);
            break;
    }
}

static void reachabilityCallback(SCNetworkReachabilityRef target, SCNetworkConnectionFlags flags, void* info) {
    CinSocket *cinSocket = (CinSocket*)CFBridgingRelease(info);
    if (cinSocket == nil)
        return;
    
    [cinSocket writeLog:[NSString stringWithFormat:@"Receive SCNetworkConnectionFlags: %d", (int)flags]];
    [cinSocket releaseSocket];
    [cinSocket processDisconnected];
}
@end

