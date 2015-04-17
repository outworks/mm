//
//  TrackPolyLine.m
//  cmm
//
//  Created by Hcat on 15/4/17.
//
//

#import "TrackPolyLine.h"

@implementation TrackPolyLine

+ (TrackPolyLine *)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count{
    TrackPolyLine *t_trackPolyLine = [super polylineWithCoordinates:coords count:count];
    return t_trackPolyLine;
}

@end
