//
//  AddFriendViewController.m
//  UILday18_环信
//
//  Created by lxf on 16/3/24.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()



@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchTextField becomeFirstResponder];
    
}
- (IBAction)addAction:(id)sender {
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:self.searchTextField.text message:@"我想加您为好友" error:&error];
    if (isSuccess && !error) {
        NSLog(@"发送成功");
    }
    
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
