//
//  customNaviViewController.m
//  ZHNNaviBarHelper
//
//  Created by zhn on 2017/3/11.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "customNaviViewController.h"
#import "UINavigationController+ZHNNaviBarTransparent.h"
#import <objc/runtime.h>
@interface customNaviViewController ()

@end

@implementation customNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.BarBackgroundColor = [ZHNCustomColor colorWithRed:0 green:255 blue:0];
    self.BarTintColor = [ZHNCustomColor colorWithRed:255 green:0 blue:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
