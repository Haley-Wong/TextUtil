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


@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

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
    _messages = [[NSMutableArray alloc] initWithArray:[ChatMessage findAll]];
}

/** 取消事件的焦点 */
- (void)cancelFocus
{
    [self.textField resignFirstResponder];
 
    [UIView animateWithDuration:0.3f animations:^{
        // 1、修改输入框视图的位置
        _bottomView.bottom = kHeight;
        // 2、修改表格的高度
        _tableView.height = _bottomView.top;
    }];
}

- (IBAction)emtionClick:(id)sender {
    NSLog(@"%s--emtionClick",__func__);
//    NSString *content = _textField.text;
//    ChatMessage *chatMessage = [[ChatMessage alloc] init];
//    chatMessage.isSender = YES;
//    chatMessage.content = content;
//    [chatMessage save];
//    _textField.text = nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *content = _textField.text;
    ChatMessage *chatMessage = [[ChatMessage alloc] init];
    chatMessage.isSender = YES;
    chatMessage.content = content;
    [chatMessage save];
    _textField.text = nil;
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
        CGFloat bottom = kHeight-frame.size.height;
        //1.修改输入框View的位置
        _bottomView.bottom = bottom;
        //2.修改tableView的高度
        _tableView.height = _bottomView.top;
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
