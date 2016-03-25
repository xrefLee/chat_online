//
//  ChatViewController.m
//  UILday18_环信
//
//  Created by lxf on 16/3/24.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,EMChatManagerChatDelegate>
@property (nonatomic, strong) EMConversation *conversation;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *messageText;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *insertBottom;


@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ChatViewController
- (IBAction)sendAction:(id)sender {
    [self sendMessgae:self.messageText.text];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.buddyUserName conversationType:eConversationTypeChat];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"messageCell"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction)];
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.tableView addGestureRecognizer:tap];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
}



- (void)tapAction{
    [self.messageText resignFirstResponder];
    
}


- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)dataArr{
    _dataArr = self.conversation.loadAllMessages.mutableCopy;
    return _dataArr;
}

- (void)dealloc{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"dataArr" object:self.conversation];
}

// 发送消息
- (void)sendMessgae:(NSString *)str{
    EMChatText *txtChat = [[EMChatText alloc] initWithText:str];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:self.conversation.chatter bodies:@[body]];
    message.messageType = eMessageTypeChat;
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:^(EMMessage *message, EMError *error) {
        
    } onQueue:dispatch_get_main_queue() completion:^(EMMessage *message, EMError *error) {
        NSLog(@"发送成功");
        [self.tableView reloadData];
        
    } onQueue:dispatch_get_main_queue()];
    
    
}

//- (void)reloadtableView{
//
//    
//}


#pragma mark - tableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    EMMessage *message = self.dataArr[indexPath.row];
    EMTextMessageBody *body = message.messageBodies.lastObject;
    
    if ([message.to isEqualToString:self.conversation.chatter]) {
        
        cell.textLabel.text = body.text;
        cell.detailTextLabel.text = @"";
        
    } else {
        
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = body.text;
    }
    
    
    
    
    return cell;
    
}

- (void)didReceiveMessage:(EMMessage *)message{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.messageText resignFirstResponder];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"123");
}


# pragma mark - Keyboard Method
/**
 *  注册通知中心
 */
- (void)registerForKeyboardNotifications
{
    // 使用NSNotificationCenter 注册观察当键盘要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil
     
     ];

    
    // 使用NSNotificationCenter 注册观察当键盘要隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  移除通知中心
 */
- (void)removeForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  键盘将要弹出
 *
 *  @param notification 通知
 */
- (void)didKeyboardWillShow:(NSNotification *)notification {
    
    NSDictionary * info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSLog(@"%f", keyboardSize.height);
    [self.insertBottom setConstant:keyboardSize.height + 20];
    
    //输入框位置动画加载
//    [self begainMoveUpAnimation:keyboardSize.height];
}

/**
 *  键盘将要隐藏
 *
 *  @param notification 通知
 */
- (void)didKeyboardWillHide:(NSNotification *)notification {
    [self.insertBottom setConstant: 20];
//    [self begainMoveUpAnimation:0];
}

@end
