//
//  MTTextViewController.h
//
//  Created by Mat Trudel on 2/21/13.
//  Copyright (c) 2013 Mat Trudel. All rights reserved.
//

@import UIKit;

@class MTTextViewController;

@protocol MTTextViewControllerDelegate <NSObject>
- (void)textViewControllerDidFinish:(MTTextViewController *)controller;
- (void)textViewControllerDidCancel:(MTTextViewController *)controller;
@end

@interface MTTextViewController : UIViewController
@property (nonatomic, weak) id<MTTextViewControllerDelegate> delegate;
@property (nonatomic, readonly) NSString *text;

- (instancetype)initWithText:(NSString *)text;

@end