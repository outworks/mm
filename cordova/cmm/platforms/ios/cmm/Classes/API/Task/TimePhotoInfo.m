//
//  TimePhotoInfo.m
//  cmm
//
//  Created by ilikeido on 15/4/11.
//
//

#import "TimePhotoInfo.h"
#import "NSDate+Helper.h"
#import "ShareValue.h"

@implementation TimePhotoInfo

-(id)init{
    self = [super init];
    if (self) {
        _time = [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd HH:mm:ss"];
        _lng = [NSString stringWithFormat:@"%lf",[ShareValue sharedShareValue].longitude];
        _lat = [NSString stringWithFormat:@"%lf",[ShareValue sharedShareValue].latitude];
    }
    return self;
}

@end
