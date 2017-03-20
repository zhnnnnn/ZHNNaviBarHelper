//
//  UINavigationController+ZHNNaviBarTransparent.m
//  ZHNNaviBarHelper
//
//  Created by zhn on 2017/3/9.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UINavigationController+ZHNNaviBarTransparent.h"
#import "UIViewController+ZHNNaviBarTransparent.h"
#import <objc/runtime.h>

@interface UINavigationController()<UINavigationControllerDelegate,UINavigationBarDelegate>
@end

@implementation UINavigationController (ZHNNaviBarTransparent)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        // @selector的方式拿不到最后的方法
        SEL originalSelector = NSSelectorFromString(@"_updateInteractiveTransition:");
        SEL swizzledSelector = NSSelectorFromString(@"zhn_updateInteractiveTransition:");
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}
#pragma mark - public methods
- (void)setBackgroundAlpha:(CGFloat)alpha {
    UIView *backGroundView = [self.navigationBar valueForKey:@"_barBackgroundView"];
    UIView *backgroundEffectView = [backGroundView valueForKey:@"_backgroundEffectView"];
    UIView *shadowView = [backGroundView valueForKey:@"_shadowView"];
    backgroundEffectView.alpha = alpha;
    shadowView.alpha = alpha;
}

#pragma mark - swizzing mehod
- (void)zhn_updateInteractiveTransition:(CGFloat)percentComplete {
    [self zhn_updateInteractiveTransition:percentComplete];
    UIViewController *topViewController = self.topViewController;
    if (topViewController != nil) {
        id<UIViewControllerTransitionCoordinator>coor = topViewController.transitionCoordinator;
        if (coor) {
            UIViewController *fromViewController = [coor viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toViewController = [coor viewControllerForKey:UITransitionContextToViewControllerKey];
            // 透明度
            CGFloat currentAlpha = fromViewController.naviBarAlpha + (toViewController.naviBarAlpha - fromViewController.naviBarAlpha) * percentComplete;
            [self setBackgroundAlpha:currentAlpha];
            // tint颜色
            ZHNCustomColor *fromNaviBarColor = fromViewController.naviBarTintColor;
            ZHNCustomColor *toNaviBarColor = toViewController.naviBarTintColor;
            UIColor *currentColor = [self p_averageColor:toNaviBarColor fromColor:fromNaviBarColor percent:percentComplete];
            self.navigationBar.tintColor = currentColor;
        }
    }
}

#pragma mark - delegates
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *topViewController = self.topViewController;
    if (topViewController != nil) {
        id<UIViewControllerTransitionCoordinator>coor = topViewController.transitionCoordinator;
        if (coor) {
            CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion]floatValue];
            if (systemVersion >= 10) {
                [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [self p_dealInteractionChanges:context];
                }];
            }else {
                [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [self p_dealInteractionChanges:context];
                }];
            }
           
        }
    }
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if (self.childViewControllers.count >= navigationBar.items.count) {// 区分是滑动返回还是直接pop返回
        UIViewController *popViewController = self.viewControllers[self.viewControllers.count - 2];
        [self popViewControllerAnimated:YES];
        [UIView animateWithDuration:0.34 animations:^{
            navigationBar.tintColor = [popViewController.naviBarTintColor changeToUIColor];
            [self setBackgroundAlpha:popViewController.naviBarAlpha];
        }];
    }
    return YES;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    [UIView animateWithDuration:0.34 animations:^{
        navigationBar.tintColor = [self.topViewController.naviBarTintColor changeToUIColor];
        [self setBackgroundAlpha:self.topViewController.naviBarAlpha];
    }];
    return YES;
}

#pragma mark - pravite methods
- (UIColor *)p_averageColor:(ZHNCustomColor *)toColor fromColor:(ZHNCustomColor *)fromColor percent:(CGFloat)percent {
    CGFloat toRed = toColor.red;
    CGFloat toGreen = toColor.green;
    CGFloat toBlue = toColor.blue;
    
    CGFloat fromRed = fromColor.red;
    CGFloat fromGreen = fromColor.green;
    CGFloat fromeBlue = fromColor.blue;
    
    CGFloat newRed = fromRed + (toRed - fromRed) * percent;
    CGFloat newGreen = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat newBlue = fromeBlue + (toBlue - fromeBlue) * percent;
    return [UIColor colorWithRed:newRed/255.0 green:newGreen/255.0 blue:newBlue/255.0 alpha:1];
}

- (void)p_dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    if ([context isCancelled]) {
        CGFloat duration = [context transitionDuration] * [context percentComplete];
        [UIView animateWithDuration:duration animations:^{
            self.navigationBar.tintColor = [fromVC.naviBarTintColor changeToUIColor];
            [self setBackgroundAlpha:fromVC.naviBarAlpha];
        }];
    }else {
        CGFloat duration = [context transitionDuration] * (1 - [context percentComplete]);
        [UIView animateWithDuration:duration animations:^{
            self.navigationBar.tintColor = [toVC.naviBarTintColor changeToUIColor];
            [self setBackgroundAlpha:toVC.naviBarAlpha];
        }];
    }
}

#pragma mark - getters
- (ZHNCustomColor *)BarTintColor {
    return objc_getAssociatedObject(self, @selector(BarTintColor));
}

- (ZHNCustomColor *)BarBackgroundColor {
    return objc_getAssociatedObject(self, @selector(BarBackgroundColor));
}

- (CGFloat)BarBackgroundAlpha {
    return [objc_getAssociatedObject(self, @selector(BarBackgroundAlpha)) floatValue];
}
#pragma mark - setters
- (void)setBarTintColor:(ZHNCustomColor *)BarTintColor {
    self.navigationBar.tintColor = [BarTintColor changeToUIColor];
    objc_setAssociatedObject(self, @selector(BarTintColor), BarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setBarBackgroundColor:(ZHNCustomColor *)BarBackgroundColor {
    self.navigationBar.barTintColor = [BarBackgroundColor changeToUIColor];
    objc_setAssociatedObject(self, @selector(BarBackgroundColor), BarBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setBarBackgroundAlpha:(CGFloat)BarBackgroundAlpha {
    [self setBackgroundAlpha:BarBackgroundAlpha];
    objc_setAssociatedObject(self, @selector(BarBackgroundAlpha), @(BarBackgroundAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end



//
//
// 自定义的颜色为了方便计算
//
//
@implementation ZHNCustomColor

+ (ZHNCustomColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    ZHNCustomColor *color = [[ZHNCustomColor alloc]init];
    color.red = red;
    color.green = green;
    color.blue = blue;
    return color;
}

- (UIColor *)changeToUIColor {
    return [UIColor colorWithRed:self.red/255.0 green:self.green/255.0 blue:self.blue/255.0 alpha:1.0];
}

@end

