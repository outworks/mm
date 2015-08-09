//
//  ShareValue.m
//  YiClock
//
//  Created by Hcat on 14-5-5.
//  Copyright (c) 2014年 CivetCatsTeam. All rights reserved.
//

#import "ShareValue.h"
#import "NoticeMacro.h"
#import "NSUserDefaults+Helpers.h"


#define SET_MEMBER @"SET_MEMBER"
#define SET_LOGINUSERNAME @"SET_LOGINUSERNAME"
#define SET_PASSWORD @"SET_PASSWORD"

#define SET_LOGINOUT @"SET_LOGINOUT"
#define SET_USERID @"SETUSERID"
#define SET_USERNAME @"SET_USERNAME"
#define SET_SIGNIMGURL @"SET_SIGNIMGURL"
#define SET_JOBID @"SET_JOBID"
#define SET_UNITID @"SET_UNITID"
#define SET_PAYMENT @"SET_PAYMENT"
#define SET_SIGNNAME @"SET_SIGNNAME"
#define SET_FILEBASEURL @"SET_FILEBASEURL"
#define SET_POSTIONTIMEINTERVAL @"SET_POSTIONTIMEINTERVAL"
#define SET_SELECTEDMENUID @"SET_SELECTEDMENUID"
#define SET_ERRORTIME @"SET_ERRORTIME"
#define SET_PWDERRORCOUNT @"SET_PWDERRORCOUNT"

@implementation ShareValue

SYNTHESIZE_SINGLETON_FOR_CLASS(ShareValue)

-(id)init{
    self = [super init];
    if(self){
       
    }
    return self;
}

-(BOOL)isFirstErrorTimeValid{
    NSTimeInterval timeInterval = self.errorTimer;
    if (timeInterval > 0  ) {
        NSDate *date = [[NSDate alloc]initWithTimeIntervalSinceReferenceDate:timeInterval];
        return [[date dateByAddingTimeInterval:60*60] laterDate:[NSDate date]];
    }
    return NO;
}

-(BOOL)isLocked{
    return [self isFirstErrorTimeValid] && (self.pwderrorcount >=10);
}

-(void)clearErrorTime{
    self.errorTimer = 0;
    self.pwderrorcount = 0;
}

-(BOOL)addErrorTimerCount{
    if(![self isFirstErrorTimeValid]){
        self.errorTimer = [NSDate timeIntervalSinceReferenceDate];
        self.pwderrorcount = 0;
    }
    int timecount = self.pwderrorcount;
    timecount ++;
    if (timecount == 1) {
        [self setErrorTimer:[NSDate timeIntervalSinceReferenceDate]];
    }
    if(timecount <= 10){
        self.pwderrorcount = timecount;
        if (timecount == 10) {
            return YES;
        }
    }
    return NO;
}

-(void)setIsRember:(BOOL)isRember{
    [[NSUserDefaults standardUserDefaults]setBool:isRember forKey:SET_MEMBER];
    if (!isRember) {
        [self setPassword:nil];
    }
}

-(BOOL)isRember{
    return [[NSUserDefaults standardUserDefaults]boolForKey:SET_MEMBER];
}

-(void)setIsLoginOut:(BOOL)isLoginOut{
    [[NSUserDefaults standardUserDefaults]setBool:isLoginOut forKey:SET_LOGINOUT];

}

-(BOOL)isLoginOut{
    return [[NSUserDefaults standardUserDefaults]boolForKey:SET_LOGINOUT];

}

-(int)pwderrorcount{
    return (int)[[NSUserDefaults standardUserDefaults]integerForKey:SET_PWDERRORCOUNT];
}

-(void)setPwderrorcount:(int)pwderrorcount{
    [[NSUserDefaults standardUserDefaults]setInteger:pwderrorcount forKey:SET_PWDERRORCOUNT];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSTimeInterval ) errorTimer{
    NSString *errorTime = [[NSUserDefaults standardUserDefaults]stringForKey:SET_ERRORTIME];
    if (!errorTime) {
        return 0;
    }
    NSTimeInterval time = [errorTime doubleValue];
    return time;
}

-(void)setErrorTimer:(NSTimeInterval)errorTimer{
    NSString *timeString = [NSString stringWithFormat:@"%g",errorTimer];
    [[NSUserDefaults standardUserDefaults]setObject:timeString forKey:SET_ERRORTIME];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


-(void)setSelectedMenuId:(NSString *)selectedMenuId{

    [[NSUserDefaults standardUserDefaults]setValue:selectedMenuId forKey:SET_SELECTEDMENUID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)selectedMenuId{
    return [[NSUserDefaults standardUserDefaults] stringForKey:SET_SELECTEDMENUID];
}


-(void)setFileBaseUrl:(NSString *)fileBaseUrl{
    [[NSUserDefaults standardUserDefaults]setValue:fileBaseUrl forKey:SET_FILEBASEURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)fileBaseUrl{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SET_FILEBASEURL];
}

-(void)setPositionTimeInterval:(int)positionTimeInterval{
    [[NSUserDefaults standardUserDefaults]setInteger:positionTimeInterval forKey:SET_POSTIONTIMEINTERVAL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICaTION_UPDATATTIMEINTTERVAL object:nil];
}

-(int)positionTimeInterval{
    return (int)[[NSUserDefaults standardUserDefaults]integerForKey:SET_POSTIONTIMEINTERVAL];
    
}

-(NSString *)loginUserName{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SET_LOGINUSERNAME];
}

-(void)setLoginUserName:(NSString *)loginUserName{
    [[NSUserDefaults standardUserDefaults]setValue:loginUserName forKey:SET_LOGINUSERNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)password{
    return [[NSUserDefaults standardUserDefaults]stringForKey:SET_PASSWORD];
}

-(void)setPassword:(NSString *)password{
    [[NSUserDefaults standardUserDefaults]setValue:password forKey:SET_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - user



-(void)setUserId:(NSString *)userId{
    if (userId != nil) {
        [NSUserDefaults saveObject:userId forKey:SET_USERID];
    }
    
}

-(void)setUserName:(NSString *)userName{
    if (userName != nil) {
        [NSUserDefaults saveObject:userName forKey:SET_USERNAME];
    }
}

-(void)setSignImgUrl:(NSString *)signImgUrl{
    if (signImgUrl != nil) {
        [NSUserDefaults saveObject:signImgUrl forKey:SET_SIGNIMGURL];
    }
    
}

-(void)setJobId:(NSString *)jobId{
    if (jobId != nil) {
        [NSUserDefaults saveObject:jobId forKey:SET_JOBID];
    }
    
}

-(void)setUnitId:(NSString *)unitId{
    if (unitId != nil) {
        [NSUserDefaults saveObject:unitId forKey:SET_UNITID];
    }
    
}

-(void)setPayMent:(NSString *)payMent{
    if (payMent != nil) {
        [NSUserDefaults saveObject:payMent forKey:SET_PAYMENT];
    }
    
}

-(void)setSignName:(NSString *)signName{
    if (signName != nil) {
        [NSUserDefaults saveObject:signName forKey:SET_SIGNNAME];
    }
    
}

-(NSString *)userId{
    
    return [NSUserDefaults retrieveObjectForKey:SET_USERID];
}

-(NSString *)userName{
    
    return [NSUserDefaults retrieveObjectForKey:SET_USERNAME];
}

-(NSString *)signImgUrl{
    
    return [NSUserDefaults retrieveObjectForKey:SET_SIGNIMGURL];
}

-(NSString *)jobId{
    
    return [NSUserDefaults retrieveObjectForKey:SET_JOBID];
}
-(NSString *)unitId{
    
    return [NSUserDefaults retrieveObjectForKey:SET_UNITID];
}
-(NSString *)payMent{
    
    return [NSUserDefaults retrieveObjectForKey:SET_PAYMENT];
}
-(NSString *)signName{
    
    return [NSUserDefaults retrieveObjectForKey:SET_SIGNNAME];
}

-(void)removeobserver{
    [_regiterUser removeObserver:self forKeyPath:@"userId"];
    [_regiterUser removeObserver:self forKeyPath:@"userName"];
    [_regiterUser removeObserver:self forKeyPath:@"signImgUrl"];
    [_regiterUser removeObserver:self forKeyPath:@"jobId"];
    [_regiterUser removeObserver:self forKeyPath:@"unitId"];
    [_regiterUser removeObserver:self forKeyPath:@"payMent"];
    [_regiterUser removeObserver:self forKeyPath:@"signName"];
}

-(void)addObserver{
    [_regiterUser addObserver:self forKeyPath:@"userId" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [_regiterUser addObserver:self forKeyPath:@"userName" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [_regiterUser addObserver:self forKeyPath:@"signImgUrl" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [_regiterUser addObserver:self forKeyPath:@"jobId" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [_regiterUser addObserver:self forKeyPath:@"unitId" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [_regiterUser addObserver:self forKeyPath:@"payMent" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [_regiterUser addObserver:self forKeyPath:@"signName" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
}


-(void)setRegiterUser:(User *)bindUser{
//    if (_regiterUser) {
//        [self removeobserver];
//    }
    _regiterUser = bindUser;
//     [self addObserver];
    if (_regiterUser == nil) {
        [self setUserId:nil];
        [self setUserName:nil];
        [self setSignImgUrl:nil];
        [self setJobId:nil];
        [self setUnitId:nil];
        [self setPayMent:nil];
        [self setSignName:nil];
    }else{
        [self setUserId:_regiterUser.userId];
        [self setUserName:_regiterUser.userName];
        [self setSignImgUrl:_regiterUser.signImgUrl];
        [self setJobId:_regiterUser.jobId];
        [self setUnitId:_regiterUser.unitId];
        [self setPayMent:_regiterUser.payMent];
        [self setSignName:_regiterUser.signName];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATAUSERINFO object:nil];
}

-(User *)regiterUser{
    if (_regiterUser) {
        return _regiterUser;
    }
    NSString *userid = [self userId];
    if (!userid) {
        return nil;
    }
    _regiterUser = [[User alloc]init];
    _regiterUser.userId = userid;
    _regiterUser.userName = [self userName];
    _regiterUser.signImgUrl = [self signImgUrl];
    _regiterUser.jobId = [self jobId];
    _regiterUser.unitId = [self unitId];
    _regiterUser.payMent = [self payMent];
    _regiterUser.signName = [self signName];
    return _regiterUser;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _regiterUser) {
        if ([keyPath isEqual:@"userId"]) {
            [self setUserId:[change valueForKey:NSKeyValueChangeNewKey]];
        }else if ([keyPath isEqual:@"userName"]){
            [self setUserName:[change valueForKey:NSKeyValueChangeNewKey]];
        }else if ([keyPath isEqual:@"signImgUrl"]){
            [self setSignImgUrl:[change valueForKey:NSKeyValueChangeNewKey]];
        }else if ([keyPath isEqual:@"jobId"]){
            [self setJobId:[change valueForKey:NSKeyValueChangeNewKey]];
        }else if ([keyPath isEqual:@"unitId"]){
            [self setUnitId:[change valueForKey:NSKeyValueChangeNewKey]];
        }else if ([keyPath isEqual:@"payMent"]){
            [self setPayMent:[change valueForKey:NSKeyValueChangeNewKey]];
        }else if ([keyPath isEqual:@"signName"]){
            [self setSignName:[change valueForKey:NSKeyValueChangeNewKey]];
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if(object == self){
        if ([keyPath isEqual:@"regiterUser"]) {
            if (![change valueForKey:NSKeyValueChangeNewKey]) {
                if (_regiterUser) {
                    _regiterUser.userId = nil;
                    _regiterUser.userName = nil;
                    _regiterUser.signImgUrl = nil;
                    _regiterUser.jobId = nil;
                    _regiterUser.unitId = nil;
                    _regiterUser.payMent = nil;
                    _regiterUser.signName = nil;
                }
                _regiterUser = nil;
            }else{
                [self setUserId:_regiterUser.userId];
                [self setUserName:_regiterUser.userName];
                [self setSignImgUrl:_regiterUser.signImgUrl];
                [self setJobId:_regiterUser.jobId];
                [self setUnitId:_regiterUser.unitId];
                [self setPayMent:_regiterUser.payMent];
                [self setSignName:_regiterUser.signName];
            }
        }
    }
}








@end
