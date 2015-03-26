//
//  ShareValue.m
//  YiClock
//
//  Created by Hcat on 14-5-5.
//  Copyright (c) 2014年 CivetCatsTeam. All rights reserved.
//

#import "ShareValue.h"
#import "NSUserDefaults+Helpers.h"

#define SET_MEMBER @"SET_MEMBER"
#define SET_USERNAME @"SET_USERNAME"
#define SET_PASSWORD @"SET_PASSWORD"

@implementation ShareValue

SYNTHESIZE_SINGLETON_FOR_CLASS(ShareValue)

-(void)setIsRember:(BOOL)isRember{
    [[NSUserDefaults standardUserDefaults]setBool:isRember forKey:SET_MEMBER];
    if (!isRember) {
        [self setPassword:nil];
    }
}

-(BOOL)isRember{
    return [[NSUserDefaults standardUserDefaults]boolForKey:SET_MEMBER];
}

-(NSString *)userName{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SET_USERNAME];
}

-(void)setUserName:(NSString *)userName{
    [[NSUserDefaults standardUserDefaults]setValue:userName forKey:SET_USERNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)password{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SET_PASSWORD];
}

-(void)setPassword:(NSString *)password{
    [[NSUserDefaults standardUserDefaults]setValue:password forKey:SET_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setUser:(User *)user{
    if (user != nil) {
        _user.userId = user.userId;
        _user.userName = user.userName;
        _user.signImgUrl = user.signImgUrl;
        _user.jobId = user.jobId;
        _user.unitId = user.unitId;
        _user.payMent = user.payMent;
        _user.signName = user.signName;
        
    }
}





@end
