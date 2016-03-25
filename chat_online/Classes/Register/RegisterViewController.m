//
//  RegisterViewController.m
//  UILday18_环信
//
//  Created by lxf on 16/3/24.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;


@end

@implementation RegisterViewController
- (IBAction)registerAction:(id)sender {
    if (self.nameTextField.text == nil || [self.nameTextField.text isEqualToString:@""] || self.passWordTextField.text == nil || [self.passWordTextField.text isEqualToString:@""]) {
        return;
    }
    
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:self.nameTextField.text  password:self.passWordTextField.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            NSLog(@"注册成功");
        }
    } onQueue:dispatch_get_main_queue()];
    
    
    
//    EMError *error = nil;
//    BOOL isSuccess = NO;
//   isSuccess = [[EaseMob sharedInstance].chatManager registerNewAccount:self.nameTextField.text password:self.passWordTextField.text error:&error];
//    if (isSuccess) {
//        NSLog(@"注册成功");
//    }else{
//        NSLog(@"注册失败:%@",error);
//    }
    
}
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
