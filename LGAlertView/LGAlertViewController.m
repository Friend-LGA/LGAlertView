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

- (BOOL)shouldAutorotate {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;

    return window.currentViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;

    return window.currentViewController.supportedInterfaceOrientations;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator
     animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
         [self.alertView layoutValidateWithSize:size];
     }
     completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [UIApplication sharedApplication].statusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return [UIApplication sharedApplication].statusBarHidden;
}

@end
