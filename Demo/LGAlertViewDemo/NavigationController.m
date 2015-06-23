//
//  NavigationController.m
//  LGAlertViewDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "NavigationController.h"
#import "TableViewController.h"

@interface NavigationController ()

@property (strong, nonatomic) TableViewController *tableViewController;

@end

@implementation NavigationController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tableViewController = [TableViewController new];
        [self setViewControllers:@[self.tableViewController]];
    }
    return self;
}

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

@end
