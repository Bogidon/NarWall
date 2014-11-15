//
//  ClubsTableViewController.m
//  NarWall
//
//  Created by Bogdan Vitoc on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

#import "ClubsTableViewController.h"

@interface ClubsTableViewController () <UIActionSheetDelegate>
@end

@implementation ClubsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
            UIViewController *createClubNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateClubNavigationController"];
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

@end
