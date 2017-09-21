//
//  LGAlertViewHelper.h
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

#import <UIKit/UIKit.h>

@class LGAlertView;

#pragma mark - Constants

extern CGFloat const LGAlertViewPaddingWidth;
extern CGFloat const LGAlertViewPaddingHeight;
extern CGFloat const LGAlertViewButtonImageOffsetFromTitle;

#pragma mark - Interface

@interface LGAlertViewHelper : NSObject

+ (void)animateWithDuration:(NSTimeInterval)duration
                 animations:(void(^)())animations
                 completion:(void(^)(BOOL finished))completion;

+ (void)keyboardAnimateWithNotificationUserInfo:(NSDictionary *)notificationUserInfo
                                     animations:(void(^)(CGFloat keyboardHeight))animations;

+ (UIImage *)image1x1WithColor:(UIColor *)color;

+ (BOOL)isNotRetina;

+ (BOOL)isPad;

+ (CGFloat)statusBarHeight;

+ (CGFloat)separatorHeight;

+ (BOOL)isPadAndNotForce:(LGAlertView *)alertView;

+ (BOOL)isCancelButtonSeparate:(LGAlertView *)alertView;

+ (CGFloat)systemVersion;

#if TARGET_OS_IOS
+ (UIWindow *)appWindow;
+ (UIWindow *)keyWindow;
#endif

+ (BOOL)isViewControllerBasedStatusBarAppearance;

@end
