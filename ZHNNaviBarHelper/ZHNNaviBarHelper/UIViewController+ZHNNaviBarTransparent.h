//
//  UIViewController+ZHNNaviBarTransparent.h
//  ZHNNaviBarHelper
//
//  Created by zhn on 2017/3/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+ZHNNaviBarTransparent.h"

@interface UIViewController (ZHNNaviBarTransparent)

/**
 navibar的tint颜色
 */
@property (nonatomic,strong) ZHNCustomColor *naviBarTintColor;

/**
 naivbar的透明度
 */
@property (nonatomic,assign) CGFloat naviBarAlpha;
@end
