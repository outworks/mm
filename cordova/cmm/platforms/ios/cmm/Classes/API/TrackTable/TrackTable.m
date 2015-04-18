//
//  TrackTable.m
//  cmm
//
//  Created by Hcat on 15/4/11.
//
//

#import "TrackTable.h"
#import "NSDate+Helper.h"
#import "ShareValue.h"
#import "Reachability.h"

@implementation TrackTable

-(id)init{
    self = [super init];
    if (self) {
        _gatherTime = [[NSDate date]stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        _userid = [ShareValue sharedShareValue].regiterUser.userId;
        _type = 1;
        _postionWay = [Reachability reachabilityWithHostName:@"www.baidu.com"].isReachableViaWiFi?2:1;
    }
    return self;
}

-(void)save{
    [self updateToDB];
}

+(TrackTable *)loadMemberByPointTag:(NSInteger )pointTag{
    TrackTable *member = [TrackTable searchSingleWithWhere:[NSString stringWithFormat:@"pointTag=%ld",pointTag] orderBy:nil];
    return member;
}

@end
