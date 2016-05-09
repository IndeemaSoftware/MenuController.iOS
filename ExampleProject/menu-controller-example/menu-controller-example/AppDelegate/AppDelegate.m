//
//  AppDelegate.m
//  menu-controller-example
//
//  Created by Volodymyr Shevchyk Jr. on 13/04/16.
//  Copyright © 2016 Indeema Software Inc. All rights reserved.
//

#import "AppDelegate.h"

#import "EEFirstViewController.h"
#import "EESecondViewController.h"
#import "EEThirdViewController.h"

#import "EEMenuConroller.h"

@interface AppDelegate ()

- (void)initializeTabs;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // initialize window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:[EEMenuConroller shareInstance].contentViewController];
    [self.window makeKeyAndVisible];
    
    [EEMenuConroller.shareInstance setBottomPanelColor:[UIColor colorWithWhite:0.95f alpha:1.0f]];
    [EEMenuConroller.shareInstance setBottomPanelTintColor:[UIColor lightGrayColor]];
    [EEMenuConroller.shareInstance setBottomPanelActiveTintColor:[UIColor colorWithRed:64.0f/255.0f green:171.0f/255.0f blue:247.0f/255.0f alpha:1.0f]];
    
    [EEMenuConroller.shareInstance setFloatingPanelColor:[UIColor whiteColor]];
    [EEMenuConroller.shareInstance setFloatingPanelTintColor:[UIColor lightGrayColor]];
    [EEMenuConroller.shareInstance setFloatingPanelActiveTintColor:[UIColor colorWithRed:64.0f/255.0f green:171.0f/255.0f blue:247.0f/255.0f alpha:1.0f]];
    
    [self initializeTabs];
    
    return YES;
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

- (void)initializeTabs {
    EEMenuTab *lMenuTab1 = [EEMenuTab new];
    lMenuTab1.title = @"Messages";
    lMenuTab1.icon = [UIImage imageNamed:@"messages_tab"];
    lMenuTab1.viewController = [EEFirstViewController newWithNimbAsClassName];
    
    EEMenuTab *lMenuTab2 = [EEMenuTab new];
    lMenuTab2.title = @"Profile";
    lMenuTab2.icon = [UIImage imageNamed:@"profile_tab"];
    lMenuTab2.viewController = [EESecondViewController newWithNimbAsClassName];
    
    EEMenuTab *lMenuTab3 = [EEMenuTab new];
    lMenuTab3.title = @"Settings";
    lMenuTab3.icon = [UIImage imageNamed:@"setting_tab"];
    lMenuTab3.viewController = [EEThirdViewController newWithNimbAsClassName];
    
    [[EEMenuConroller shareInstance] loadTabs:@[lMenuTab1, lMenuTab2, lMenuTab3]];
    
    [[EEMenuConroller shareInstance] setMenuVisible:YES animated:NO];
}

@end
