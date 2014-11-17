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
    self.membersTextView.text = [self getMembersString:pfObject];
    

    
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
- (IBAction)join:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Join"]) {
        [sender setTitle:@"Leave" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"Join" forState:UIControlStateNormal];
        return;
    }
    
    
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:[PFUser currentUser].objectId block:^(PFObject *fullUser, NSError *error) {
        if (!error) {
            [self.club addObject:fullUser forKey:@"members"];
            [self.club saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error && succeeded) {
                    self.membersTextView.text = [self getMembersString:self.club];
                }
            }];
        }
    }];
}

- (NSString*)getMembersString:(PFObject*)pfObject {
    [pfObject fetchIfNeeded];
    if (!pfObject[@"members"]) {
        pfObject[@"members"] = [NSMutableArray array];
        [pfObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (error || !succeeded) {
                [pfObject saveEventually];
            }
        }];
    }
    NSString *membersText = @"";
    for (PFUser *member in pfObject[@"members"]) {
        [member fetchIfNeeded];
        membersText = [NSString stringWithFormat:@"%@ %@ %@", self.membersTextView.text.length > 0 ? [NSString stringWithFormat:@"%@,",self.membersTextView.text] : @"" , member[@"firstName"], member[@"lastName"]];
    }
    return membersText;
}

@end
