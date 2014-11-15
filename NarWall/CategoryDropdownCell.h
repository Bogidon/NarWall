//
//  CategoryDropdownCell.h
//  NarWall
//
//  Created by Bogdan Vitoc on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

@import UIKit;
@class ClubCategory;

@interface CategoryDropdownCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureView;
@property ClubCategory *clubCategory;

-(void)spinWithOptions:(UIViewAnimationOptions)options;
@end