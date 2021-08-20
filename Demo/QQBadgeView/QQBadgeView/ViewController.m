//
//  ViewController.m
//  QQBadgeView
//
//  Created by Shaw on 2017/2/5.
//  Copyright © 2017年 Shaw. All rights reserved.
//

#import "ViewController.h"
#import "BadgeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BadgeView *badge = [[BadgeView alloc] initWithFrame:CGRectMake(40, 40, 20, 20)];
    [self.view addSubview:badge];
}


@end
