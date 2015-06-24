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
#import "TrackHelper.h"

#import "VersionUpdataAPI.h"
#import "LKNavController.h"


#import <Cordova/CDVPlugin.h>

@interface AppDelegate()

@property(nonatomic,strong)BMKMapManager* mapManager;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) NSTimer *updateUnreadPointTimer;
@property(nonatomic,assign) NSInteger pointTag;

@property(nonatomic,assign) double before_lat;
@property(nonatomic,assign) double before_lon;


@property (nonatomic) NSMutableArray    *notifications;         // 通知队列
@property (nonatomic) NSThread          *notificationThread;    // 期望线程
@property (nonatomic) NSLock            *notificationLock;      // 用于对通知队列加锁的锁对象，避免线程冲突
@property (nonatomic) NSMachPort        *notificationPort;      // 用于向期望线程发送信号的通信端口

@property (nonatomic,strong)  VersionUpdataResponse *version;

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

#pragma mark - 初始化UI

-(void)initViewControllers{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        VersionUpdataRequest *t_request = [[VersionUpdataRequest alloc] init];
        t_request.clientType = @"ios";
        t_request.userId = @"123456";
        [VersionUpdataAPI versionUpdataHttpAPI:t_request Success:^(VersionUpdataResponse *response, NSInteger result, NSString *msg) {
            
            _version = response;
            
            NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            version = CURRENT_VERSION;
            if ([version compare:_version.nversion] == NSOrderedAscending) {
                //vesion < nversion
                UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"发现新版本:%@,是否更新",_version.nversion] delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"更新", nil];
                t_alertView.tag = 11;
                [t_alertView show];
            };
        } fail:^(NSString *description) {
            
        }];
    });
    
    
//    LKNavController *loginVC = [[LKNavController alloc]init];
//    loginVC.startPage = @"order.html?userId=1005992";
//    loginVC.startPage = @"index.html";
//
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

#pragma mark - 初始化第三方
-(void)thirdPartInit{
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"FufNFX9PxAmGkyKLPAEaCxmK"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

#pragma mark - 初始化定位功能

-(void)initData{
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
        _locationManager.distanceFilter = 10; //控制定位服务更新频率。单位是“米”
        [_locationManager startUpdatingLocation];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            
            [_locationManager requestAlwaysAuthorization];  //调用了这句,就会弹出允许框了.
        
    }
   
}

#pragma mark - 初始化准备上传未读点

//-(void)initForUnreadedPoint{
//
//    self.notifications = [[NSMutableArray alloc] init];
//    self.notificationLock = [[NSLock alloc] init];
//    
//    self.notificationThread = [NSThread currentThread];
//    self.notificationPort = [[NSMachPort alloc] init];
//    self.notificationPort.delegate = (id<NSMachPortDelegate>)self;
//    
//    // 往当前线程的run loop添加端口源
//    // 当Mach消息到达而接收线程的run loop没有运行时，则内核会保存这条消息，直到下一次进入run loop
//    [[NSRunLoop currentRunLoop] addPort:self.notificationPort
//                                forMode:(__bridge NSString *)kCFRunLoopCommonModes];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processNotification:) name:@"processNotification" object:nil];
//    
//    if(_updateUnreadPointTimer == nil){
//        NSLog(@"updateUnreadPointTimer");
//        
//        int time ;
//        if ([ShareValue sharedShareValue].positionTimeInterval == 0) {
//            time = 1;
//        }else{
//            
//            time = [ShareValue sharedShareValue].positionTimeInterval;
//        }
//        
//        _updateUnreadPointTimer = [NSTimer scheduledTimerWithTimeInterval:time*2
//                                                        target:self
//                                                      selector:@selector(UpdateUnReadedLocation)
//                                                      userInfo:nil
//                                                       repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_updateUnreadPointTimer forMode:NSRunLoopCommonModes];
//        
//    }
//    
//}

#pragma mark - 用户子线程可以发通知到主线程中。
//
//- (void)handleMachMessage:(void *)msg {
//    
//    [self.notificationLock lock];
//    
//    while ([self.notifications count]) {
//        NSNotification *notification = [self.notifications objectAtIndex:0];
//        [self.notifications removeObjectAtIndex:0];
//        [self.notificationLock unlock];
//        [self processNotification:notification];
//        [self.notificationLock lock];
//    };
//    
//    [self.notificationLock unlock];
//}

#pragma mark - 未读的点上传不管是失败还是成功通知继续上传
//
//- (void)processNotification:(NSNotification *)notification {
//    
//    if ([NSThread currentThread] != _notificationThread) {
//        // Forward the notification to the correct thread.
//        [self.notificationLock lock];
//        [self.notifications addObject:notification];
//        [self.notificationLock unlock];
//        [self.notificationPort sendBeforeDate:[NSDate date]
//                                   components:nil
//                                         from:nil
//                                     reserved:0];
//    }
//    else {
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            if ([ShareValue sharedShareValue].regiterUser == nil) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"processNotification" object:nil userInfo:nil];
//                return;
//            }
//            
//            NSArray *arr_tracks = [TrackTable searchWithWhere:@"isfinish= 0" orderBy:nil offset:0 count:0];
//            
//            if (arr_tracks.count == 0) {
//                NSLog(@"上传结束");
//                return;
//            }
//            
//            TrackTable *trackTable = arr_tracks.lastObject;
//            
//            [[TrackHelper  sharedTrackHelper] updateTrackTable:trackTable success:^{
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"processNotification" object:nil userInfo:nil];
//            } fail:^{
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"processNotification" object:nil userInfo:nil];
//            }];
//            
//        });
//      
//    }
//}
//
//#pragma mark - 上传未读的点
//
//-(void)UpdateUnReadedLocation{
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        if ([ShareValue sharedShareValue].regiterUser == nil) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"processNotification" object:nil userInfo:nil];
//            return;
//        }
//        
//        NSArray *arr_tracks = [TrackTable searchWithWhere:@"isfinish= 0" orderBy:nil offset:0 count:0];
//        
//        if (arr_tracks.count == 0) {
//            NSLog(@"上传结束");
//            return;
//        }
//        
//        TrackTable *trackTable = arr_tracks.lastObject;
//        [[TrackHelper  sharedTrackHelper] updateTrackTable:trackTable success:^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"processNotification" object:nil userInfo:nil];
//        } fail:^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"processNotification" object:nil userInfo:nil];
//        }];
//    });
//
//}
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
    NSUInteger supportedInterfaceOrientations = (1 << UIInterfaceOrientationPortrait);
    //(1 << UIInterfaceOrientationPortrait) | (1 << UIInterfaceOrientationLandscapeLeft) | (1 << UIInterfaceOrientationLandscapeRight) | (1 << UIInterfaceOrientationPortraitUpsideDown);


    return supportedInterfaceOrientations;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
//    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_APPWILLBACK object:nil];
    
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
    if (![ShareValue sharedShareValue].regiterUser) {
        return;
    }
    
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
    [ShareValue sharedShareValue].currentLocation = location;
    [[TrackHelper sharedTrackHelper] updateLocation:location];
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
    
    /*
     
    if(_updateTimer == nil){
        NSLog(@"updatetimer");
        
        int time ;
        if ([ShareValue sharedShareValue].positionTimeInterval == 0) {
            time = 1;
        }else{
        
            time = [ShareValue sharedShareValue].positionTimeInterval;
        }
        
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:time*60
                                                        target:self
                                                      selector:@selector(UpdateLocation)
                                                      userInfo:nil
                                                       repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_updateTimer forMode:NSRunLoopCommonModes];
         
    }
    */
    
}

//-(void)UpdateLocation{
//    [_updateTimer invalidate];
//    _updateTimer = nil;
//}


#pragma mark - alertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",buttonIndex);
    
    if (alertView.tag == 12) {
        if (buttonIndex == 0) {
           
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_version.filePath]];
            
        }
        
        [self exitApplication];
    }else{
        
        if (buttonIndex == 0) {
            
            NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            if ([version compare:_version.sversion] == NSOrderedAscending) {
                //vesion < nversion
                UIAlertView *t_alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"必须强制更新到%@版本,请更新",_version.sversion] delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"更新", nil];
                t_alertView.tag = 12;
                [t_alertView show];
            };
            
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_version.filePath]];
            
        }
    
    }
    
    
}


#pragma mark - 退出程序

- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
     //[UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    self.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}



- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
    
}



#pragma mark - Notification methods
//
//-(void)updateTimeIntterval:(NSNotification *)note{
//    
//    [_updateUnreadPointTimer invalidate];
//    _updateUnreadPointTimer = nil;
//    if(_updateUnreadPointTimer == nil){
//        
//        NSLog(@"updateUnreadPointTimer------update");
//        
//        int time ;
//        if ([ShareValue sharedShareValue].positionTimeInterval == 0) {
//            time = 1;
//        }else{
//            
//            time = [ShareValue sharedShareValue].positionTimeInterval;
//        }
//        
//        _updateUnreadPointTimer = [NSTimer scheduledTimerWithTimeInterval:time*60
//                                                                   target:self
//                                                                 selector:@selector(UpdateUnReadedLocation)
//                                                                 userInfo:nil
//                                                                  repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:_updateUnreadPointTimer forMode:NSRunLoopCommonModes];
//        
//    }
//}

@end
