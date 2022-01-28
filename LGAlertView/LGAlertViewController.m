//
//  LGAlertViewController.h
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

#import "LGAlertViewController.h"
#import "LGAlertView.h"
#import "UIWindow+LGAlertView.h"
#import "LGAlertViewHelper.h"

@interface LGAlertViewController ()

@property (strong, nonatomic) LGAlertView *alertView;

@end

@implementation LGAlertViewController

- (nonnull instancetype)initWithAlertView:(nonnull LGAlertView *)alertView view:(nonnull UIView *)view {
    self = [super init];
    if (self) {
        self.alertView = alertView;

        self.view.backgroundColor = UIColor.clearColor;
        [self.view addSubview:view];
    }
    return self;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if (coordinator) {
        [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    }
    
    @try {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:coordinator.transitionDuration animations:^{
                if (weakSelf) {
                    if ([weakSelf respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                        [weakSelf setNeedsStatusBarAppearanceUpdate];
                    }
                    if (weakSelf.alertView) {
                        [weakSelf.alertView layoutValidateWithSize:size];
                    }
                }
            }];
        }];
    } @catch (NSException *exception) {
        //
    } @finally {
        //
    }
    
}

#pragma mark -

- (BOOL)shouldAutorotate {
    UIViewController *viewController = LGAlertViewHelper.appWindow.currentViewController;

    if (viewController) {
        return viewController.shouldAutorotate;
    }

    return super.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *viewController = LGAlertViewHelper.appWindow.currentViewController;

    if (viewController) {
        return viewController.supportedInterfaceOrientations;
    }

    return super.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (LGAlertViewHelper.isViewControllerBasedStatusBarAppearance) {
        UIViewController *viewController = LGAlertViewHelper.appWindow.currentViewController;

        if (viewController) {
            return viewController.preferredStatusBarStyle;
        }
    }

    return super.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    if (LGAlertViewHelper.isViewControllerBasedStatusBarAppearance) {
        UIViewController *viewController = LGAlertViewHelper.appWindow.currentViewController;

        if (viewController) {
            return viewController.prefersStatusBarHidden;
        }
    }

    return super.prefersStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if (LGAlertViewHelper.isViewControllerBasedStatusBarAppearance) {
        UIViewController *viewController = LGAlertViewHelper.appWindow.currentViewController;

        if (viewController) {
            return viewController.preferredStatusBarUpdateAnimation;
        }
    }

    return super.preferredStatusBarUpdateAnimation;
}

@end
