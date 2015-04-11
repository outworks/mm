//
//  TrackTable.m
//  cmm
//
//  Created by Hcat on 15/4/11.
//
//

#import "TrackTable.h"


@implementation TrackTable

-(void)save{

    [self saveToDB];
}

+(TrackTable *)loadMemberByPointTag:(NSInteger )pointTag{
    TrackTable *member = [TrackTable searchSingleWithWhere:[NSString stringWithFormat:@"pointTag=%ld",pointTag] orderBy:nil];
    return member;
}

@end
