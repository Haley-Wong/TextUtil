//
//  TextAndPictureViewController.m
//  TextUtil
//
//  Created by zx_04 on 15/8/24.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import "TextAndPictureViewController.h"

#import "Utility.h"

@interface TextAndPictureViewController ()

@end

@implementation TextAndPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *content = @"文字加上表情[得意][酷][呲牙]";
    NSMutableAttributedString *attrStr = [Utility emotionStrWithString:content];
    _firstLabel.attributedText= attrStr;
    
    NSString *text = @"<微信>腾讯科技讯 微软提供免费升级的Windows 10，在全球获得普遍好评。但微软已经有一段时间没有公布最新升级数据。科技市场研究公司StatCounter发布了有关Windows升级的相关数据，显示出Windows 10的升级节奏开始放缓。<微信>另外，数据显示Windows 8用户是升级的主力军，Windows 7用户升级动力不太足。";
    NSMutableAttributedString *attrStr2 = [Utility exchangeString:@"<微信>" withText:text imageName:@"header_wechat"];
    _secondLabel.attributedText = attrStr2;
    
}


@end
