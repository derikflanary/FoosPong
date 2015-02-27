//
//  AppDelegate.m
//  FoosPong
//
//  Created by Derik Flanary on 2/7/15.
//  Copyright (c) 2015 Vibe. All rights reserved.
//

#import "AppDelegate.h"
#import "InitialViewController.h"
//#import "HomeViewController.h"
//#import "GroupsViewController.h"
//#import "ProfileViewController.h"
//#import "HistoryViewController.h"
//#import "CurrentGroupViewController.h"
//#import "PersonalNotificationsViewController.h"
#import <Parse/Parse.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
    [Parse enableLocalDatastore];
    
    [Parse setApplicationId:@"mqjgxXFS9TPQoSswF9CrWmElMXu7D1tPkBR3H4rC"
                  clientKey:@"XaBMEuMLhsBaWQyCgpAjL7jKsU11zXBrcLt0CzZ6"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFUser enableAutomaticUser];
    
    UINavigationController *mainNavController = [[UINavigationController alloc]initWithRootViewController:[InitialViewController new]];
    self.window.rootViewController = mainNavController;
    
//    HomeViewController *hvc = [HomeViewController new];
//    InitialViewController *ivc = [InitialViewController new];
//    
//    UITabBarController *profileTabBar = [UITabBarController new];
//    HistoryViewController *historyVC = [HistoryViewController new];
//    PersonalNotificationsViewController *pnvc = [PersonalNotificationsViewController new];
//    ProfileViewController *pvc = [ProfileViewController new];
//    pvc.tabBarItem.title = @"Profile";
//    historyVC.tabBarItem.title = @"History";
//    pnvc.tabBarItem.title = @"Notifications";
//    profileTabBar.viewControllers = @[pvc, historyVC, pnvc];
//    
//    UITabBarController *groupTabBar = [UITabBarController new];
//    GroupsViewController *gvc = [GroupsViewController new];
//    gvc.tabBarItem.title = @"Groups";
//    CurrentGroupViewController *cgvc = [CurrentGroupViewController new];
//    cgvc.tabBarItem.title = @"Current Group";
//    groupTabBar.viewControllers = @[gvc, cgvc];
    
    //mainNavController.viewControllers = @[ivc, hvc, profileTabBar, groupTabBar];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
    
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
