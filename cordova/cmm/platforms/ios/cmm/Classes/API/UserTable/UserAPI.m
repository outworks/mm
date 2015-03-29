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


+(void)updataSignNameHttpAPI:(UserSignRequest *)request Success:(void (^)(NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail{

//    if (HTTP_POSTMETHOD) {
//        [LK_APIUtil postHttpRequest:request apiPath:URLPATH_UPDATASIGNNAME Success:^(NSObject *response,NSInteger result,NSString *msg){
//            sucess(result,msg);
//        } fail:^(NSString * descript){
//            fail(descript);
//        }class:nil];
//    }else{
//        [LK_APIUtil getHttpRequest:request apiPath:URLPATH_UPDATASIGNNAME Success:^(NSObject *response,NSInteger result,NSString *msg){
//            sucess(result,msg);
//        } fail:^(NSString * descript){
//            fail(descript);
//        }class:nil];
//    }
    LK_FilePart *part =  [request.fileMedias firstObject];
    request.heads = [NSDictionary dictionaryWithObjectsAndKeys:@"66edc3bd7124598528875bc361de0621b10efab843cd46a17cb4345d007680f1",@"ckhd", @"297e9e794b05519c014b0555beb00001",@"uuid",[NSString stringWithFormat:@"%ld",part.data.length],@"imageSize",nil];
    [LK_APIUtil postFileByRequest:request apiPath:URLPATH_UPDATASIGNNAME  ProgressBlock:nil Success:^(NSObject *response, NSInteger result, NSString *msg) {
        sucess(result,msg);
    } fail:^(NSString *failDescription) {
        fail(failDescription);
    } class:[NSObject class]];
}

@end
