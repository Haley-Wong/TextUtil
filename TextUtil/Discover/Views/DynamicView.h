//
//  DynamicView.h
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Dynamic.h"

#define kContentFont [UIFont systemFontOfSize:15.0]     //正文字体
#define kDynamicWidth   (kWidth-65-10)                     //内容视图宽度
#define kImagePadding   5                               //图片间距
#define kImageWidth     (kDynamicWidth-kImagePadding*2)/3     //图片宽度

#define kSingleImageWidth 200  //单张图片的宽度

@interface DynamicView : UIView

@property (nonatomic, retain)   Dynamic      *dynamic;

+ (CGFloat)getHeightWithModel:(Dynamic *)dynamic;

@end
