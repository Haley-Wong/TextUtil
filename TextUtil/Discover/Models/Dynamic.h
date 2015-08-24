//
//  Dynamic.h
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import "JKDBModel.h"

@interface Dynamic : JKDBModel

@property (nonatomic, assign)   BOOL            isPraise;
@property (nonatomic, assign)   int             praiseCount;
@property (nonatomic, copy)     NSString        *location;
@property (nonatomic, copy)     NSString        *createTime;
/** 类型含义：0:纯文字    1:带图片（文字+图片/纯图片） 2:带视频（文字+视频/纯视频） */
@property (nonatomic, assign)   int             type;
@property (nonatomic, copy)     NSString        *text;
@property (nonatomic, assign)   int             imageCount;
@property (nonatomic, assign)   int             replyCount;

@end
