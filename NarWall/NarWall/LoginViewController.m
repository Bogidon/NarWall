//
//  LoginViewController.m
//  NarWall
//
//  Created by Michael Hulet on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

#import "LoginViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import <Parse/Parse.h>
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *netIDField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
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
    spinner.center = self.loginButton.center;
    self.loginButton.hidden = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    [PFUser logInWithUsernameInBackground:self.netIDField.text password:self.passwordField.text block:^(PFUser *user, NSError *error){
        if(error){
            //Tell them they have a wrong password
            [spinner stopAnimating];
            [spinner removeFromSuperview];
            self.loginButton.hidden = NO;
        }
        else{
            [spinner stopAnimating];
            [spinner removeFromSuperview];
            self.loginButton.hidden = NO;
            [self.navigationController performSegueWithIdentifier:@"main" sender:self.navigationController];
        }
    }];
}
@end
