//
//  ClubCategory.m
//  NarWall
//
//  Created by Bogdan Vitoc on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

#import "ClubCategory.h"

@interface ClubCategory ()
@property NSMutableArray *private__Clubs;
@end

@implementation ClubCategory

- (instancetype)init {
    self = [super init];
    if (self) {
        self.private__Clubs = [NSMutableArray array];
        self.isVisible = NO;
    }
    return self;
}

- (void)addClub:(PFObject *)club {
    [self.private__Clubs addObject: club];
    self.clubs = [NSArray arrayWithArray:self.private__Clubs];
}

@end
