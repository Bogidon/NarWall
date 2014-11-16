//
//  ClubsTableViewController.h
//  NarWall
//
//  Created by Bogdan Vitoc on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

@import UIKit;

@interface ClubsTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
- (IBAction)toggleSettingsPane:(UIBarButtonItem *)sender;
- (IBAction)newClub:(UIBarButtonItem *)sender;
@end
