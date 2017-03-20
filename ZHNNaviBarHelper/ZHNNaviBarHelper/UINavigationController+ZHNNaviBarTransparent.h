//
//  UINavigationController+ZHNNaviBarTransparent.h
//  ZHNNaviBarHelper
//
//  Created by zhn on 2017/3/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHNCustomColor;
@interface UINavigationController (ZHNNaviBarTransparent)
@property (nonatomic,assign) CGFloat BarBackgroundAlpha;
@property (nonatomic,strong) ZHNCustomColor *BarTintColor;
@property (nonatomic,strong) ZHNCustomColor *BarBackgroundColor;
@end

//
// 自定义颜色
//
@interface ZHNCustomColor : NSObject
@property (nonatomic,assign) CGFloat red;
@property (nonatomic,assign) CGFloat green;
@property (nonatomic,assign) CGFloat blue;
+ (ZHNCustomColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
- (UIColor *)changeToUIColor;
@end
