//
//  CreateClubTableViewController.h
//  NarWall
//
//  Created by Bogdan Vitoc on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

@import UIKit;
@import Parse;

@protocol CreateClubTableViewControllerDelegate <NSObject>

- (void)createClubTableViewControllerDidCancel:(UITableViewController*)createClubController;

- (void)createClubTableViewController:(UITableViewController*)createClubController didSaveWithPFObject:(PFObject*)pfObject;

@end

@interface CreateClubTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *meetingTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *descriptionCell;

@property(nonatomic, assign)id delegate;

@end
