//
//  ChatMessage.h
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import "JKDBModel.h"

typedef enum : NSUInteger {
    MessageTypeText,
    MessageTypeAudio,
    MessageTypePicture,
    MessageTypeVideo,
} MessageType;

@interface ChatMessage : JKDBModel

@property (nonatomic, copy)     NSString        *content;
@property (nonatomic, assign)   MessageType     messageType;
@property (nonatomic, assign)   BOOL            isSender;


@end
