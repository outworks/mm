//
//  SaleAPI.m
//  cmm
//
//  Created by Hcat on 15/3/29.
//
//

#import "SaleAPI.h"
#import "LK_API.h"

@implementation SaleAPI

+(void)getSaleQueryHttpAPI:(SaleRequest *)request Success:(void (^)(SaleResponse *response,NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail{
    
    if (HTTP_POSTMETHOD) {
        [LK_APIUtil postHttpRequest:request apiPath:URLPATH_SALEQUERY Success:^(NSObject *response,NSInteger result,NSString *msg){
            NSArray *array = (NSArray *)response;
            if (array.count > 0) {
                sucess(array.firstObject,result,msg);
            }else{
                sucess(nil,result,msg);
            }
            
        } fail:^(NSString * descript){
            fail(descript);
        }class:[SaleResponse class]];
    }else{
        [LK_APIUtil getHttpRequest:request apiPath:URLPATH_SALEQUERY Success:^(NSObject *response,NSInteger result,NSString *msg){
            sucess((SaleResponse *)response,result,msg);
        } fail:^(NSString * descript){
            fail(descript);
        }class:[SaleResponse class]];
    }
}


@end
