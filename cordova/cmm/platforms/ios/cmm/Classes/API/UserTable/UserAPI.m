//
//  UserAPI.m
//  cmm
//
//  Created by Hcat on 15/3/25.
//
//

#import "UserAPI.h"
#import "LK_API.h"
#import "ShareValue.h"

@implementation UserAPI

+(void)getUserTableHttpAPI:(UserRequest *)request Success:(void (^)(UserResponse *response,NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail{

    if (HTTP_POSTMETHOD) {
        [LK_APIUtil postHttpRequest:request apiPath:URLPATH_GETUSER Success:^(NSObject *response,NSInteger result,NSString *msg){
            UserResponse *userResponse = (UserResponse *)response;
            [ShareValue sharedShareValue].positionTimeInterval = userResponse.config.positionTimeInterval;
            [ShareValue sharedShareValue].module = userResponse.module;
            for (Menu *t_menu in userResponse.menu) {
                [t_menu save];
            }
            [ShareValue sharedShareValue].fileBaseUrl = userResponse.config.serverUrl;
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


+(void)updataSignNameHttpAPI:(UserSignRequest *)request Success:(void (^)(NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail{

    if (HTTP_POSTMETHOD) {
        [LK_APIUtil postHttpRequest:request apiPath:URLPATH_UPDATASIGNNAME Success:^(NSObject *response,NSInteger result,NSString *msg){
            sucess(result,msg);
        } fail:^(NSString * descript){
            fail(descript);
        }class:nil];
    }else{
        [LK_APIUtil getHttpRequest:request apiPath:URLPATH_UPDATASIGNNAME Success:^(NSObject *response,NSInteger result,NSString *msg){
            sucess(result,msg);
        } fail:^(NSString * descript){
            fail(descript);
        }class:nil];
    }
    
}

+(void) getMenuHttpAPIWithRequest:(void (^)(NSArray *result))sucess fail:(void (^)(NSString *description))fail{
    [LK_APIUtil postHttpRequest:nil apiPath:[NSString stringWithFormat:@"%@%@",URLPATH_MENUS,[ShareValue sharedShareValue].regiterUser.userId] Success:^(NSObject *response, NSInteger result, NSString *msg) {
        sucess((NSArray *)response);
    } fail:^(NSString *description) {
        fail(description);
    } class:([Menu class])];
}


@end
