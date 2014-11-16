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
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property ClubCategoryManager *clubCategoryManager;
-(void)refresh;
-(void)getClubData;
-(void)reloadTableViewData;
@end

@implementation ClubsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:255/255.0 green:246/255.0 blue:229/255.0 alpha:1.0];
    self.title = @"Clubs";
    clubs = [NSMutableArray array];
    categories = [NSMutableArray array];
    [self reloadTableViewData];
    //Configure settings button
    self.settingsBarButtonItem.title = @"\u2699";
    UIFont *settingsFont = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:24.0];
    NSDictionary *settingsAttributeDict = [[NSDictionary alloc] initWithObjectsAndKeys:settingsFont, NSFontAttributeName, nil];
    [self.settingsBarButtonItem setTitleTextAttributes:settingsAttributeDict forState:UIControlStateNormal];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.refreshControl];
}
-(void)reloadTableViewData{
    self.clubCategoryManager = [[ClubCategoryManager alloc] init];
    [self getClubData];
}
-(void)refresh{
    [self.refreshControl beginRefreshing];
    [self reloadTableViewData];
    [self.refreshControl endRefreshing];
}
-(void)getClubData{
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
        
        cell.clubCategory = self.clubCategoryManager.categories[indexPath.section];
                              
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
    
    cell.clubCategory.isVisible = !cell.clubCategory.isVisible;
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i < cell.clubCategory.clubs.count ; i++) {
        [indexPaths addObject: [NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]];
    }
    
    if (cell.clubCategory.isVisible) {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - No Inner-Section Space Hack
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 6.0;
    }
    
    return 1.0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Settings Pane
- (IBAction)toggleSettingsPane:(UIBarButtonItem *)sender {
    UIActionSheet *settingsActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add", @"Categories", @"Sign Out", nil];
    [settingsActionSheet showFromBarButtonItem:self.settingsBarButtonItem animated:YES];
}

- (IBAction)newClub:(UIBarButtonItem *)sender {
    UINavigationController *createClubNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateClubNavigationController"];
    
    if ([createClubNavigationController.topViewController isKindOfClass:[CreateClubTableViewController class]]) {
        CreateClubTableViewController *createClubViewController = (CreateClubTableViewController*)createClubNavigationController.topViewController;
        createClubViewController.delegate = self;
    }
    
    [self presentViewController:createClubNavigationController animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0 :{
            // Add club
            [self newClub:self.addButton];
            break;
        }
        
        case 1:
            //Categories
            break;
            
        case 2: {
            //Sign Out
            [PFUser logOut];
            UIViewController *signInSreen = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
            [self presentViewController:signInSreen animated:YES completion:nil];
            break;
        }
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
