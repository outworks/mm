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

@property(nonatomic,assign) BOOL isLocked;

@property(nonatomic,assign) CLLocationCoordinate2D lastSaveLocation;

@end

@implementation TrackHelper

SYNTHESIZE_SINGLETON_FOR_CLASS(TrackHelper)

-(id)init{
    self = [super init];
    if (self) {
        [TrackTable deleteWithWhere:nil];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.updateTimer  = [NSTimer scheduledTimerWithTimeInterval:[ShareValue sharedShareValue].positionTimeInterval  target:self selector:@selector(saveAndUploadRequest) userInfo:nil repeats:YES];
            self.updateUnreadPointTimer  = [NSTimer scheduledTimerWithTimeInterval:(float)[ShareValue sharedShareValue].positionTimeInterval /2 target:self selector:@selector(updateUnreadData) userInfo:nil repeats:YES];
        });
    }
    return self;
}

-(BOOL)canStart{
    
    if ([ShareValue sharedShareValue].regiterUser && [ShareValue sharedShareValue].positionTimeInterval>0) {
        return YES;
    }
    return NO;
}

-(void)updateUnreadData{
    if (![self canStart]) {
        return;
    }
    if (self.isLocked) {
        return;
    }
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
    if (![TrackHelper isNormalLocation:location]) {
        return;
    }
    if (_oldLocation.latitude > 0) {
        _oldLocation = location;
    }else {
        _oldLocation = location;
        [self saveLocation:location];
    }
}

-(void)saveLocation:(CLLocationCoordinate2D) location{
    if (![self canStart]) {
        return;
    }
    if (location.longitude>0) {
        [self updateLocation:location];
        [self saveAndUploadRequest];
    }
}

-(void)saveAndUploadRequest{
    if (![self canStart]) {
        return;
    }
    if (_oldLocation.longitude==0) {
        return;
    }
    if (self.isLocked) {
        return;
    }
    self.isLocked = YES;
    TrackTable *trackTable = [[TrackTable alloc]init];
    trackTable.lon = _oldLocation.longitude;
    trackTable.lat = _oldLocation.latitude;
    if (_lastSaveLocation.latitude > 0) {
        BMKMapPoint point1 = BMKMapPointForCoordinate(_oldLocation);
        BMKMapPoint point2 = BMKMapPointForCoordinate(_lastSaveLocation);
        _distance += BMKMetersBetweenMapPoints(point1,point2);
    }
    trackTable.distance = _distance;
    _lastSaveLocation = _oldLocation;
    [trackTable save];
    _distance = 0;
    [self updateTrackTable:trackTable success:^{
        self.isLocked = NO;
    } fail:^{
        self.isLocked = NO;
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
    t_request.kilometersNum = trackTable.distance;
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

+(BOOL)isNormalLocation:(CLLocationCoordinate2D) location{
    if (location.latitude > 26.0 && location.latitude < 27.0) {
        if (location.longitude >118.0 && location.longitude <120.0) {
            return YES;
        }
    }
    return NO;
}

@end
