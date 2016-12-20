//
//  AppDelegate.m
//  LGAlertViewDemo
//

#import "AppDelegate.h"
#import "TableViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    TableViewController *tableViewController = [TableViewController new];
    self.navigationController = [[NavigationController alloc] initWithRootViewController:tableViewController];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
