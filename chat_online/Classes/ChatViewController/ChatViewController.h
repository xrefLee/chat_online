//
//  ChatViewController.h
//  UILday18_环信
//
//  Created by lxf on 16/3/24.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
@property (nonatomic, strong) NSString *buddyUserName;
@property (nonatomic, copy) void (^block)(EMConversation *);
@end
