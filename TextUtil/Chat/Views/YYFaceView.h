//
//  YYFaceView.h
//
//
//  Created by Joker on 14-1-6.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBlock) (NSString *faceName);

@interface YYFaceView : UIView
{
    NSMutableArray *items;
    UIImageView    *magnifierView;
}

@property (nonatomic,copy) NSString *selectedFaceName;
@property (nonatomic,assign) NSInteger pageNumber;
@property (nonatomic,copy) SelectBlock block;

@end
