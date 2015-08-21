//
//  Utility.h
//  TextUtil
//
//  Created by zx_04 on 15/8/20.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

//处理表情字符
+ (NSMutableAttributedString *)getEmotionStrByString:(NSString *)textStr;

@end
