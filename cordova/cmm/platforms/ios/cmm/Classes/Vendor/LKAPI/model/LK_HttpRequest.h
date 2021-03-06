//
//  LK_HttpRequest.h
//  ffcsdemo
//
//  Created by hesh on 13-9-12.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerConfig.h"

@interface LK_HttpBaseRequest : NSObject

@end

@interface LK_HttpBasePageRequest : LK_HttpBaseRequest

@property(nonatomic,assign) int curPageNum;//当前页
@property(nonatomic,assign) int pageSize;//每页条数

@end




/**
 *  文件数据(data/fileName二选一)
 */
@interface LK_FilePart : NSObject

@property(nonatomic,strong) NSData *data;

@property(nonatomic,strong) NSString *name;

@property(nonatomic,strong) NSString *fileName;

@property(nonatomic,strong) NSString *mimeType;

-(id)initWithFileData:(NSData *)data
                 name:(NSString *)name
             fileName:(NSString *)fileName
             mimeType:(NSString *)mimeType;

-(id)initWithImage:(UIImage *)image;

@end

@interface LK_MultipartHttpBaseRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSMutableArray *fileMedias;

@property(nonatomic,strong) NSDictionary *heads;

- (void)appendPartWithFileData:(NSData *)data
                                 name:(NSString *)name
                             fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType;

- (void)appendImage:(UIImage *)image
                          name:(NSString *)name;

@end

