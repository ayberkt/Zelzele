//
//  ZELAppDelegate.m
//  Zelzele
//
//  Created by Ayberk Tosun on 6/2/14.
//  Copyright (c) 2014 Ayberk Tosun. All rights reserved.
//

#import "ZELAppDelegate.h"
#import "ZELEarthquakeTableViewController.h"

@implementation ZELAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    UINavigationController *navController = [[UINavigationController alloc] init];
    ZELEarthquakeTableViewController *earthquakeList = [[ZELEarthquakeTableViewController alloc] init];
    
    [navController setViewControllers:@[earthquakeList]];
    
    [self.window setRootViewController:navController];
    
    return YES;
}

@end
