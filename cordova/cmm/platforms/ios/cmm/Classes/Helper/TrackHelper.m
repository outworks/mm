//
//  TrackHelper.m
//  cmm
//
//  Created by ilikeido on 15/4/18.
//
//

#import "TrackHelper.h"
#import "NoticeMacro.h"
#import "TrackTable.h"
#import "ShareValue.h"
#import "TrackAPI.h"
#import "NSDate+Helper.h"

@interface TrackHelper()

@property(nonatomic,assign) CLLocationCoordinate2D oldLocation;
@property(nonatomic,assign) CLLocationDistance distance;

@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) NSTimer *updateUnreadPointTimer;

@property(nonatomic,strong) NSArray *waitingUpdateDatas;

@property(nonatomic,assign) int updateIndex;

@end

@implementation TrackHelper

SYNTHESIZE_SINGLETON_FOR_CLASS(TrackHelper)

-(id)init{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.updateTimer  = [NSTimer scheduledTimerWithTimeInterval:[ShareValue sharedShareValue].positionTimeInterval *6 target:self selector:@selector(saveAndUploadRequest) userInfo:nil repeats:YES];
            self.updateUnreadPointTimer  = [NSTimer scheduledTimerWithTimeInterval:[ShareValue sharedShareValue].positionTimeInterval *2 target:self selector:@selector(updateUnreadData) userInfo:nil repeats:YES];

        });
    }
    return self;
}

-(void)updateUnreadData{
   NSArray *array =  [TrackTable searchWithWhere:[NSString stringWithFormat:@"isFinish=0"] orderBy:nil offset:0 count:100];
   if (array.count==0) {
        return;
   }
   self.waitingUpdateDatas = array;
   self.updateIndex = 0;
   [self beginUpdateBatch];
}


-(void)beginUpdateBatch{
    if (self.waitingUpdateDatas.count == 0 || (self.updateIndex == self.waitingUpdateDatas.count)) {
        self.waitingUpdateDatas = nil;
        self.updateIndex = 0;
        return;
    }
    TrackTable *trackTable = [self.waitingUpdateDatas objectAtIndex:self.updateIndex];
    __weak TrackHelper *weakself = self;
    [self updateTrackTable:trackTable success:^{
        self.updateIndex ++;
        [weakself beginUpdateBatch];
    } fail:^{
        self.updateIndex ++;
        [weakself beginUpdateBatch];
    }];
}

-(void)updateLocation:(CLLocationCoordinate2D) location{
    if (_oldLocation.latitude > 0) {
        BMKMapPoint point1 = BMKMapPointForCoordinate(_oldLocation);
        BMKMapPoint point2 = BMKMapPointForCoordinate(location);
        _distance += BMKMetersBetweenMapPoints(point1,point2);
        _oldLocation = location;
    }else {
        _oldLocation = location;
        [self saveLocation:location];
    }
}

-(void)saveLocation:(CLLocationCoordinate2D) location{
    if (location.longitude>0) {
        [self updateLocation:location];
        [self saveAndUploadRequest];
    }
}

-(void)saveAndUploadRequest{
    if (_oldLocation.longitude==0) {
        return;
    }
    TrackTable *trackTable = [[TrackTable alloc]init];
    trackTable.lon = _oldLocation.longitude;
    trackTable.lat = _oldLocation.latitude;
    trackTable.distance = _distance;
    [trackTable save];
    [self updateTrackTable:trackTable success:^{
        
    } fail:^{
        
    }];
}

-(void)updateTrackTable:(TrackTable *)trackTable success:(void (^)(void))sucess fail:(void (^)(void))fail{
    TrackHttpRequest *t_request = [[TrackHttpRequest alloc] init];
    trackTable.userid = [ShareValue sharedShareValue].regiterUser.userId;
    t_request.lon = trackTable.lon;
    t_request.lat = trackTable.lat;
    t_request.type = trackTable.type;
    t_request.gatherTime = trackTable.gatherTime;
    t_request.postionWay = trackTable.postionWay;
    t_request.userId = trackTable.userid;
    t_request.uploadTime = [[NSDate date]stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [TrackAPI visitTrackHttpAPIWithRequest:t_request Success:^(NSInteger result, NSString *msg) {
        trackTable.isFinish = 1;
        [trackTable save];
        sucess();
    } fail:^(NSString *description) {
        trackTable.type = 2;
        [trackTable save];
        fail();
    }];
}

@end
