//
//  UserAPI.h
//  cmm
//
//  Created by Hcat on 15/3/25.
//
//

#import <Foundation/Foundation.h>
#import "UserRequest.h"
#import "UserResponse.h"

@interface UserAPI : NSObject

+(void)getUserTableHttpAPI:(UserRequest *)request Success:(void (^)(UserResponse *response,NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail;


@end
