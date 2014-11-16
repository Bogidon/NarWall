//
//  AppDelegate.m
//  NarWall
//
//  Created by Bogdan Vitoc on 11/14/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"Ndv4RrfwMNIt6YB09WnvqrzeyvYjb2jKMuvMmXwy"
                  clientKey:@"yKJpjIKCKG4eKeveAYwXaBMLcZayVwzkd0nN5ba7"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    if(![PFUser currentUser]){
        //No user is logged in, and we need to present the login view controller modally
        LoginViewController *login = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
        self.window.rootViewController = login;
    }
    
    //Tab bar appearance
    UIFont *tabBarFont = [UIFont fontWithName:@"ITCFranklinGothicStd-Med" size:24.0];
    UIColor *redTextColor = [UIColor colorWithRed:253/255.0 green:65/255.0 blue:32/255.0 alpha:1.0];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: tabBarFont} forState:UIControlStateNormal];
    [[UITabBar appearance] setTintColor: redTextColor];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -10.0)];
    
    //Nav bar appearance
    UIFont *navBarFont = [UIFont fontWithName:@"ITCFranklinGothicStd-Book" size:18.0];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName: redTextColor,
       NSFontAttributeName:navBarFont
       }
     forState:UIControlStateNormal];
    
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

@end
