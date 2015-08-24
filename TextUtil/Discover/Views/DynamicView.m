//
//  DynamicView.m
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import "DynamicView.h"
#import "Utility.h"

@interface DynamicView ()

/** 正文的文字 */
@property (nonatomic, retain) UILabel           *contentLabel;
/** 图片视图数组 */
@property (nonatomic, retain) NSMutableArray    *imageViews;

@property (nonatomic, retain) UIButton          *videoBtn;

@end

@implementation DynamicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

/** 初始化子控件 */
- (void)initSubViews
{
    //添加正文
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel.font = kContentFont;
    _contentLabel.textColor = [UIColor blackColor];
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    
    _imageViews = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds  = YES;
        imageView.tag = 2015 + i;
        [self addSubview:imageView];
        [_imageViews addObject:imageView];
    }
    
    _videoBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_videoBtn setImage:[UIImage imageNamed:@"chatgroup_video_play_btbg"] forState:UIControlStateNormal];
//    [_videoBtn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_videoBtn];
}

- (void)setDynamic:(Dynamic *)dynamic
{
    if (_dynamic != dynamic) {
        _dynamic = dynamic;
    }
    
    _contentLabel.hidden = YES;
    for (UIImageView *imageView in _imageViews) {
        imageView.hidden = YES;
    }
    _videoBtn.hidden = YES;
    
    if (_dynamic.type == 0) { //纯文字
        NSMutableAttributedString *content = [Utility emotionStrWithString:_dynamic.text];
        [content addAttribute:NSFontAttributeName value:kContentFont range:NSMakeRange(0, content.length)];
        CGSize maxSize = CGSizeMake(kDynamicWidth, MAXFLOAT);
        CGSize attrStrSize = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        _contentLabel.frame = CGRectMake(0, 0, attrStrSize.width, attrStrSize.height);
        _contentLabel.attributedText = content;
        _contentLabel.hidden = NO;
    } else if (_dynamic.type == 1) { //带图片
        CGFloat contentHeight = 0;
        if (_dynamic.text.length <= 0) {//不存在文字，肯定是纯图片
            _contentLabel.frame = CGRectZero;
            _contentLabel.hidden = YES;
        } else { //文字+图片
            NSMutableAttributedString *content = [Utility emotionStrWithString:_dynamic.text];
            [content addAttribute:NSFontAttributeName value:kContentFont range:NSMakeRange(0, content.length)];
            CGSize maxSize = CGSizeMake(kDynamicWidth, MAXFLOAT);
            CGSize attrStrSize = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            _contentLabel.frame = CGRectMake(0, 0, attrStrSize.width, attrStrSize.height);
            _contentLabel.attributedText = content;
            _contentLabel.hidden = NO;
            contentHeight = attrStrSize.height+10;
        }
        
        for (int i = 0; i < _dynamic.imageCount; i++) {
            if (i > 8) {
                break;
            }
            int rowNum = i/3;
            int colNum = i%3;
            CGFloat imageX = colNum*(kImageWidth+kImagePadding);
            CGFloat imageY = contentHeight + rowNum*(kImageWidth+kImagePadding);
            CGRect frame = CGRectMake(imageX,imageY, kImageWidth, kImageWidth);
            if (_dynamic.imageCount == 1) {
                frame = CGRectMake(0, contentHeight, kSingleImageWidth, kSingleImageWidth-40);
            }
            UIImageView *imageView = [_imageViews objectAtIndex:i];
            imageView.hidden = NO;
            imageView.frame = frame;
            NSString *imageName = [NSString stringWithFormat:@"image_0%d.jpg",i+1];
            imageView.image = [UIImage imageNamed:imageName];
        }
        
    } else if (_dynamic.type == 2) { //小视频
        CGFloat contentHeight = 0;
        if (_dynamic.text.length <= 0) {//不存在文字，肯定是纯图片
            _contentLabel.frame = CGRectZero;
            _contentLabel.hidden = YES;
        } else { //文字+图片
            NSMutableAttributedString *content = [Utility emotionStrWithString:_dynamic.text];
            [content addAttribute:NSFontAttributeName value:kContentFont range:NSMakeRange(0, content.length)];
            CGSize maxSize = CGSizeMake(kDynamicWidth, MAXFLOAT);
            CGSize attrStrSize = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            _contentLabel.frame = CGRectMake(0, 0, attrStrSize.width, attrStrSize.height);
            _contentLabel.attributedText = content;
            _contentLabel.hidden = NO;
            contentHeight = attrStrSize.height+10;
        }
        
        _videoBtn.hidden = NO;
        _videoBtn.frame = CGRectMake(0, contentHeight, kSingleImageWidth, kSingleImageWidth-40);
        [_videoBtn setBackgroundImage:[UIImage imageNamed:@"bb_default_picture_bg.png"] forState:UIControlStateNormal];
    }
}


+ (CGFloat)getHeightWithModel:(Dynamic *)dynamic
{
    if (dynamic.type == 0) { //纯文字
        NSMutableAttributedString *content = [Utility emotionStrWithString:dynamic.text];
        [content addAttribute:NSFontAttributeName value:kContentFont range:NSMakeRange(0, content.length)];
        CGSize maxSize = CGSizeMake(kDynamicWidth, MAXFLOAT);
        CGSize attrStrSize = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        return attrStrSize.height;
    } else if (dynamic.type == 1) { //附带图片
        CGFloat height = 0;
        if (dynamic.text.length > 0) {//文字
            NSMutableAttributedString *content = [Utility emotionStrWithString:dynamic.text];
            [content addAttribute:NSFontAttributeName value:kContentFont range:NSMakeRange(0, content.length)];
            CGSize maxSize = CGSizeMake(kDynamicWidth, MAXFLOAT);
            CGSize attrStrSize = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            height += attrStrSize.height;
        }
        int imageCount = dynamic.imageCount;
        if (imageCount == 0) {
            
        } else if (imageCount == 1) {
            height += kSingleImageWidth-40+10;
        } else if (imageCount < 4) {
            height += (kImageWidth+10);
        } else if (imageCount < 7) {
            height += (kImageWidth*2 + kImagePadding+10);
        } else {
            height += (kImageWidth*3 + kImagePadding*2+10);
        }
        return height;
    } else if (dynamic.type == 3){
        CGFloat height = 0;
        if (dynamic.text.length <= 0) {//不存在文字，肯定是纯视频
            
        } else { //文字+视频
            NSMutableAttributedString *content = [Utility emotionStrWithString:dynamic.text];
            [content addAttribute:NSFontAttributeName value:kContentFont range:NSMakeRange(0, content.length)];
            CGSize maxSize = CGSizeMake(kDynamicWidth, MAXFLOAT);
            CGSize attrStrSize = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            height += (attrStrSize.height+10);
        }
        
        height += (kSingleImageWidth-40);
        return height;
    }
    
    return 0;
}

@end
