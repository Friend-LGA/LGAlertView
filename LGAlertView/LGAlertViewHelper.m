//
//  LGAlertViewHelper.m
//  LGAlertView
//
//
//  The MIT License (MIT)
//
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>
//  (https://github.com/Friend-LGA/LGAlertView)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "LGAlertViewHelper.h"
#import "LGAlertView.h"

#pragma mark - Constants

CGFloat const LGAlertViewPaddingWidth = 10.0;
CGFloat const LGAlertViewPaddingHeight = 8.0;
CGFloat const LGAlertViewButtonImageOffsetFromTitle = 8.0;

#pragma mark - Implementation

@implementation LGAlertViewHelper

+ (void)animateWithAnimations:(void(^)())animations completion:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.5
                        options:0
                     animations:animations
                     completion:completion];
}

+ (void)keyboardAnimateWithNotificationUserInfo:(NSDictionary *)notificationUserInfo animations:(void(^)(CGFloat keyboardHeight))animations {
    CGFloat keyboardHeight = (notificationUserInfo[UIKeyboardFrameEndUserInfoKey] ? CGRectGetHeight([notificationUserInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]) : 0.0);

    if (!keyboardHeight) return;

    NSTimeInterval animationDuration = [notificationUserInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int animationCurve = [notificationUserInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    if (animations) {
        animations(keyboardHeight);
    }

    [UIView commitAnimations];
}

+ (UIImage *)image1x1WithColor:(UIColor *)color {
    if (!color) return nil;

    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);

    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (BOOL)isNotRetina {
    static BOOL isNotRetina;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        isNotRetina = (UIScreen.mainScreen.scale == 1.0);
    });

    return isNotRetina;
}

+ (BOOL)isPad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (CGFloat)statusBarHeight {
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    return sharedApplication.isStatusBarHidden ? 0.0 : CGRectGetHeight(sharedApplication.statusBarFrame);
}

+ (CGFloat)separatorHeight {
    return self.isNotRetina ? 1.0 : 0.5;
}

+ (BOOL)isPadAndNotForce:(LGAlertView *)alertView {
    return self.isPad && !alertView.isPadShowsActionSheetFromBottom;
}

+ (BOOL)isCancelButtonSeparate:(LGAlertView *)alertView {
    return alertView.style == LGAlertViewStyleActionSheet && alertView.cancelButtonOffsetY != NSNotFound && alertView.cancelButtonOffsetY > 0.0 && ![self isPadAndNotForce:alertView];
}

+ (CGFloat)systemVersion {
    return [UIDevice currentDevice].systemVersion.floatValue;
}

+ (UIWindow *)appWindow {
    return [UIApplication sharedApplication].windows[0];
}

+ (UIWindow *)keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}

+ (BOOL)isViewControllerBasedStatusBarAppearance {
    static BOOL isViewControllerBasedStatusBarAppearance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        if (UIDevice.currentDevice.systemVersion.floatValue >= 9.0) {
            isViewControllerBasedStatusBarAppearance = YES;
        }
        else {
            NSNumber *viewControllerBasedStatusBarAppearance = [NSBundle.mainBundle objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
            isViewControllerBasedStatusBarAppearance = (viewControllerBasedStatusBarAppearance == nil ? YES : viewControllerBasedStatusBarAppearance.boolValue);
        }
    });

    return isViewControllerBasedStatusBarAppearance;
}

@end
