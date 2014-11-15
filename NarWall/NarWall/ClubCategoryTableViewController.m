//
//  ClubCategoryTableViewController.m
//  NarWall
//
//  Created by Bogdan Vitoc on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

#import "ClubCategoryTableViewController.h"
#import "CategoryCell.h"

@interface ClubCategoryTableViewController () {
    NSArray *categoryTypes;
}

@end

@implementation ClubCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    categoryTypes = [NSArray arrayWithObjects:
                     @"Favorites",
                     @"Social & Interests",
                     @"Academic",
                     @"Art, Music, Performance"
                     @"",
                     nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return categoryTypes.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *categoryType = categoryTypes[indexPath.row];
    
    CategoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CategoryCell"];
    [cell.iconImageView setImage:[UIImage imageNamed:categoryType.lowercaseString]];
    cell.titleLabel.text = categoryType;
    cell.separatorInset = UIEdgeInsetsMake(0, 45, 0, 0);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didSelectCategory:categoryTypes[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
