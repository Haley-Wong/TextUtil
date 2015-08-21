//
//  YYFaceView.m
//  
//
//  Created by Joker on 14-1-6.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "YYFaceView.h"

#define item_width 42
#define item_height 45

@implementation YYFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/**
 * 行 row:3
 * 列 colum:7
 * 表情尺寸 30*30 pixels
 */
/*
 *
  items = [
            ["表情1",“表情2”,“表情3”,......“表情28”],
            ["表情1",“表情2”,“表情3”,......“表情28”],
            ["表情1",“表情2”,“表情3”,......“表情28”]
          ];
 
 */

- (void)initData
{
    items = [[NSMutableArray alloc] init];
    
    //---------------整理表情，整理成一个二维数组---------------
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray  *fileArray = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *items2D = nil;
    for (int i=0; i<fileArray.count; i++) {
        NSDictionary *item = [fileArray objectAtIndex:i];
        if (i % 21 == 0) {
            items2D = [NSMutableArray arrayWithCapacity:21];
            [items addObject:items2D];
        }
        [items2D addObject:item];
    }
    
    self.pageNumber = items.count;
    //设置尺寸
    self.width = items.count *320;
    self.height = 3 * item_height;
    
    //放大镜
    magnifierView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 92)];
    magnifierView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier"];
    magnifierView.hidden = YES;
    magnifierView.backgroundColor = [UIColor clearColor];
    [self addSubview:magnifierView];
    
    UIImageView *faceItem = [[UIImageView alloc] initWithFrame:CGRectMake((64-30)/2, 15, 30, 30)];
    faceItem.tag = 2013;
    faceItem.backgroundColor = [UIColor clearColor];
    [magnifierView addSubview:faceItem];
}

/*
 *
 items = [
            ["表情1",“表情2”,“表情3”,......“表情28”],
            ["表情1",“表情2”,“表情3”,......“表情28”],
            ["表情1",“表情2”,“表情3”,......“表情28”]
 ];
 */
- (void)drawRect:(CGRect)rect
{
    //定义列和行
    int row = 0, colum = 0;
    
    for (int i = 0; i<items.count; i++) {
        NSArray *item2D = [items objectAtIndex:i];
        for (int j=0; j<item2D.count; j++) {
            NSDictionary *item = [item2D objectAtIndex:j];
            NSString *imageName = [item objectForKey:@"png"];
            UIImage *image = [UIImage imageNamed:imageName];
            
            CGRect frame = CGRectMake(colum * item_width +15, row *item_height + 15, 30, 30);
            
            //考虑页数，需要加上前几页的宽度
            float x = (i*320) + frame.origin.x;
            frame.origin.x  = x;
            
            [image drawInRect:frame];
            
            //更新列与行
            colum++;
            if (colum % 7 == 0) {
                row ++;
                colum = 0;
            }
            if (row == 3) {
                row = 0;
            }
        }
    }
}

- (void)touchFace:(CGPoint)point
{
    //页数
    int page = point.x / 320;
    float x = point.x - (page *320) -10;
    float y = point.y - 10;
    
    //计算列与行
    int colum = x / item_width;
    int row = y /item_height;
    
    if (colum > 6) {
        colum = 6;
    }
    if (colum < 0) {
        colum = 0;
    }
    
    if (row > 2) {
        row = 1;
    }
    if (row < 0) {
        row = 0;
    }
    
    //计算选中表情的索引
    int index = colum + (row * 7);
    NSArray *item2D = [items objectAtIndex:page];
    if (index >= item2D.count) {
        return;
    }
    NSDictionary *item = [item2D objectAtIndex:index];
    NSString *faceName = [item objectForKey:@"cht"];
    
    if (![self.selectedFaceName isEqualToString:faceName]) {
        //给放大镜添加上表情
        NSString *imageName = [item objectForKey:@"png"];
        UIImage *image = [UIImage imageNamed:imageName];
        
        UIImageView *faceItem = (UIImageView *)[magnifierView viewWithTag:2013];
        faceItem.image = image;
        
        magnifierView.left = (page * 320) + colum *item_width;
        magnifierView.bottom = row *item_height + 30;
        
        self.selectedFaceName = faceName;
    }
    
}

#pragma mark - touch事件
//touch 触摸开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    magnifierView.hidden = NO;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchFace:point];
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = NO;
    }
    
}

//touch 触摸移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchFace:point];
}

//touch 触摸结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    magnifierView.hidden = YES;
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
    
    if (self.block != nil) {
        _block(_selectedFaceName);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    magnifierView.hidden = YES;
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
}

@end
