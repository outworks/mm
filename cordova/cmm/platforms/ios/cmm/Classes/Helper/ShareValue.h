//
//  ShareValue.h
//  YiClock
//
//  Created by Hcat on 14-5-5.
//  Copyright (c) 2014年 CivetCatsTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCSingletonTemplate.h"
#import "User.h"
#import <CoreLocation/CLLocation.h>

#define SYSTEM_VERSION @"1.0.0"

#define SYSTEM_DEVERLOPER 0

#define CURRENT_VERSION @"11"

@interface ShareValue : NSObject{
    User *_regiterUser;
}



@property(nonatomic,assign) BOOL isRember;
@property(nonatomic,assign) BOOL isLoginOut;
@property(nonatomic,strong) NSString *loginUserName;
@property(nonatomic,strong) NSString *password;
@property(nonatomic,strong) User *regiterUser;
@property(nonatomic,strong) NSString *fileBaseUrl;
@property(nonatomic,assign) int positionTimeInterval;

@property(nonatomic,strong) NSString *selectedMenuId;

@property(nonatomic,assign) double latitude;
@property(nonatomic,assign) double longitude;

@property(nonatomic,assign) CLLocationCoordinate2D currentLocation;


SYNTHESIZE_SINGLETON_FOR_HEADER(ShareValue)

@end
