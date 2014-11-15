//
//  ClubsTableViewController.m
//  NarWall
//
//  Created by Bogdan Vitoc on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

#import "ClubsTableViewController.h"
#import "CreateClubTableViewController.h"
#import "CategoryDropdownCell.h"
@interface ClubsTableViewController () <UIActionSheetDelegate, CreateClubTableViewControllerDelegate>{
    NSArray *clubs;
}

@end

@implementation ClubsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Clubs";
    clubs = [NSArray array];
    
    //Get club data
    PFQuery *clubsQuery = [PFQuery queryWithClassName:@"Clubs"];
    [clubsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            clubs = objects;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error);
        }
    }];

    
    //Configure settings button
    self.settingsBarButtonItem.title = @"\u2699";
    UIFont *settingsFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24.0];
    NSDictionary *settingsAttributeDict = [[NSDictionary alloc] initWithObjectsAndKeys:settingsFont, NSFontAttributeName, nil];
    [self.settingsBarButtonItem setTitleTextAttributes:settingsAttributeDict forState:UIControlStateNormal];
}

#pragma mark - Table View Layout
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryDropdownCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CategoryDropdownCell"];
    
    return cell;
}

#pragma mark - Settings Pane
- (IBAction)toggleSettingsPane:(UIBarButtonItem *)sender {
    UIActionSheet *settingsActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add", @"Categories", @"Sign Out", nil];
    [settingsActionSheet showFromBarButtonItem:self.settingsBarButtonItem animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0 :{
            // Add club
            UINavigationController *createClubNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateClubNavigationController"];
            
            if ([createClubNavigationController.topViewController isKindOfClass:[CreateClubTableViewController class]]) {
                CreateClubTableViewController *createClubViewController = (CreateClubTableViewController*)createClubNavigationController.topViewController;
                createClubViewController.delegate = self;
            }
            
            [self presentViewController:createClubNavigationController animated:YES completion:nil];
            break;
        }
        
        case 1:
            //Categories
            break;
            
        case 2:
            //Sign Out
            break;
            
        default:
            break;
    }
}

# pragma mark - Other Delegates
- (void)createClubTableViewControllerDidCancel:(UITableViewController *)createClubController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createClubTableViewController:(UITableViewController *)createClubController didSaveWithPFObject:(PFObject *)pfObject {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
