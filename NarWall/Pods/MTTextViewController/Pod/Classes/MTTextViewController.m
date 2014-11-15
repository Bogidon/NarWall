//
//  MTTextViewController.m
//
//  Created by Mat Trudel on 2/21/13.
//  Copyright (c) 2013 Mat Trudel. All rights reserved.
//

#import "MTTextViewController.h"

@interface MTTextViewController ()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation MTTextViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
        self.textView.font = [UIFont systemFontOfSize:14.];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text {
  if (self = [super initWithNibName:nil bundle:nil]) {
    self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.textView.text = text;
    self.textView.font = [UIFont systemFontOfSize:14.];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
  }
  return self;
}


#pragma mark - Lifecycle methods

- (void)loadView {
  self.view = self.textView;
}

#pragma mark - View appearance methods and attendant keyboard handlers

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.textView becomeFirstResponder];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardDidShowNotification object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
  NSDictionary *info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

  UIEdgeInsets contentInsets = self.textView.contentInset;
  contentInsets.bottom = kbSize.height + 10.;
  self.textView.contentInset = contentInsets;
  self.textView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  self.textView.contentInset = contentInsets;
  self.textView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Action handlers

- (IBAction)cancel:(id)sender {
  [self.textView resignFirstResponder];
  [self.delegate textViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender {
  [self.textView resignFirstResponder];
  [self.delegate textViewControllerDidFinish:self];
}

#pragma mark - Public API

- (NSString *)text {
  return self.textView.text;
}

@end