//
//  LoginViewController.m
//  NarWall
//
//  Created by Michael Hulet on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

#import "LoginViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "PureLayout.h"
#import <Parse/Parse.h>
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *netIDField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonTopConstraint;
@property UILabel *errorLabel;
-(IBAction)login;
@end

@implementation LoginViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
}
-(void)didReceiveMemoryWarning {
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

-(IBAction)login{
    __block UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] init];
    [self.view addSubview:spinner];
    [spinner autoAlignAxis:ALAxisVertical toSameAxisOfView:self.loginButton];
    [spinner autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.loginButton];
    
    self.loginButton.hidden = YES;

    
    [spinner startAnimating];
    [PFUser logInWithUsernameInBackground:self.netIDField.text password:self.passwordField.text block:^(PFUser *user, NSError *error){
        if(error){
            //Tell them they have a wrong password
            if (!self.errorLabel) {
                self.errorLabel = [[UILabel alloc] init];
                self.errorLabel.text = @"Invalid Username or Password";
                self.errorLabel.textColor = [UIColor whiteColor];
                self.errorLabel.font = [UIFont fontWithName:@"ITCFranklinGothicStd-Book" size:16.0];
                self.errorLabel.alpha = 0.0;
                [self.scrollView addSubview:self.errorLabel];
                
                [self.scrollView setNeedsLayout];
                [UIView animateWithDuration:1.0
                                 animations:^(void){
                                     [self.scrollView removeConstraint:self.loginButtonTopConstraint];
                                     [self.errorLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.passwordField withOffset:8.0];
                                     [self.errorLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.loginButton withOffset:-5.0];
                                     [self.errorLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
                                     self.errorLabel.alpha = 1.0;
                                 }];
            }
            
            
            [spinner stopAnimating];
            [spinner removeFromSuperview];
            self.loginButton.hidden = NO;
            NSLog(@"Login failed");
        }
        else{
            [spinner stopAnimating];
            [spinner removeFromSuperview];
            self.loginButton.hidden = NO;
            [self.navigationController performSegueWithIdentifier:@"main" sender:self.navigationController];
            NSLog(@"Login succeeded");
        }
    }];
}
@end
