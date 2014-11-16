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
-(void)hideBarButtons;
-(void)showBarButtons;
-(void)cancelEditing;
-(void)dismissKeyboard;
@end
@implementation NSCProfileViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.emailField.delegate = self;
    // Do any additional setup after loading the view.
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
    [self hideBarButtons];
}
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
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error || !succeeded){
            [[PFUser currentUser] saveEventually];
        }
    }];
    self.info = @[self.firstNameField.text, self.lastNameField.text, self.emailField.text].mutableCopy;
    [self dismissKeyboard];
}
-(IBAction)signOut:(UIBarButtonItem *)sender{
    [PFUser logOut];
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"login"] animated:YES completion:nil];
}
-(void)cancelEditing{
    [self dismissKeyboard];
    self.firstNameField.text = (NSString *)self.info[0];
    self.lastNameField.text = (NSString *)self.info[1];
    self.emailField.text = (NSString *)self.info[2];
    [self hideBarButtons];
}
-(void)dismissKeyboard{
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
-(void)hideBarButtons{
    if(self.navigationItem.rightBarButtonItem){
        self.navigationItem.rightBarButtonItem = nil;
    }
    UIBarButtonItem *signOut = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOut:)];
    self.navigationItem.leftBarButtonItem = signOut;
}
-(void)showBarButtons{
    if(!self.navigationItem.rightBarButtonItem){
        UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditing)];
        cancel.title = @"Cancel";
        self.navigationItem.leftBarButtonItem = cancel;
        self.navigationItem.rightBarButtonItem = save;
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
    [self showBarButtons];
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