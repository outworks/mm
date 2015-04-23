//
//  TrackHttpResponse.m
//  cmm
//
//  Created by Hcat on 15/4/11.
//
//

#import "TrackHttpResponse.h"
#import "Track.h"
#import "Unit.h"

@implementation TrackQueryHttpResponse

@end

@implementation TrackListHttpResponse

+(Class)__trackClass{
    return [Track class];
}

+(Class)__unitClass{
    return [Unit class];
}

@end