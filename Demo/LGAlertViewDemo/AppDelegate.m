//
//  AppDelegate.m
//  LGAlertViewDemo
//

#import "AppDelegate.h"
#import "TableViewController.h"
#import "LGAlertView.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    TableViewController *tableViewController = [TableViewController new];
    self.navigationController = [[NavigationController alloc] initWithRootViewController:tableViewController];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // Set default action sheet offset equal to safe area of the screen
    [[LGAlertView appearance] setCancelButtonOffsetY: UIApplication.sharedApplication.windows.firstObject.safeAreaInsets.bottom];

    return YES;
}

@end
