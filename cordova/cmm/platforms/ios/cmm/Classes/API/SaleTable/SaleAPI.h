//
//  SaleAPI.h
//  cmm
//
//  Created by Hcat on 15/3/29.
//
//

#import <Foundation/Foundation.h>
#import "SaleRequest.h"
#import "SaleResponse.h"

@interface SaleAPI : NSObject

+(void)getSaleQueryHttpAPI:(SaleRequest *)request Success:(void (^)(SaleResponse *response,NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail;


@end
