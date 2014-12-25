//
//  ClubCategoryTableViewController.h
//  NarWall
//
//  Created by Bogdan Vitoc on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

@import UIKit;

@protocol ClubCategoryTableViewDelegate <NSObject>

-(void)didSelectCategory:(NSString*)category;

@end

@interface ClubCategoryTableViewController : UITableViewController <UITableViewDelegate>

@property(nonatomic, assign)id delegate;

@end