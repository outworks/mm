//
//  TrackPolyLine.h
//  cmm
//
//  Created by Hcat on 15/4/17.
//
//

#import "BMKPolyline.h"
#import "Track.h"

@interface TrackPolyLine : BMKPolyline

@property(nonatomic,strong)Track *track;

+ (TrackPolyLine *)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

@end
