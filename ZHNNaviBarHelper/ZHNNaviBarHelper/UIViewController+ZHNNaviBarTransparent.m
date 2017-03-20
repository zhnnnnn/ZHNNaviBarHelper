//
//  UIViewController+ZHNNaviBarTransparent.m
//  ZHNNaviBarHelper
//
//  Created by zhn on 2017/3/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UIViewController+ZHNNaviBarTransparent.h"
#import "UINavigationController+ZHNNaviBarTransparent.h"
#import <objc/runtime.h>
@implementation UIViewController (ZHNNaviBarTransparent)
//------------ tint颜色
- (void)setNaviBarTintColor:(ZHNCustomColor *)naviBarTintColor {
    self.navigationController.navigationBar.tintColor = [naviBarTintColor changeToUIColor];
    objc_setAssociatedObject(self, @"knavibarColor", naviBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ZHNCustomColor *)naviBarTintColor {
    id naviBarTintColor = objc_getAssociatedObject(self, @"knavibarColor");
    if (naviBarTintColor == nil) {
        if (self.navigationController.BarTintColor) {
            self.naviBarTintColor = self.navigationController.BarTintColor;
            return self.navigationController.BarTintColor;
        }else {
            return [ZHNCustomColor colorWithRed:0 green:255*0.478431 blue:255];
        }
    }else {
        return naviBarTintColor;
    }
}

//------------ 背景透明度
- (void)setNaviBarAlpha:(CGFloat)naviBarAlpha {
    if (naviBarAlpha > 1) {
        naviBarAlpha = 1;
    }
    if (naviBarAlpha < 0) {
        naviBarAlpha = 0;
    }
    self.navigationController.BarBackgroundAlpha = naviBarAlpha;
    objc_setAssociatedObject(self, @"knavibaralpha", @(naviBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)naviBarAlpha {
    id navibarAlpha = objc_getAssociatedObject(self, @"knavibaralpha");
    if (navibarAlpha == nil) {
        return 1;
    }else {
        return [navibarAlpha floatValue];
    }
}
@end
