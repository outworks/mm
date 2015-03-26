//
//  User.m
//  cmm
//
//  Created by Hcat on 15/3/25.
//
//

#import "User.h"
#import "NSUserDefaults+Helpers.h"


@implementation User

-(void)setUserId:(NSString *)userId{
    if (userId != nil) {
        [NSUserDefaults saveObject:userId forKey:@"userId"];
    }

}

-(void)setUserName:(NSString *)userName{
    if (userName != nil) {
        [NSUserDefaults saveObject:userName forKey:@"userName"];
    }
}

-(void)setSignImgUrl:(NSString *)signImgUrl{
    if (signImgUrl != nil) {
        [NSUserDefaults saveObject:signImgUrl forKey:@"signImgUrl"];
    }

}

-(void)setJobId:(NSString *)jobId{
    if (jobId != nil) {
        [NSUserDefaults saveObject:jobId forKey:@"jobId"];
    }

}

-(void)setUnitId:(NSString *)unitId{
    if (unitId != nil) {
        [NSUserDefaults saveObject:unitId forKey:@"unitId"];
    }

}

-(void)setPayMent:(NSString *)payMent{
    if (payMent != nil) {
        [NSUserDefaults saveObject:payMent forKey:@"payMent"];
    }

}

-(void)setSignName:(NSString *)signName{
    if (signName != nil) {
        [NSUserDefaults saveObject:signName forKey:@"signName"];
    }

}

-(NSString *)userId{
    
    return [NSUserDefaults retrieveObjectForKey:@"userId"];
}

-(NSString *)userName{
    
    return [NSUserDefaults retrieveObjectForKey:@"userName"];
}

-(NSString *)signImgUrl{
    
    return [NSUserDefaults retrieveObjectForKey:@"signImgUrl"];
}

-(NSString *)jobId{
    
    return [NSUserDefaults retrieveObjectForKey:@"jobId"];
}
-(NSString *)unitId{
    
    return [NSUserDefaults retrieveObjectForKey:@"unitId"];
}
-(NSString *)payMent{
    
    return [NSUserDefaults retrieveObjectForKey:@"payMent"];
}
-(NSString *)signName{
    
    return [NSUserDefaults retrieveObjectForKey:@"signName"];
}




@end
