//
//  ViewController.m
//  localTest
//
//  Created by admin on 17/1/17.
//  Copyright © 2017年 EEO. All rights reserved.
//

#import "ViewController.h"
#import "EEOUMApiProxy.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    
    UIButton *qqZoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qqZoneButton.frame = CGRectMake(50, 50, 150, 50);
    [qqZoneButton setTitle:@"分享QQ空间" forState:UIControlStateNormal];
    [qqZoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    qqZoneButton.backgroundColor = [UIColor redColor];
    [qqZoneButton addTarget:self action:@selector(p_onShareQQZoneButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqZoneButton];
    
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qqButton.frame = CGRectMake(50, 150, 150, 50);
    [qqButton setTitle:@"分享QQ" forState:UIControlStateNormal];
    [qqButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    qqButton.backgroundColor = [UIColor redColor];
    [qqButton addTarget:self action:@selector(p_onShareQQButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqButton];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)p_onShareQQZoneButtonHandle:(UIButton *)sender{
    NSString *text = @"12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890";
    NSLog(@"textLength = %ld",text.length);
    [EEOUMApiProxy shareTextToPlatformType:5 withText:text currentViewController:self];
}

- (void)p_onShareQQButtonHandle:(UIButton *)sender {
    NSString *text = @"12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890";
    [EEOUMApiProxy shareTextToPlatformType:4 withText:text currentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
