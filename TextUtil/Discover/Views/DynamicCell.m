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
#import "Utility.h"

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
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cmdBtn.frame), kPadding*0.75, 1, kOptionHeight-kPadding*1.5)];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    [_optionView addSubview:_lineView];
    
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

- (void)setDynamic:(Dynamic *)dynamic
{
    if (_dynamic != dynamic) {
        _dynamic = dynamic;
    }
    
    _faceImageView.frame = CGRectMake(kPadding, kPadding, kFaceWidth, kFaceWidth);
    _faceImageView.image = [UIImage imageNamed:@"header_wechat"];
    
    _nameLabel.frame = CGRectMake(_faceImageView.right+kPadding, _faceImageView.top, kWidth-kFaceWidth-kPadding*3, 20);
    _nameLabel.text = @"路人甲";
    NSString *location = [NSString stringWithFormat:@"%@ | %@",_dynamic.location,_dynamic.createTime];
    
    _locationLabel.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom+kPadding, _nameLabel.width, 15);
    _locationLabel.text = location;
    
    CGFloat height = [DynamicView getHeightWithModel:_dynamic];
    _dynamicView.frame = CGRectMake(_nameLabel.left, _faceImageView.bottom+kPadding, kDynamicWidth, height);
    _dynamicView.dynamic = _dynamic;
    
    _optionView.frame = CGRectMake(_nameLabel.left, _dynamicView.bottom+kPadding, kWidth-65, kOptionHeight);
    //赞
    UIButton *praiseBtn = (UIButton *)[_optionView viewWithTag:110];
    NSString *praiseCount = [NSString stringWithFormat:@" %d",_dynamic.praiseCount];
    [praiseBtn setTitle:praiseCount forState:UIControlStateNormal];
    
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:nameColor};
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    NSString *praiseStr = @"路人甲、路人乙";
    NSString *praiseInfo = [NSString stringWithFormat:@"<点赞> %@",praiseStr];
    NSDictionary *attributesForAll = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:[UIColor grayColor]};
    NSMutableAttributedString *attrStr = [Utility exchangeString:@"<点赞>" withText:praiseInfo imageName:@"dynamic_love_blue"]; //dynamic_love_blue
    [attrStr addAttributes:attributesForAll range:NSMakeRange(0, attrStr.length)];
    NSRange darkRange =[attrStr.string rangeOfString:praiseStr];
    [attrStr addAttributes:attributes range:darkRange];
    
    CGSize labelSize = [attrStr boundingRectWithSize:CGSizeMake(kWidth-65-kPadding, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    _praiseLabel.attributedText = attrStr;
    _praiseLabel.frame = CGRectMake(_nameLabel.left, _optionView.bottom + kPadding, labelSize.width, labelSize.height);

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
    CGFloat height = 0;
    //头像高度
    height += (kPadding+kFaceWidth);
    //计算正文高度
    height += (kPadding +[DynamicView getHeightWithModel:dynamic]);
    //控件视图高度
    height += (kPadding+kOptionHeight);
    //点赞视图高度
    CGSize praiseSize = [self getHeightOfPraiseView:dynamic];
    height += (kPadding + praiseSize.height);
    
    height += kPadding+7;
    
    return height;
}

+ (CGSize)getHeightOfPraiseView:(Dynamic *)dynamic
{
    NSString *praiseStr = @"路人ABC";
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:nameColor};
    
    NSString *praiseInfo = [NSString stringWithFormat:@"<点赞> %@",praiseStr];
    NSDictionary *attributesForAll = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:[UIColor grayColor]};
    NSMutableAttributedString *attrStr = [Utility exchangeString:@"<点赞>" withText:praiseInfo imageName:@"dynamic_love_blue"];
    [attrStr addAttributes:attributesForAll range:NSMakeRange(0, attrStr.length)];
    NSRange darkRange =[attrStr.string rangeOfString:praiseStr];
    [attrStr addAttributes:attributes range:darkRange];
    
    CGSize labelSize = [attrStr boundingRectWithSize:CGSizeMake(kWidth-65-kPadding, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return labelSize;
}

@end
