//
//  NSCClubDetailViewController.h
//  NarWall
//
//  Created by Bogdan Vitoc on 11/16/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

@import UIKit;
@import Parse;
@interface NSCClubDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *meetingLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UITextView *membersTextView;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

- (void)setPFObject:(PFObject*)pfObject;
- (IBAction)emailContact:(UIButton *)sender;
- (IBAction)join:(UIButton *)sender;

@end
