//
//  CinMessageProtocal.h
//  CFSocket_Demo
//
//  Created by edz on 2020/7/29.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>

 
@protocol CinMessageProtocal <NSObject>
@property (nonatomic, assign) int  type;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *key;
@end
 

// cinmessage 第一字节 < 0x80 的 是request Message
// 否则为 response message

//typedef enum CinRequestMethod {
//    CinRequestMethodService = 0x01,
//    CinRequestMethodMessage = 0x02,
//    CinRequestMethodReply = 0x03,
//    CinRequestMethodReadReply = 0x04,
//    CinRequestMethodKeepAlive = 0x05,
//    CinRequestMethodLogon = 0x07,
//    CinRequestMethodNotify = 0x0A,
//    CinRequestMethodAsk = 0x0B,
//    CinRequestMethodTyping = 0x0C,
//    CinRequestMethodTake = 0x0F,
//    CinRequestMethodGroup = 0x10,
//    CinRequestMethodGroupMessage = 0x11,
//    CinRequestMethodPublicQRCode = 0x12,
//    CinRequestMethodVideo = 0x1C,
//    CinRequestMethodData = 0x15,
//    CinRequestMethodVerify = 0x17,
//    CinRequestMethodReport = 0x19,
//    CinRequestMethodPhoneBook = 0x1A,
//    CinRequestMethodEmoticon = 0x1B,
//    CinRequestMethodDPService = 0x30,
//    CinRequestMethodDPSub = 0x31,
//    CinRequestMethodDPUnSub = 0x32,
//    CinRequestMethodDPNotify = 0x33,
//    CinRequestMethodDPTake = 0x34,
//    CinRequestMethodEUT = 0x40,
//    CinRequestMethodVoiceConference = 0x50,
//    CinRequestMethodVoiceConferenceSipCall = 0x51,
//    CinRequestMethodSMS = 0x63,
//    CinRequestMethodSocial = 0x62,
//    CinRequestMethodSocialNotify = 0x64,
//    CinRequestMethodPublicAccount = 0x1E,
//    CinRequestMethodPPMessage = 0x1f,
//
//    CinRequestMethodGuaGua = 0x52,
//    CinRequestMethodSDKNotifyInterface = 0x56,
//    CinRequestMethodSDKInterface = 0x57,
//    CinRequestMethodOrganize = 0x09,    //群组管理
//    CinRequestMethodWebIM = 0x5B,       //web客户端
//
//}CinRequestMethod;
//
//// 通常为接收到的响应数据的第一个字节
// typedef enum CinResponseCode{
//     CinResponseCodeOK = 0x80,
//     CinResponseCodeNotAvailable = 0x81,
//     CinResponseCodeError = 0x82,
//     CinResponseCodeBusy = 0x83,
//     CinResponseCodeNotExist = 0x84,
//     CinResponseCodeNotSupport = 0x85,
//     CinResponseCodeNeedVerifycation = 0x86,
//     CinResponseCodeNotFriends = 0x90,
//     CinResponseCodeTrying = 0xB0,
//     CinResponseCodeProcessing = 0xB1,
//     CinResponseCodePending = 0xB2,
//     CinResponseCodeTimeOut,
//     CinResponseCodeUnknown = 0xFE
// }CinResponseCode;
