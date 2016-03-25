//
//  LoginViewController.m
//  UILday18_环信
//
//  Created by lxf on 16/3/24.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginAction:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.nameTextField.text password:self.passWordTextField.text completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            NSLog(@"登陆成功");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController *main = [storyboard instantiateViewControllerWithIdentifier:@"main"];
                [(AppDelegate *)([UIApplication sharedApplication].delegate) window].rootViewController = main;
                
            });
            

        }
    } onQueue:dispatch_get_main_queue()];
}

- (IBAction)pushRegisterAction:(id)sender {
}










@end
