//
//  DynamicCell.h
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

#define nameColor       RGBColor(50, 85, 140, 1.0)  //名字颜色
#define customGrayColor RGBColor(175, 180, 200, 1.0)  //灰色
#define kFaceWidth      45   //头像视图的宽、高
#define kOptionHeight   30   //操作视图的高度
#define kPadding        10  //视图之间的间距

@class Dynamic;
@interface DynamicCell : UITableViewCell

/** 朋友圈信息实体 */
@property (nonatomic, retain)   Dynamic      *dynamic;

+ (DynamicCell *)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)heightOfCellWithModel:(Dynamic *)dynamic;

@end
