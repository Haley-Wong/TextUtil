//
//  ChatViewController.m
//  TextUtil
//
//  Created by zx_04 on 15/8/19.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import "ChatViewController.h"

#import "ChatCell.h"
#import "ChatMessage.h"
#import "YYFaceScrollView.h"

@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (weak, nonatomic) IBOutlet UIView             *bottomView;
@property (weak, nonatomic) IBOutlet UITextField        *textField;
/** 表情视图 */
@property (nonatomic, strong) YYFaceScrollView          *faceView;

@property (nonatomic, strong) NSMutableArray    *messages;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = VIEW_BGCOLOR;
    
    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelFocus)];
    [self.tableView addGestureRecognizer:tapGesture];
    
    //加载历史聊天记录
    [self loadChatRecords];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)loadChatRecords
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *data = [ChatMessage findAll];
        dispatch_async(dispatch_get_main_queue(), ^{
             _messages = [[NSMutableArray alloc] initWithArray:data];
            [_tableView reloadData];
        });
    });
}

/** 取消事件的焦点 */
- (void)cancelFocus
{
    self.textField.text = nil;
    [self.textField resignFirstResponder];
 
    [UIView animateWithDuration:0.3f animations:^{
        // 1、修改输入框视图的位置
        _bottomView.bottom = kHeight-64;
        // 修改表情视图的位置
        _faceView.top = kHeight-64;
        // 2、修改表格的高度
        _tableView.height = _bottomView.top;
    }];
}

- (void)sendMessage:(NSString *)text
{
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (text.length == 0) {
        return;
    }
    ChatMessage *chatMessage = [[ChatMessage alloc] init];
    chatMessage.isSender = YES;
    chatMessage.content = text;
    [chatMessage save];
     self.textField.text = nil;
    [_messages addObject:chatMessage];
    [_tableView reloadData];
    
    [self tableViewScrollToBottom];
}

- (void)tableViewScrollToBottom
{
    if (_messages.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_messages.count-1) inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (IBAction)emtionClick:(id)sender {
    NSLog(@"%s--emtionClick",__func__);
    [self.textField resignFirstResponder];
    if (_faceView == nil) {
        __block __weak ChatViewController *this = self;
        
        _faceView = [[YYFaceScrollView alloc] initWithSelectBlock:^(NSString *faceName) {
            NSString *text = this.textField.text;
            NSString *appendText = [text stringByAppendingString:faceName];
            this.textField.text = appendText;
        }];
        _faceView.backgroundColor = RGBColor(220, 220, 220, 1);
        _faceView.top = kHeight - 20 - 44;
        _faceView.clipsToBounds = NO;
        _faceView.sendBlock = ^{
            NSString* fullText = this.textField.text;
            [this sendMessage:fullText];
            [this cancelFocus];
        };
        [self.view addSubview:_faceView];
    }
    float height = _faceView.height;
    //设置键盘动画
    __block CGRect frame;
    [UIView animateWithDuration:0.3 animations:^{
        _faceView.top = kHeight - 20 - 44 - height;
        //调整bottomView的高度
        self.bottomView.bottom = _faceView.top;
        frame = _bottomView.frame;
        self.inputView.frame = frame;
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessage:_textField.text];
    return YES;
}

#pragma mark - Notification event
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = value.CGRectValue;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        CGFloat bottom = kHeight-frame.size.height-64;
        //1.修改输入框View的位置
        _bottomView.bottom = bottom;
        //2.修改tableView的高度
        _tableView.height = _bottomView.top;
    } completion:^(BOOL finished) {
        [self tableViewScrollToBottom];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *cell = [ChatCell cellWithTableView:tableView];
    cell.message = [_messages objectAtIndex:indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMessage *message = [_messages objectAtIndex:indexPath.row];
    
    return [ChatCell heightOfCellWithMessage:message];
}

@end
