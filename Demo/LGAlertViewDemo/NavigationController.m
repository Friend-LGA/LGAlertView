//
//  NavigationController.m
//  LGAlertViewDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.translucent = YES;
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationBar.tintColor = [UIColor colorWithWhite:1.f alpha:0.5];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
