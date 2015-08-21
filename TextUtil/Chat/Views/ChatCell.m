//
//  ChatCell.m
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import "ChatCell.h"
#import "ChatMessage.h"
#import "Utility.h"
#import "UIImage+Extension.h"

#define kContentFontSize        16.0f   //内容字体大小
#define kPadding                5.0f    //控件间隙
#define kEdgeInsetsWidth       20.0f   //内容内边距宽度

@interface ChatCell ()

/** 头像视图 */
@property (nonatomic, retain) UIImageView   *faceImageView;
/** 背景图 */
@property (nonatomic, retain) UIButton      *bgButton;
/** 文字内容视图 */
@property (nonatomic, retain) UILabel       *contentLabel;

@end

@implementation ChatCell

#pragma mark - life cirle method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    // 初始化头像视图
    _faceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _faceImageView.layer.cornerRadius = 5;
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_faceImageView];
    
    //初始化正文视图
    _bgButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_bgButton];
    
    //初始化正文视图
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel.font = [UIFont systemFontOfSize:kContentFontSize];
    _contentLabel.numberOfLines = 0;
    [_bgButton addSubview:_contentLabel];
}

#pragma mark - set subViews frame
/** 设置头像的frame和内容 */
- (void)setFaceFrame
{
    CGFloat width = 40;
    CGFloat height = 40;
    if (_message.isSender) {//如果是自己发送
        _faceImageView.frame = CGRectMake(kWidth-width-kPadding, 10, width, height);
    } else {
        _faceImageView.frame = CGRectMake(kPadding, 10, width, height);
    }
    if (_message.isSender) {
        _faceImageView.image = [UIImage imageNamed:@"header_QQ"];
    } else {
        _faceImageView.image = [UIImage imageNamed:@"header_wechat"];
    }
}

/** 设置文字类型message的cellframe */
- (void)setMessageFrame
{
    // 1、计算文字的宽高
    float textMaxWidth = kWidth-40-kPadding *2-60; //60是消息框体距离右侧或者左侧的距离
    
    NSMutableAttributedString *attrStr = [Utility getEmotionStrByString:_message.content];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:kContentFontSize]
                    range:NSMakeRange(0, attrStr.length)];
    CGSize textSize = [attrStr boundingRectWithSize:CGSizeMake(textMaxWidth, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil].size;
    
    _contentLabel.attributedText = attrStr;
    
    _contentLabel.frame = CGRectMake(kEdgeInsetsWidth, kEdgeInsetsWidth, textSize.width, textSize.height);
    // 2、计算背景图片的frame，X坐标发送和接收计算方式不一样
    CGFloat bgY = CGRectGetMinY(_faceImageView.frame);
    CGFloat width = textSize.width + kEdgeInsetsWidth*2;
    CGFloat height = textSize.height + kEdgeInsetsWidth*2;
    UIImage *bgImage; //声明一个背景图片对象
    UIImage *bgHighImage;
    // 3、判断是否为自己发送，来设置frame以及背景图片
    if (_message.isSender) { //如果是自己发送的
        CGFloat bgX = kWidth-kPadding*2-CGRectGetWidth(_faceImageView.frame)-width;
        _bgButton.frame = CGRectMake(bgX,bgY, width, height);
        [_bgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        bgImage = [UIImage resizableImageWithName:@"chat_send_nor"];
        bgHighImage = [UIImage resizableImageWithName:@"chat_send_press_pic"];
    } else {
        CGFloat bgX = CGRectGetMaxX(_faceImageView.frame)+5;
        _bgButton.frame = CGRectMake(bgX, bgY, width, height);
        [_bgButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bgImage = [UIImage resizableImageWithName:@"chat_recive_nor"];
        bgHighImage = [UIImage resizableImageWithName:@"chat_recive_press_pic"];
    }
    [_bgButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    [_bgButton setBackgroundImage:bgHighImage forState:UIControlStateHighlighted];
}


#pragma mark - class method
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"chatCell";
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

/** 计算cell 的高度 */
+ (CGFloat)heightOfCellWithMessage:(ChatMessage *)message
{
    CGFloat height = 0;
    
    float textMaxWidth = kWidth-40-kPadding *2-60; //60是消息框体距离右侧或者左侧的距离
    
    NSMutableAttributedString *attrStr = [Utility getEmotionStrByString:message.content];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:kContentFontSize]
                    range:NSMakeRange(0, attrStr.length)];
    CGSize textSize = [attrStr boundingRectWithSize:CGSizeMake(textMaxWidth, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                            context:nil].size;
    height += textSize.height;
    
    if (height < 60) {
        height = 60;
    }
    return height;
}

#pragma mark - setter and getter 
- (void)setMessage:(ChatMessage *)message
{
    if (_message != message) {
        _message = message;
    }
    
    //设置头像
    [self setFaceFrame];
    
    //设置内容
    [self setMessageFrame];
}

@end
