//
//  ClubCategoryManager.m
//  
//
//  Created by Bogdan Vitoc on 11/15/14.
//
//

#import "ClubCategoryManager.h"
#import "ClubCategory.h"

@interface ClubCategoryManager ()
@property NSMutableArray *private__Categories;
@end

@implementation ClubCategoryManager

- (void)addClub:(PFObject *)club withCategoryName:(NSString *)categoryName {
    
    for (ClubCategory *category in self.categories) {
        if ([category.name isEqualToString:categoryName]) {
            [category addClub:club];
            return;
        }
    }
    
    ClubCategory *newCategory = [[ClubCategory alloc] init];
    newCategory.name = categoryName;
    newCategory.isVisible = YES;
    [newCategory addClub:club];
    [self addCategory:newCategory];
}

- (NSUInteger)numberOfVisibleClubsAtIndex:(NSInteger)idx {
    ClubCategory *category = ((ClubCategory*)self.categories[idx]);
    
    if (category.isVisible) {
        return category.clubs.count;
    }
    return 0;
}

- (PFObject*)clubWithIndex:(NSInteger)clubIdx inCategoryWithIndex:(NSInteger)categoryIdx {
    return ((ClubCategory*)self.categories[categoryIdx]).clubs[clubIdx];
}

- (NSString*)nameOfCategoryAtIndex:(NSInteger)categoryIdx {
    return ((ClubCategory*)self.categories[categoryIdx]).name;
}

- (void)addCategory:(ClubCategory*)category {
    if(self.private__Categories == nil) {
        self.private__Categories = [NSMutableArray array];
    }
    [self.private__Categories addObject:category];
    self.categories = [NSArray arrayWithArray:self.private__Categories];
}

@end
