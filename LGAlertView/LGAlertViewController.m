//
//  LGAlertViewController.m
//  Pods
//
//  Created by Grigory Lutkov on 01.11.15.
//
//

#import "LGAlertViewController.h"
#import "LGAlertView.h"
#import "UIWindow+LGAlertView.h"

@interface LGAlertViewController ()

@property (strong, nonatomic) LGAlertView *alertView;

@end

@implementation LGAlertViewController

- (instancetype)initWithAlertView:(LGAlertView *)alertView view:(UIView *)view
{
    self = [super init];
    if (self)
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        if ([UIDevice currentDevice].systemVersion.floatValue < 7.0)
            self.wantsFullScreenLayout = YES;
#endif

        _alertView = alertView;

        self.view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
    }
    return self;
}

- (BOOL)shouldAutorotate
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;

    return window.currentViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;

    return window.currentViewController.supportedInterfaceOrientations;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0

// iOS <= 7

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

    CGSize size = self.view.frame.size;

    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
        size = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
    else
        size = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));

    [_alertView layoutInvalidateWithSize:size];
}

#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

// iOS >= 8

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [_alertView layoutInvalidateWithSize:size];
     }
                                 completion:nil];
}

#endif

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [UIApplication sharedApplication].statusBarStyle;
}

@end
