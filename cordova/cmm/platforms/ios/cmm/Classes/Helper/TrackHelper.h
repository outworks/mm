//
//  TrackHelper.h
//  cmm
//
//  Created by ilikeido on 15/4/18.
//
//

#import <Foundation/Foundation.h>
#import "ARCSingletonTemplate.h"
#import "BMapKit.h"

@class TrackTable;

@interface TrackHelper : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(TrackHelper)

-(void)saveLocation:(CLLocationCoordinate2D) location;

-(void)updateTrackTable:(TrackTable *)trackTable success:(void (^)(void))sucess fail:(void (^)(void))fail;

-(void)updateLocation:(CLLocationCoordinate2D) location;

-(void)saveAndUploadRequest;

@end
