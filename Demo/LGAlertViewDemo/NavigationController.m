//
//  NavigationController.m
//  LGAlertViewDemo
//

#import "NavigationController.h"

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.translucent = YES;
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationBar.tintColor = [UIColor colorWithWhite:1.0 alpha:0.5];

    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance* standardAppearance = [UINavigationBarAppearance new];
        standardAppearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
        standardAppearance.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        self.navigationBar.standardAppearance = standardAppearance;
        self.navigationBar.scrollEdgeAppearance = standardAppearance;
        self.navigationBar.compactAppearance = standardAppearance;
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
