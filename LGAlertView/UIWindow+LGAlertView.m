//
//  UIWindow+LGAlertView.m
//  Pods
//
//  Created by Grigory Lutkov on 01.11.15.
//
//

#import "UIWindow+LGAlertView.h"

@implementation UIWindow (LGAlertView)

- (NSString *)className
{
    return NSStringFromClass([self class]);
}

- (UIViewController *)currentViewController
{
    UIViewController *viewController = self.rootViewController;

    if (viewController.presentedViewController)
        viewController = viewController.presentedViewController;

    return viewController;
}

@end
