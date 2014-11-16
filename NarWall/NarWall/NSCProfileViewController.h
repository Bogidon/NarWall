//
//  NSCProfileViewController.h
//  
//
//  Created by Michael Hulet on 11/16/14.
//
//

@import UIKit;
@interface NSCProfileViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
- (IBAction)save:(UIBarButtonItem *)sender;
@end