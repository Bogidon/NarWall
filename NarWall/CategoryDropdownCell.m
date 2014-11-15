//
//  CategoryDropdownCell.m
//  NarWall
//
//  Created by Bogdan Vitoc on 11/15/14.
//  Copyright (c) 2014 New School Crew. All rights reserved.
//

#import "CategoryDropdownCell.h"
#import "PureLayout.h"

@import QuartzCore;

@interface CategoryDropdownCell () {
    BOOL animating;
}

@end

@implementation CategoryDropdownCell

-(void)willMoveToSuperview:(UIView *)newSuperview {
    
    [self spinWithOptions:UIViewAnimationOptionCurveEaseInOut];
}

- (void) spinWithOptions: (UIViewAnimationOptions) options {
    
    [UIView animateWithDuration: 0.5f
                          delay: 2.0f
                        options: options
                     animations: ^{
                         self.disclosureView.transform = CGAffineTransformMakeRotation(M_PI);
//                         self.disclosureView.transform = CGAffineTransformRotate(self.disclosureView.transform, M_PI);
                     }
                     completion: ^(BOOL finished) {
//                         if (finished) {
//                             if (animating) {
//                                 // if flag still set, keep spinning with constant speed
//                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
//                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
//                                 // one last spin, with deceleration
//                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
//                             }
//                         }
                     }];
}

- (void) startSpin {
    if (!animating) {
        animating = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
    }
}

- (void) stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    animating = NO;
}

@end