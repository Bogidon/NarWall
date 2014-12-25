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
- (IBAction)collapseTableView:(id)sender;
- (IBAction)newClub:(UIBarButtonItem *)sender;
@end