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
#import "ShareValue.h"
#import <objc/runtime.h>

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
                    if([[dict objectForKey:@"data"] isKindOfClass:[NSArray class]]){
                        NSMutableArray *array = [NSMutableArray array];
                        NSArray *data = [dict objectForKey:@"data"];
                        for (NSDictionary *dict1 in data) {
                            NSObject *result = [dict1 objectByClass:responseClass];
                            [array addObject:result];
                        }
                        response.data = array;
                    }else if([[dict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dict2 = [dict objectForKey:@"data"];
                        NSObject *result = [dict2 objectByClass:responseClass];
                        response.data = result;
                    }
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

+(void)postHttpPageRequest:(LK_HttpBasePageRequest *)request apiPath:(NSString *)path Success:(void (^)(LK_HttpBasePageResponse *response,NSInteger result,NSString *msg))success fail:(void (^)(NSString *description))fail class:(Class)resultClass{
    if (!resultClass) {
        resultClass = [NSObject class];
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
                LK_HttpBasePageResponse *response1 = [dict objectByClass:[LK_HttpBasePageResponse class]];
                if (response1) {
                    NSArray *result  = response1.data.result;
                    NSMutableArray *array = [[NSMutableArray alloc]init];
                    for (NSDictionary *dict in result) {
                        NSObject *classResult = [dict objectByClass:resultClass];
                        [array addObject:classResult];
                    }
                    response1.data.result = array;
                }
                success(response1,response1.result,response1.msg);
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
                LK_HttpBaseResponse *response = [dict objectByClass:[LK_HttpBaseResponse class]];
                if ([dict objectForKey:@"data"]) {
                    if([[dict objectForKey:@"data"] isKindOfClass:[NSArray class]]){
                        NSMutableArray *array = [NSMutableArray array];
                        NSArray *data = [dict objectForKey:@"data"];
                        for (NSDictionary *dict1 in data) {
                            NSObject *result = [dict1 objectByClass:responseClass];
                            [array addObject:result];
                        }
                        response.data = array;
                    }else if([[dict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dict2 = [dict objectForKey:@"data"];
                        NSObject *result = [dict2 objectByClass:responseClass];
                        response.data = result;
                    }
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

+(void)cancelAllHttpRequestByApiPath:(NSString *)path;{
    [LK_APIUtil.client cancelAllHTTPOperationsWithMethod:@"POST" path:path];
    [LK_APIUtil.client cancelAllHTTPOperationsWithMethod:@"GET" path:path];
}

+(void)postFileByRequest:(LK_MultipartHttpBaseRequest *)request apiPath:(NSString *)path ProgressBlock:(void(^)(NSInteger bytesWritten, long long totalBytesWritten))progressblock Success:(void (^)(NSObject *response,NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *))fail class:(Class)responseClass {
    NSArray *files = request.fileMedias;
    request.fileMedias = nil;
    NSDictionary *dict = request.lkDictionary;
    NSLog(@"%@",dict);
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_SERVERLURL,path]]];//@"http://test.yuntu.devstudio.cn:8080/yuntu/photo/uploadImage.do"]];//BASE_SERVERLURL]];
    NSMutableURLRequest *request1 = [client multipartFormRequestWithMethod:@"post" path:nil parameters:request.lkDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (LK_FilePart *part in files) {
            [formData appendPartWithFileData:part.data name:part.name fileName:part.fileName mimeType:part.mimeType];
        }
    }];
    if (request.heads) {
        for (NSString *key in request.heads.allKeys) {
            [request1 setValue:[request.heads objectForKey:key]  forHTTPHeaderField:key];
        }
    }
    request1.timeoutInterval = 40;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if (progressblock) {
            progressblock(bytesWritten,totalBytesWritten);
        }
        
    }];
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
    [operation start];
}

+(void)postFileByImage:(UIImage *)image progressBlock:(void(^)(NSInteger bytesWritten, long long totalBytesWritten))progressblock Success:(void (^)(NSString *fileUrl))sucess fail:(void (^)(NSString *))fail;{
    LK_FilePart *part = [[LK_FilePart alloc]initWithImage:image];
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:BASE_UPLOADSERVERL]];
    NSMutableURLRequest *request1 = [client multipartFormRequestWithMethod:@"post" path:[NSString stringWithFormat:@"%@%@",URLPATH_FILEUPLOAD,[ShareValue sharedShareValue].regiterUser.userId] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:part.data name:part.name fileName:part.fileName mimeType:part.mimeType];
    }];
    request1.timeoutInterval = 40;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
    long long fileLength= part.data.length;
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if (progressblock) {
            progressblock(totalBytesWritten,fileLength);
        }
    }];
    [operation start];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject){
            NSData *responseData = (NSData *)responseObject;
            NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [responseString objectFromJSONString];
            if (dict) {
                LK_HttpBaseResponse *object = [dict objectByClass:[LK_HttpBaseResponse class]];
                sucess((NSString *)object.data);
            }else{
                fail(@"服务器返回失败");
            }
        }else{
            fail(@"上传失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(error.localizedDescription);
    }];
    
}

@end
