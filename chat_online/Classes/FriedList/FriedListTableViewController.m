//
//  FriedListTableViewController.m
//  UILday18_环信
//
//  Created by lxf on 16/3/24.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import "FriedListTableViewController.h"
#import "AddFriendViewController.h"
#import "ChatViewController.h"

@interface FriedListTableViewController ()<EMChatManagerDelegate>
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation FriedListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"friendcell"];

}



- (IBAction)addFried:(id)sender {
    AddFriendViewController *adVC = [[AddFriendViewController alloc]init];
    [self presentViewController:adVC animated:YES completion:nil];
    
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
            if (!error) {
                _dataArr = buddyList.mutableCopy;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        } onQueue:dispatch_get_main_queue()];
        
    }
    return _dataArr;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendcell" forIndexPath:indexPath];
    EMBuddy *buddy = self.dataArr[indexPath.row];
    cell.textLabel.text = buddy.username;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    chatVC.buddyUserName = ((EMBuddy *)(self.dataArr[indexPath.row])).username;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:chatVC];
    [self presentViewController:navi animated:YES completion:nil];
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMBuddy *buddy = self.dataArr[indexPath.row];
        // 删除好友对应的对话
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:buddy.username deleteMessages:YES append2Chat:YES];
        EMError *error = nil;
        // 删除好友
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:buddy.username removeFromRemote:YES error:&error];
        if (isSuccess && !error) {
            NSLog(@"删除成功");
        }
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
        
        
    }
    
}




@end
