//
//  ClubCategoryManager.h
//  
//
//  Created by Bogdan Vitoc on 11/15/14.
//
//

@import Foundation;
@import Parse;

@interface ClubCategoryManager : NSObject

@property NSArray *categories;

- (void)addClub:(PFObject*)club withCategoryName:(NSString*)categoryName;

- (NSUInteger)numberOfVisibleClubsAtIndex:(NSInteger)idx;

- (PFObject*)clubWithIndex:(NSInteger)clubIdx inCategoryWithIndex:(NSInteger)categoryIdx;

- (NSString*)nameOfCategoryAtIndex:(NSInteger)categoryIdx;
@end
