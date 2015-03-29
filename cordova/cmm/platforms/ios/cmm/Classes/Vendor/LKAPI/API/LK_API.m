//
//  LK_API.m
//  ffcsdemo
//
//  Created by hesh on 13-9-12.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "LK_API.h"
#import "AFNetworking.h"
#import "UtilsMacro.h"
#import "JSONKit.h"
#import "LK_NSDictionary2Object.h"
#import "ServerConfig.h"

#define TIMEOUT_DEFAULT 30

@interface LK_APIUtil (p)
+(AFHTTPClient *)client;
@end

@implementation LK_APIUtil(p)

+(AFHTTPClient *)client{
    static dispatch_once_t onceToken;
    static AFHTTPClient *__client;
    dispatch_once(&onceToken, ^{
        __client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:BASE_SERVERLURL]];
    });
    return __client;
}

@end

@implementation LK_APIUtil

+(void)postHttpRequest:(LK_HttpBaseRequest *)request apiPath:(NSString *)path Success:(void (^)(NSObject *response,NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *))fail class:(Class)responseClass{
    if (!responseClass) {
        responseClass = [NSObject class];
    }
    NSDictionary *dict = request.lkDictionary;
    AFHTTPClient *client = LK_APIUtil.client;
    path = [NSString stringWithFormat:@"%@%@",BASE_SERVERLURL,path];
    [client postPath:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject){
            NSData *responseData = (NSData *)responseObject;
            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",responseString);
            NSDictionary *dict = [responseString objectFromJSONString];
            
            if (dict) {
                LK_HttpBaseResponse *response = [dict objectByClass:[LK_HttpBaseResponse class]];
                if ([dict objectForKey:@"data"]) {
                    NSDictionary *dict2 = [dict objectForKey:@"data"];
                    NSObject *result = [dict2 objectByClass:responseClass];
                    response.data = result;
                }
                sucess(response.data,response.result,response.msg);
            }else{
                fail(@"服务器异常");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error.localizedDescription);
    }];
}

+(void)getHttpRequest:(LK_HttpBaseRequest *)request apiPath:(NSString *)path Success:(void (^)(NSObject *response,NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *))fail class:(Class)responseClass{
    if (!responseClass) {
        responseClass = [NSObject class];
    }
    AFHTTPClient *client = LK_APIUtil.client;
    [client getPath:path parameters:request.lkDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject){
            NSData *responseData = (NSData *)responseObject;
            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",responseString);
            NSDictionary *dict = [responseString objectFromJSONString];
            if (dict) {
                NSObject *object = [dict objectByClass:responseClass];
                NSObject *responseData = [(LK_HttpBaseResponse *)object data];
                sucess(responseData,[(LK_HttpBaseResponse *)object result],[(LK_HttpBaseResponse *)object msg]);
            }else{
                fail(@"服务器异常");
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error.localizedDescription);
    }];
}

+(void)cancelAllHttpRequestByApiPath:(NSString *)path;{
    [LK_APIUtil.client cancelAllHTTPOperationsWithMethod:@"POST" path:path];
    [LK_APIUtil.client cancelAllHTTPOperationsWithMethod:@"GET" path:path];
}

+(void)postFileByRequest:(LK_MultipartHttpBaseRequest *)request apiPath:(NSString *)path ProgressBlock:(void(^)(NSInteger bytesWritten, long long totalBytesWritten))progressblock Success:(void (^)(NSObject *response,NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *))fail class:(Class)responseClass {
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:BASE_SERVERLURL]];
    NSMutableURLRequest *request1 = [client multipartFormRequestWithMethod:@"post" path:path parameters:request.lkDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (LK_FilePart *part in request.fileMedias) {
            [formData appendPartWithFileData:part.data name:part.name fileName:part.fileName mimeType:part.mimeType];
        }
    }];
    request1.timeoutInterval = 20;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        progressblock(bytesWritten,totalBytesWritten);
    }];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject){
            NSData *responseData = (NSData *)responseObject;
            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [responseString objectFromJSONString];
            if (dict) {
                NSObject *object = [dict objectByClass:responseClass];
                NSObject *responseData = [(LK_HttpBaseResponse *)object data];
                sucess(responseData,[(LK_HttpBaseResponse *)object result],[(LK_HttpBaseResponse *)object msg]);
            }else{
                sucess(responseString,0,nil);
            }
        }else{
            fail(@"上传失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error.localizedDescription);
    }];

}

@end
