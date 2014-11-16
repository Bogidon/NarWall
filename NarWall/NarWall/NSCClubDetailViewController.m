//
//  NSCClubDetailViewController.m
//  NarWall
//
//  Created by Bogdan Vitoc on 11/16/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

#import "NSCClubDetailViewController.h"

@interface NSCClubDetailViewController ()
@property PFObject *club;
@end

@implementation NSCClubDetailViewController

- (void)setPFObject:(PFObject *)pfObject {
    self.club = pfObject;
    
    self.nameLabel.text = pfObject[@"name"];
    self.descriptionTextView.text = pfObject[@"description"];
    self.meetingLabel.text = pfObject[@"meetingTimes"];
    self.locationLabel.text = pfObject[@"location"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
