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
#import "NSCClubDetailViewController.h"

typedef void(^completionHandler)();

@interface ClubsTableViewController () <CreateClubTableViewControllerDelegate>{
    NSMutableArray *categories;
    NSMutableArray *clubs;
    NSMutableArray *totalArray;
}
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property ClubCategoryManager *clubCategoryManager;
-(void)refresh;
@end

@implementation ClubsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"Clubs";
    self.tableView.backgroundColor = [UIColor colorWithRed:255/255.0 green:246/255.0 blue:229/255.0 alpha:1.0];
    
    clubs = [NSMutableArray array];
    categories = [NSMutableArray array];
    
    [self getTableData:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self getTableData:^(){
//        [self spinAllDisclosuresUp];
//    }];
}

-(void)refresh{
    [self.refreshControl beginRefreshing];
    [self getTableData:^(){
        [self spinAllDisclosuresUp];
        [self.refreshControl endRefreshing];
    }];
}

-(void)getTableData:(completionHandler)handler {
    self.clubCategoryManager = [[ClubCategoryManager alloc] init];
    PFQuery *clubsQuery = [PFQuery queryWithClassName:@"Clubs"];
    [clubsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            
            for (PFObject *club in objects) {
                [self.clubCategoryManager addClub:club withCategoryName:club[@"category"]];
            }
            
            [self.tableView reloadData];
            if (handler) handler();
            
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
        ClubCategory *clubCategory = self.clubCategoryManager.categories[indexPath.section];
        NSString *name = [self.clubCategoryManager nameOfCategoryAtIndex:indexPath.section];
        NSInteger clubCount = clubCategory.clubs.count;
        cell.titleLabel.text =  [NSString stringWithFormat:@"%@ (%lo)", name, (long) clubCount];
        
        UIImage *iconImage = [UIImage imageNamed:name];
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
    
    if (indexPath.row == 0) {
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
    } else {
        ClubCell *cell = (ClubCell*)[tableView cellForRowAtIndexPath:indexPath];
        NSCClubDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"clubDetail"];
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController view];
        [detailViewController setPFObject:[self.clubCategoryManager clubWithIndex:indexPath.row - 1 inCategoryWithIndex:indexPath.section]];
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
- (IBAction)collapseTableView:(id)sender {
    [self spinAllDisclosuresUp];
    for (int categoryCount = 0; categoryCount < self.clubCategoryManager.categories.count; categoryCount++) {
        ClubCategory *category = self.clubCategoryManager.categories[categoryCount];
        
        if (category.isVisible) {
            category.isVisible = NO;
            
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (int clubCount = 0; clubCount < category.clubs.count; clubCount++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:clubCount + 1 inSection:categoryCount];
                [indexPaths addObject:indexPath];
            }
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
    }
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

- (void)spinAllDisclosuresUp {
    for (int i = 0; i < self.clubCategoryManager.categories.count; i++) {
        CategoryDropdownCell *cell = (CategoryDropdownCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        if (cell.direction == NSCPointerDirectionUp) {
            [cell spinWithOptions:UIViewAnimationOptionTransitionNone];
        }
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
