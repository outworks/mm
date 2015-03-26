//
//  UserAPI.m
//  cmm
//
//  Created by Hcat on 15/3/25.
//
//

#import "UserAPI.h"
#import "LK_API.h"

@implementation UserAPI

+(void)getUserTableHttpAPI:(UserRequest *)request Success:(void (^)(UserResponse *response,NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail{

    if (HTTP_POSTMETHOD) {
        [LK_APIUtil postHttpRequest:request apiPath:URLPATH_GETUSER Success:^(NSObject *response,NSInteger result,NSString *msg){
            sucess((UserResponse *)response,result,msg);
        } fail:^(NSString * descript){
            fail(descript);
        }class:[UserResponse class]];
    }else{
        [LK_APIUtil getHttpRequest:request apiPath:URLPATH_GETUSER Success:^(NSObject *response,NSInteger result,NSString *msg){
            sucess((UserResponse *)response,result,msg);
        } fail:^(NSString * descript){
            fail(descript);
        }class:[UserResponse class]];
    }
    

}


@end
