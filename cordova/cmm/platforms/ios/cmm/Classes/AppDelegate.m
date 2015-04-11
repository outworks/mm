/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  cmm
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "LKNavController.h"
#import "SwipeLoginVC.h"
#import "ShareValue.h"

#import "LoginVC.h"
#import "BMapKit.h"

#import "TrackAPI.h"
#import "TrackTable.h"
#import "NSDate+Helper.h"



#import <Cordova/CDVPlugin.h>

@interface AppDelegate()

@property(nonatomic,strong)BMKMapManager* mapManager;
@property (nonatomic, strong) NSTimer *updateTimer;
@property(nonatomic,assign) NSInteger pointTag;

@property(nonatomic,assign) double before_lat;
@property(nonatomic,assign) double before_lon;

@end

@implementation AppDelegate

@synthesize window,viewController;

- (id)init
{
    /** If you need to do any extra app-specific initialization, you can do it here
     *  -jm
     **/
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    int cacheSizeMemory = 8 * 1024 * 1024; // 8MB
    int cacheSizeDisk = 32 * 1024 * 1024; // 32MB
#if __has_feature(objc_arc)
        NSURLCache* sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
#else
        NSURLCache* sharedCache = [[[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"] autorelease];
#endif
    [NSURLCache setSharedURLCache:sharedCache];

    self = [super init];
    return self;
}


#pragma mark - initViewControllers

-(void)initViewControllers{

    LoginVC *loginVC = [[LoginVC alloc] init];
    
    self.viewController = [[UINavigationController alloc]initWithRootViewController:loginVC];
    self.viewController.navigationBarHidden = YES;
    self.window.rootViewController = self.viewController;
    
    NSString *savedPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"gesturePassword"];
    BOOL isLoginOut = [ShareValue sharedShareValue].isLoginOut;

    if (savedPassword != nil && isLoginOut == NO) {
        SwipeLoginVC *swipeLoginVC = [[SwipeLoginVC alloc] init];
        [self.viewController pushViewController:swipeLoginVC animated:NO];
    }
    
    
    [self thirdPartInit];
    _pointTag = 0;
    [self initData];
    
    [self.window makeKeyAndVisible];
    
}

-(void)thirdPartInit{
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"FufNFX9PxAmGkyKLPAEaCxmK"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

//初始化数据
-(void)initData{
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
        _locationManager.distanceFilter = 100; //控制定位服务更新频率。单位是“米”
        [_locationManager startUpdatingLocation];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            
            [_locationManager requestAlwaysAuthorization];  //调用了这句,就会弹出允许框了.
        
    }
   
}



#pragma mark UIApplicationDelegate implementation

/**
 * This is main kick off after the app inits, the views and Settings are setup here. (preferred - iOS4 and up)
 */
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];

#if __has_feature(objc_arc)
        self.window = [[UIWindow alloc] initWithFrame:screenBounds];
#else
        self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];
#endif
    self.window.autoresizesSubviews = YES;
    
    if ([TrackTable deleteWithWhere:@"isfinish= 1"]) {
        NSLog(@"删除已完成的点");
    }
    
    NSArray *arr_tracks = [TrackTable searchWithWhere:@"isfinish= 0" orderBy:nil offset:0 count:0];
    
    
    
    

    // Set your app's start page by setting the <content src='foo.html' /> tag in config.xml.
    // If necessary, uncomment the line below to override it.
    //self.viewController.startPage = @"test.html";
    
    // NOTE: To customize the view's frame size (which defaults to full screen), override
    // [self.viewController viewWillAppear:] in your view controller.
    [self initViewControllers];
    return YES;
}

// this happens while we are running ( in the background, or from within our own app )
// only valid if cmm-Info.plist specifies a protocol to handle
- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{
    if (!url) {
        return NO;
    }

    //[self.viewController processOpenUrl:url];

    // all plugins will get the notification, and their handlers will be called
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];

    return YES;
}

// repost all remote and local notification using the default NSNotificationCenter so multiple plugins may respond
- (void)            application:(UIApplication*)application
    didReceiveLocalNotification:(UILocalNotification*)notification
{
    // re-post ( broadcast )
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVLocalNotification object:notification];
}

- (void)                                 application:(UIApplication*)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    // re-post ( broadcast )
    NSString* token = [[[[deviceToken description]
        stringByReplacingOccurrencesOfString:@"<" withString:@""]
        stringByReplacingOccurrencesOfString:@">" withString:@""]
        stringByReplacingOccurrencesOfString:@" " withString:@""];

    [[NSNotificationCenter defaultCenter] postNotificationName:CDVRemoteNotification object:token];
}

- (void)                                 application:(UIApplication*)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // re-post ( broadcast )
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVRemoteNotificationError object:error];
}

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    // iPhone doesn't support upside down by default, while the iPad does.  Override to allow all orientations always, and let the root view controller decide what's allowed (the supported orientations mask gets intersected).
    NSUInteger supportedInterfaceOrientations = (1 << UIInterfaceOrientationPortrait) | (1 << UIInterfaceOrientationLandscapeLeft) | (1 << UIInterfaceOrientationLandscapeRight) | (1 << UIInterfaceOrientationPortraitUpsideDown);

    return supportedInterfaceOrientations;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}

- (void)applicationWillTerminate:(UIApplication *)application{




}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            
            if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
                
                [self.locationManager requestAlwaysAuthorization];
                
            }
            
            break;
            
        case kCLAuthorizationStatusDenied:
            
            [[[UIAlertView alloc] initWithTitle:@"" message:@"请在设置-隐私-定位服务中开启定位功能！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
            break;
            
        case kCLAuthorizationStatusRestricted:
            
             [[[UIAlertView alloc] initWithTitle:@"" message:@"定位服务无法使用！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

        default:
            
            break;
            
    }
    
}

//吏新定位
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
//    [ShareValue sharedShareValue].latitude = newLocation.coordinate.latitude; //纬度
//    [ShareValue sharedShareValue].longitude = newLocation.coordinate.longitude; // 经度
    
    //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
    NSDictionary* testdic = BMKConvertBaiduCoorFrom(newLocation.coordinate,BMK_COORDTYPE_COMMON);
    //转换GPS坐标至百度坐标
    testdic = BMKConvertBaiduCoorFrom(newLocation.coordinate,BMK_COORDTYPE_GPS);
    //NSLog(@"x=%@,y=%@",[testdic objectForKey:@"x"],[testdic objectForKey:@"y"]);
    CLLocationCoordinate2D location = BMKCoorDictionaryDecode(testdic);
    [ShareValue sharedShareValue].latitude = location.latitude; //纬度
    [ShareValue sharedShareValue].longitude = location.longitude;
//    NSLog(@"x=%lf,y=%lf",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
//    
//    NSLog(@"x=%lf,y=%lf",[ShareValue sharedShareValue].latitude,[ShareValue sharedShareValue].longitude);

    if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATALOCATIONPOINT object:nil];
        
    }
    else
    {
        NSLog(@"applicationD in Background,newLocation:%@", newLocation);
    }
    
    if(_updateTimer == nil){
        NSLog(@"updatetimer");
        
        int time ;
        if ([ShareValue sharedShareValue].positionTimeInterval == 0) {
            time = 2;
        }else{
        
            time = [ShareValue sharedShareValue].positionTimeInterval;
        }
        
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                        target:self
                                                      selector:@selector(UpdateLocation)
                                                      userInfo:nil
                                                       repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_updateTimer forMode:NSRunLoopCommonModes];
    }
    
    
}

-(void)UpdateLocation{
    [self saveTrack];
    
    [_updateTimer invalidate];
    _updateTimer = nil;
}

-(void)saveTrack{
    
    TrackTable *t_trackTable = [[TrackTable alloc] init];
    t_trackTable.lon = [ShareValue sharedShareValue].longitude;
    t_trackTable.lat = [ShareValue sharedShareValue].latitude;
    t_trackTable.type = @"1";
    t_trackTable.postionWay = @"1";
    t_trackTable.gatherTime = [NSDate stringFromDate:[NSDate date] withFormat:[NSDate timestampFormatString]];
    t_trackTable.pointTag = _pointTag;
    t_trackTable.isFinish = @"0";
    
    if (_pointTag == 0) {
        t_trackTable.kilometersNum = @"0";
    }else{
        BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(_before_lat,_before_lon));
        BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([ShareValue sharedShareValue].latitude,[ShareValue sharedShareValue].longitude));
        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
        t_trackTable.kilometersNum = [NSString stringWithFormat:@"%lf",distance];
        
    }
    
    [t_trackTable save];
    _pointTag ++;
    
    _before_lat = [ShareValue sharedShareValue].latitude;
    _before_lon = [ShareValue sharedShareValue].longitude;

    
    [self updateTrack:t_trackTable];
}


-(void)updateTrack:(TrackTable *)trackTable{

    if ([ShareValue sharedShareValue].regiterUser == nil) {
        return;
    }
    
    TrackHttpRequest *t_request = [[TrackHttpRequest alloc] init];
    t_request.userId = [ShareValue sharedShareValue].regiterUser.userId;
    t_request.lon = [NSString stringWithFormat:@"%lf",trackTable.lon];
    t_request.lat = [NSString stringWithFormat:@"%lf",trackTable.lat];
    t_request.type = trackTable.type;
    t_request.gatherTime = trackTable.gatherTime;
    t_request.postionWay = trackTable.postionWay;
    t_request.uploadTime = [NSDate stringFromDate:[NSDate date] withFormat:[NSDate timestampFormatString]];
    t_request.kilometersNum = trackTable.kilometersNum;

    [TrackAPI visitTrackHttpAPIWithRequest:t_request Success:^(NSInteger result, NSString *msg) {
        trackTable.isFinish = @"1";
        [trackTable updateToDB];
        
    } fail:^(NSString *description) {
        
        NSLog(@"这个点上传失败!");
        
    }];
}

@end
