//
//  NSCProfileViewController.m
//  
//
//  Created by Michael Hulet on 11/16/14.
//
//

#import "NSCProfileViewController.h"
#import <Parse/Parse.h>
@interface NSCProfileViewController ()
@property (strong, nonatomic) PFUser *current;
@property (strong, nonatomic) NSMutableArray *info;
-(void)hideSaveButton;
-(void)showSaveButton;
@end
@implementation NSCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self hideSaveButton];
    if(self.current.email){
        self.emailField.text = self.current.email;
        self.emailField.clearsOnBeginEditing = NO;
    }
    else{
        self.emailField.text = @"email@example.com";
        self.emailField.clearsOnBeginEditing = YES;
    }
    if(self.current[@"firstName"]){
        self.firstNameField.text = self.current[@"firstName"];
        self.firstNameField.clearsOnBeginEditing = NO;
    }
    else{
        self.firstNameField.text = @"Your First Name";
        self.firstNameField.clearsOnBeginEditing = YES;
    }
    if(self.current[@"lastName"]){
        self.lastNameField.text = self.current[@"lastName"];
        self.lastNameField.clearsOnBeginEditing = NO;
    }
    else{
        self.lastNameField.text = @"Your Last Name";
        self.lastNameField.clearsOnBeginEditing = YES;
    }
    self.info = @[self.firstNameField.text, self.lastNameField.text, self.emailField.text].mutableCopy;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)save:(UIBarButtonItem *)sender{
    if(![self.firstNameField.text isEqualToString:@"Your First Name"] && ![self.firstNameField.text isEqualToString:@""]){
        [self.current setObject:self.firstNameField.text forKey:@"firstName"];
    }
    if(![self.lastNameField.text isEqualToString:@"Your Last Name"] && ![self.lastNameField.text isEqualToString:@""]){
        [self.current setObject:self.lastNameField.text forKey:@"lastName"];
    }
    if(![self.emailField.text isEqualToString:@"email@example.com"] && ![self.emailField.text isEqualToString:@""]){
        self.current.email = self.emailField.text;
    }
    [[PFUser currentUser] saveInBackground];
    if(self.firstNameField.isEditing){
        [self.firstNameField endEditing:YES];
    }
    if(self.lastNameField.isEditing){
        [self.lastNameField endEditing:YES];
    }
    if(self.emailField.isEditing){
        [self.emailField endEditing:YES];
    }
}
#pragma mark - UI Helper Methods
-(void)hideSaveButton{
    NSMutableArray *toolbar = self.toolbarItems.mutableCopy;
    if([toolbar containsObject:self.saveButton]){
        [toolbar removeObject:self.saveButton];
        [self setToolbarItems:toolbar animated:YES];
    }
}
-(void)showSaveButton{
    NSMutableArray *toolbar = self.toolbarItems.mutableCopy;
    if(![toolbar containsObject:self.saveButton]){
        [toolbar addObject:self.saveButton];
        [self setToolbarItems:toolbar animated:YES];
    }
}
#pragma mark - @property Lazy Instantiation
-(PFUser *)current{
    if(!_current){
        _current = [PFUser currentUser];
    }
    return _current;
}
#pragma mark - UITextFieldDelegate Protocol Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self showSaveButton];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(![textField.text isEqualToString:@""]){
        textField.clearsOnBeginEditing = NO;
    }
    else{
        textField.clearsOnBeginEditing = YES;
        if(textField == self.firstNameField){
            textField.text = @"Your First Name";
        }
        else if(textField == self.lastNameField){
            textField.text = @"Your Last Name";
        }
        else if(textField == self.emailField){
            textField.text = @"email@example.com";
        }
    }
}
@end
