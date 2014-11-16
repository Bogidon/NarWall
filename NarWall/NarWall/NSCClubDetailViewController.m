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
@property BOOL isFavorited;
@end

@implementation NSCClubDetailViewController

- (void)setPFObject:(PFObject *)pfObject {
    self.club = pfObject;
    
    self.nameLabel.text = pfObject[@"name"];
    self.descriptionTextView.text = pfObject[@"description"];
    self.meetingLabel.text = pfObject[@"meetingTimes"];
    self.locationLabel.text = pfObject[@"location"];
    [self.contactButton setTitle:pfObject[@"contactName"] forState:UIControlStateNormal];
    self.membersTextView.text = @"";
    
    if (!pfObject[@"members"]) {
        pfObject[@"members"] = [NSMutableArray array];
        [pfObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (error || !succeeded) {
                [pfObject saveEventually];
            }
        }];
    }
    for (PFUser *member in pfObject[@"members"]) {
        self.membersTextView.text = [NSString stringWithFormat:@"%@, %@ %@", self.membersTextView.text, member[@"firstName"], member[@"lastName"]];
    }
    
    PFUser *user = [PFUser currentUser];
    self.isFavorited = NO;
    
    if (user[@"favoriteClubs"] != nil) {
        for (PFObject *club in user[@"favoriteClubs"]) {
            if ([club.objectId isEqualToString:self.club.objectId   ]) {
                self.isFavorited = YES;
                break;
            }
        }
    } else {
        user[@"favoriteClubs"] = [NSArray array];
        [user saveInBackgroundWithBlock:^(BOOL succeed, NSError *error) {
            if (error) {
                [user saveEventually];
            }
        }];
    }
    
    UIBarButtonItem *favoritesButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: self.isFavorited ? @"Favorites-Pressed" : @"Favorites-Normal"] style:UIBarButtonItemStylePlain target:self action:@selector(addToFavorites:)];
    self.navigationItem.rightBarButtonItem = favoritesButton;
}

- (IBAction)emailContact:(UIButton *)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)addToFavorites:(UIBarButtonItem*)rightBarButtonItem {
    PFUser *user = [PFUser currentUser];
    self.isFavorited = !self.isFavorited;
    
    if (self.isFavorited) {
        [rightBarButtonItem setImage:[UIImage imageNamed:@"Favorites-Pressed"]];
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:user[@"favoriteClubs"]];
        [array addObject:self.club];
        user[@"favoriteClubs"] = array;
        
    } else {
        [rightBarButtonItem setImage:[UIImage imageNamed:@"Favorites-Normal"]];
        
        //Remove self from users favorites array
        NSMutableArray *array = [NSMutableArray arrayWithArray:user[@"favoriteClubs"]];
        [array removeObject:self.club];
        user[@"favoriteClubs"] = array;
    }
    
    [user saveInBackgroundWithBlock:^(BOOL succeed, NSError *error) {
        if (error) {
            [user saveEventually];
        }
    }];}
@end
