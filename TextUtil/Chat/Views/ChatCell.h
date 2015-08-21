//
//  ChatCell.h
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatMessage;
@interface ChatCell : UITableViewCell

@property (nonatomic, retain)   ChatMessage        *message;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** 计算cell 的高度 */
+ (CGFloat)heightOfCellWithMessage:(ChatMessage *)message;

@end
