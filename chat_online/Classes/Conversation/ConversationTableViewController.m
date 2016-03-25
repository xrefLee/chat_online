//
//  ConversationTableViewController.m
//  UILday18_环信
//
//  Created by lxf on 16/3/24.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import "ConversationTableViewController.h"
#import "LoginViewController.h"
#import "ChatViewController.h"

@interface ConversationTableViewController ()<EMChatManagerDelegate>
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ConversationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Conversationcell"];
    /*
    [[NSNotificationCenter defaultCenter]addObserverForName:@"dataArr" object:nil queue:[[NSOperationQueue alloc]init] usingBlock:^(NSNotification * _Nonnull note) {
        EMConversation *conver = note.object;
        if ([self.dataArr containsObject:conver]) {
            return ;
        }
        [self.dataArr addObject:conver];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:(UITableViewRowAnimationLeft)];
            
        });
    }];
     */
    
}

- (void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"dataArr" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.dataArr = nil;
    [self.tableView reloadData];

}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        _dataArr = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO].mutableCopy;

    }
    return _dataArr;
}


- (IBAction)exitAction:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error && info) {
            NSLog(@"退出成功");
        }
    } onQueue:dispatch_get_main_queue()];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginVc = [storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self presentViewController:loginVc animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return self.dataArr.count;
}

/**/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Conversationcell" forIndexPath:indexPath];
    EMConversation *obj = self.dataArr[indexPath.row];
    cell.textLabel.text = obj.chatter;
    // Configure the cell...
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    chatVC.buddyUserName = ((EMConversation *)(self.dataArr[indexPath.row])).chatter;

    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:chatVC];
    [self presentViewController:navi animated:YES completion:nil];
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:((EMConversation *)(self.dataArr[indexPath.row])).chatter deleteMessages:YES append2Chat:YES];
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];

        
    }
    
}


#pragma mark - EMDelegate
/**
 *  好友请求回调
 *
 *  @param username 发送请求的人
 *  @param message  信息
 */
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message{
    NSLog(@"%@,%@",username,message);
    UIAlertController *allertVC = [UIAlertController alertControllerWithTitle:@"好友请求" message:[NSString stringWithFormat:@"%@ %@",username,message] preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         EMError *error = nil;
         BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
         if (isSuccess && !error) {
             NSLog(@"发送同意成功");
         }
         
     }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = nil;
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"111111" error:&error];
        if (isSuccess && !error) {
            NSLog(@"发送拒绝成功");
        }
       
    }];
    [allertVC addAction:sureAction];
    [allertVC addAction:cancelAction];
    
    [self presentViewController:allertVC animated:YES completion:nil];
    
}
/*!
 @method
 @brief 好友请求被接受时的回调
 @discussion
 @param username 之前发出的好友请求被用户username接受了
 */
- (void)didAcceptedByBuddy:(NSString *)username{
    UIAlertController *allertVC = [UIAlertController alertControllerWithTitle:@"好友请求" message:[NSString stringWithFormat:@"%@ 同意添加你为好友",username] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [allertVC addAction:sureAction];
    [self presentViewController:allertVC animated:YES completion:nil];
}

/*!
 @method
 @brief 好友请求被拒绝时的回调
 @discussion
 @param username 之前发出的好友请求被用户username拒绝了
 */
- (void)didRejectedByBuddy:(NSString *)username{
    UIAlertController *allertVC = [UIAlertController alertControllerWithTitle:@"好友请求" message:[NSString stringWithFormat:@"%@ 拒绝添加你为好友",username] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [allertVC addAction:sureAction];
    [self presentViewController:allertVC animated:YES completion:nil];
    
}


@end
