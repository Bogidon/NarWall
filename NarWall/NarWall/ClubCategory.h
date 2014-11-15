//
//  ClubCategory.h
//  NarWall
//
//  Created by Bogdan Vitoc on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Parse;

@interface ClubCategory : NSObject

@property (strong, nonatomic) NSArray *clubs;
@property NSString *name;
@property BOOL isVisible;

- (void)addClub:(PFObject*)club;

@end
