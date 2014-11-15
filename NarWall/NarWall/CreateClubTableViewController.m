//
//  CreateClubTableViewController.m
//  NarWall
//
//  Created by Bogdan Vitoc on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

#import "CreateClubTableViewController.h"
#import "ClubCategoryTableViewController.h"
#import "MTTextViewController.h"

@interface CreateClubTableViewController () <ClubCategoryTableViewDelegate, MTTextViewControllerDelegate,UITableViewDelegate>

@end

@implementation CreateClubTableViewController

- (void)viewDidLoad {
    if ([self.nameTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        self.nameTextField.attributedPlaceholder = [self placeholderAttrStringWithString:@"Name" color:[UIColor lightGrayColor]];
        self.meetingTextField.attributedPlaceholder = [self placeholderAttrStringWithString:@"Meeting (e.g. every other Tuesday)" color:[UIColor lightGrayColor]];
        self.locationTextField.attributedPlaceholder = [self placeholderAttrStringWithString:@"Location" color:[UIColor lightGrayColor]];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
    }
}

- (NSAttributedString*)placeholderAttrStringWithString:(NSString*)string color:(UIColor*)color {
        return [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: color}];
}

#pragma mark - Transitions
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CategoriesSegue"]) {
        ClubCategoryTableViewController *categoryController = segue.destinationViewController;
        categoryController.delegate = self;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView cellForRowAtIndexPath:indexPath] isEqual:self.descriptionCell]) {
        MTTextViewController *descriptionController = [[MTTextViewController alloc] initWithText:self.descriptionLabel.text];
        descriptionController.title = @"Description";
        descriptionController.delegate = self;
        [self.navigationController pushViewController:descriptionController animated:YES];
    }
}
#pragma mark - Delegate Methods
- (void)didSelectCategory:(NSString *)category {
    self.categoryLabel.text = category;
}

- (void)textViewControllerDidFinish:(MTTextViewController *)controller {
    self.descriptionLabel.text = controller.text;
    [self.navigationController popToViewController:self animated:YES];
}

- (void)textViewControllerDidCancel:(MTTextViewController *)controller {
    [self.navigationController popToViewController:self animated:YES];
}

@end
