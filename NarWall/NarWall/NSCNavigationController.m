//
//  NSCNavigationController.m
//  NarWall
//
//  Created by Bogdan Vitoc on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

#import "NSCNavigationController.h"

@implementation NSCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"ITCFranklinGothicStd-Med" size:18.0],
      NSFontAttributeName,  nil]];
    
    [self.navigationBar setTintColor:[UIColor colorWithRed:253/255.0 green:65/255.0 blue:32/255.0 alpha:1.0]];
}

@end
