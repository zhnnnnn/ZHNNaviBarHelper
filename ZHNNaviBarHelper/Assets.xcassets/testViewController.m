//
//  testViewController.m
//  ZHNNaviBarHelper
//
//  Created by zhn on 2017/3/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "testViewController.h"
#import "UIViewController+ZHNNaviBarTransparent.h"
#import "test2ViewController.h"
@interface testViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *contentTableView;
@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.naviBarAlpha = 0;
    self.naviBarTintColor = [ZHNCustomColor colorWithRed:0 green:0 blue:0];
    
    UIButton *pushButton = [[UIButton alloc]init];
    [self.view addSubview:pushButton];
    pushButton.frame = CGRectMake(100, 100, 100, 60);
    [pushButton setTitle:@"push" forState:UIControlStateNormal];
    [pushButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pushAction {
    test2ViewController *testVC = [[test2ViewController alloc]init];
    [self.navigationController pushViewController:testVC animated:YES];
}

#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}
#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - getters
- (UITableView *)contentTableView {
    if (_contentTableView == nil) {
        _contentTableView = [[UITableView alloc]init];
    }
    return _contentTableView;
}

@end
