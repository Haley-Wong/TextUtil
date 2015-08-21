//
//  YYFaceScrollView.h
//  ismarter2.0_sz
//
//  Created by zx_04 on 15/6/15.
//
//

#import <UIKit/UIKit.h>
#import "YYFaceView.h"

typedef void(^SendBtnClickBlock)(void);

@interface YYFaceScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView   *scrollView;
    YYFaceView     *faceView;
    UIPageControl  *pageControl;
    UIView         *bottomView;
}

@property (nonatomic, copy)     SendBtnClickBlock           sendBlock;

- (id)initWithSelectBlock:(SelectBlock)block;

@end
