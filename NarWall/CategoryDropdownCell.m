//
//  CategoryDropdownCell.m
//  NarWall
//
//  Created by Bogdan Vitoc on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

#import "CategoryDropdownCell.h"

@implementation CategoryDropdownCell

-(void)willMoveToSuperview:(UIView *)newSuperview {
    self.disclosureButton.titleLabel.text = @"";
    
    UITableViewCell *disclosure = [[UITableViewCell alloc] init];
    [self.disclosureButton addSubview:disclosure];
    disclosure.frame = self.disclosureButton.bounds;
    disclosure.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    disclosure.userInteractionEnabled = NO;
    disclosure.transform = CGAffineTransformMakeRotation(M_PI_2);
}

@end
