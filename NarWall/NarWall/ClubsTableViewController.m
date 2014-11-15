//
//  ClubsTableViewController.m
//  NarWall
//
//  Created by Bogdan Vitoc on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

#import "ClubsTableViewController.h"
#import "CreateClubTableViewController.h"

@interface ClubsTableViewController () <UIActionSheetDelegate, CreateClubTableViewControllerDelegate>
@end

@implementation ClubsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Clubs";
    self.tabBarController.tabBarItem.title = @"Clubs";
    
    //Configure settings button
    self.settingsBarButtonItem.title = @"\u2699";
    UIFont *settingsFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24.0];
    NSDictionary *settingsAttributeDict = [[NSDictionary alloc] initWithObjectsAndKeys:settingsFont, NSFontAttributeName, nil];
    [self.settingsBarButtonItem setTitleTextAttributes:settingsAttributeDict forState:UIControlStateNormal];
    
}

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

- (void)createClubTableViewControllerDidCancel:(UITableViewController *)createClubController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createClubTableViewController:(UITableViewController *)createClubController didSaveWithPFObject:(PFObject *)pfObject {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
