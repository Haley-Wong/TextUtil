//
//  DynamicCell.m
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import "DynamicCell.h"
#import "DynamicView.h"

#import "Dynamic.h"

@interface DynamicCell ()

@property (nonatomic, retain) UIImageView   *faceImageView;
@property (nonatomic, retain) UILabel       *nameLabel;
@property (nonatomic, retain) UILabel       *locationLabel;
/** 板报内容视图 */
@property (nonatomic, retain) DynamicView   *dynamicView;
/** 操作视图 */
@property (nonatomic, retain) UIView        *optionView;
/** 分隔线 */
@property (nonatomic, retain) UIView        *lineView;
/** 点赞视图 */
@property (nonatomic, retain) UILabel       *praiseLabel;
/** 查看全部评论 */
@property (nonatomic, retain) UIButton      *showCommetsBtn;
/** 底部间距视图 */
@property (nonatomic, retain) UIView        *bottomView;

@end

@implementation DynamicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews
{
    //头像视图
    _faceImageView = [[UIImageView alloc] init];
    _faceImageView.layer.cornerRadius = kFaceWidth/2;
    _faceImageView.layer.masksToBounds = YES;
    _faceImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faceClick)];
    [_faceImageView addGestureRecognizer:tapGesture];
    
    [self.contentView addSubview:_faceImageView];
    //名字视图
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = nameColor;
    [self.contentView addSubview:_nameLabel];
    
    //位置视图
    _locationLabel = [[UILabel alloc] init];
    _locationLabel.textColor = customGrayColor;
    _locationLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_locationLabel];
    
    //板报正文视图
    _dynamicView = [[DynamicView alloc] initWithFrame:CGRectZero];
//    _dynamicView.delegate = self;
    [self.contentView addSubview:_dynamicView];
    
    //操作控件视图
    [self initOptionView];
    
    //分隔线
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = TABLEVIEW_BORDER_COLOR;
    [self.contentView addSubview:_lineView];
    
    //点赞人员视图
    _praiseLabel = [[UILabel alloc] init];
    _praiseLabel.textColor = customGrayColor;
    _praiseLabel.font = [UIFont systemFontOfSize:14.0f];
    _praiseLabel.numberOfLines = 0;
    [self.contentView addSubview:_praiseLabel];
    
    //显示全部评论按钮
    _showCommetsBtn = [[UIButton alloc] init];
    [_showCommetsBtn setTitleColor:customGrayColor forState:UIControlStateNormal];
    _showCommetsBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _showCommetsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [_showCommetsBtn addTarget:self action:@selector(showCommets) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_showCommetsBtn];
    
    //间距视图
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = VIEW_BGCOLOR;
    [self.contentView addSubview:_bottomView];
}

/** 初始化操作控件视图 */
- (void)initOptionView
{
    _optionView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_optionView];
    
    CGFloat btnWidth = 70;
    //点赞按钮
    UIButton *praiseBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-65-btnWidth*3, 0, btnWidth, kOptionHeight)];
    praiseBtn.tag = 110;
    [praiseBtn setImage:[UIImage imageNamed:@"dynamic_love"] forState:UIControlStateNormal];
    praiseBtn.titleLabel.font =[UIFont systemFontOfSize:14.0];
    [praiseBtn setTitleColor:customGrayColor forState:UIControlStateNormal];
    [praiseBtn addTarget:self action:@selector(praiseClick:) forControlEvents:UIControlEventTouchUpInside];
    [_optionView addSubview:praiseBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(praiseBtn.frame), kPadding*0.75, 1, kOptionHeight-kPadding*1.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_optionView addSubview:lineView];
    
    //评论按钮
    UIButton *cmdBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-65-btnWidth*2, 0, btnWidth, kOptionHeight)];
    cmdBtn.tag = 111;
    [cmdBtn setImage:[UIImage imageNamed:@"dynamic_comment"] forState:UIControlStateNormal];
    [cmdBtn setTitleColor:customGrayColor forState:UIControlStateNormal];
    [cmdBtn setTitle:@" 评论" forState:UIControlStateNormal];
    cmdBtn.titleLabel.font =[UIFont systemFontOfSize:14.0];
//    [cmdBtn addTarget:self action:@selector(cmtClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_optionView addSubview:cmdBtn];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cmdBtn.frame), kPadding*0.75, 1, kOptionHeight-kPadding*1.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_optionView addSubview:lineView];
    
    //收藏按钮
    UIButton *collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-65-btnWidth, 0, btnWidth, kOptionHeight)];
    collectBtn.tag = 112;
    [collectBtn setImage:[UIImage imageNamed:@"dynamic_collect"] forState:UIControlStateNormal];
    [collectBtn setTitleColor:customGrayColor forState:UIControlStateNormal];
    [collectBtn setTitle:@" 收藏" forState:UIControlStateNormal];
    collectBtn.titleLabel.font =[UIFont systemFontOfSize:14.0];
//    [collectBtn addTarget:self action:@selector(collectClick:) forControlEvents:UIControlEventTouchUpInside];
    [_optionView addSubview:collectBtn];
}

- (void)faceClick
{
    NSLog(@"%s",__func__);
}

- (void)praiseClick:(UIButton *)btn
{
    
}

#pragma mark - Class method
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"dynamicCell";
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

+ (CGFloat)heightOfCellWithModel:(Dynamic *)dynamic
{
    CGFloat height = 44;

    
    return height;
}

@end
