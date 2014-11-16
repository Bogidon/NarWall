//
//  CategoryDropdownCell.h
//  NarWall
//
//  Created by Bogdan Vitoc on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

@import UIKit;
@class ClubCategory;
NS_ENUM(int16_t, NSCPointerDirection){
    NSCPointerDirectionUp = 1,
    NSCPointerDirectionDown = 0
};
@interface CategoryDropdownCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureView;
@property (nonatomic) int16_t direction;
@property ClubCategory *clubCategory;

-(void)spinWithOptions:(UIViewAnimationOptions)options;
@end