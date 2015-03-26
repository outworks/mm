//
//  LK_API.h
//  ffcsdemo
//
//  Created by hesh on 13-9-12.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LK_HttpRequest.h"
#import "LK_HttpResponse.h"

@interface LK_APIUtil : NSObject

+(void)postHttpRequest:(LK_HttpBaseRequest *)request apiPath:(NSString *)path Success:(void (^)(NSObject *response,NSInteger result,NSString *msg))response fail:(void (^)(NSString *description))fail class:(Class)responseClass;

+(void)getHttpRequest:(LK_HttpBaseRequest *)request apiPath:(NSString *)path Success:(void (^)(NSObject *response,NSInteger result,NSString *msg))response fail:(void (^)(NSString *))fail class:(Class)responseClass;

+(void)cancelAllHttpRequestByApiPath:(NSString *)path;

@end
