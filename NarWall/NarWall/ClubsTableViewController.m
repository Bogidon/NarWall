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
#import "ClubCategory.h"
#import "ClubCategoryManager.h"
#import "ClubCell.h"

@interface ClubsTableViewController () <UIActionSheetDelegate, CreateClubTableViewControllerDelegate>{
    NSMutableArray *categories;
    NSMutableArray *clubs;
    NSMutableArray *totalArray;
}

@property ClubCategoryManager *clubCategoryManager;

@end

@implementation ClubsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Clubs";
    self.clubCategoryManager = [[ClubCategoryManager alloc] init];
    clubs = [NSMutableArray array];
    categories = [NSMutableArray array];
    
    //Get club data
    PFQuery *clubsQuery = [PFQuery queryWithClassName:@"Clubs"];
    [clubsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            
            for (PFObject *club in objects) {
                [self.clubCategoryManager addClub:club withCategoryName:club[@"category"]];
            }
            
            [self.tableView reloadData];
            
        } else {
            NSLog(@"%@", error);
        }
    }];
    
    //Solely for height calculation
    totalArray = [NSMutableArray array];
    int i = 0;
    for (NSMutableArray *array in clubs) {
        NSMutableArray *combinedArray = [NSMutableArray arrayWithArray:array];
        [combinedArray insertObject:[categories objectAtIndex:i] atIndex:0];
        i++;
    }
    
    //Configure settings button
    self.settingsBarButtonItem.title = @"\u2699";
    UIFont *settingsFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24.0];
    NSDictionary *settingsAttributeDict = [[NSDictionary alloc] initWithObjectsAndKeys:settingsFont, NSFontAttributeName, nil];
    [self.settingsBarButtonItem setTitleTextAttributes:settingsAttributeDict forState:UIControlStateNormal];
}

#pragma mark - Table View Layout
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.clubCategoryManager numberOfVisibleClubsAtIndex:section] + 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.clubCategoryManager.categories.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44;
    }
    if (indexPath.row > 0 ) {
        return 80;
    }
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        CategoryDropdownCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CategoryDropdownCell"];
        NSString *name = [self.clubCategoryManager nameOfCategoryAtIndex:indexPath.section];
        cell.titleLabel.text = name;
        
        UIImage *iconImage = [UIImage imageNamed:[name lowercaseString]];
        if (iconImage) {
            cell.iconImageView.image = iconImage;
        }
                              
        return cell;
        
    } else {
        ClubCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ClubCell"];
        PFObject *club = [self.clubCategoryManager clubWithIndex:(indexPath.row - 1) inCategoryWithIndex:indexPath.section];
        cell.titleLabel.text = club[@"name"];
        cell.descriptionLabel.text = club[@"description"];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CategoryDropdownCell *cell = (CategoryDropdownCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell spinWithOptions:UIViewAnimationOptionCurveEaseOut];
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
