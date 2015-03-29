//
//  LK_HttpRequest.m
//  ffcsdemo
//
//  Created by hesh on 13-9-12.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "LK_HttpRequest.h"

@implementation LK_HttpBaseRequest

-(id)init{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

@end



@implementation LK_FilePart

-(id)initWithFileData:(NSData *)data
                 name:(NSString *)name
             fileName:(NSString *)fileName
             mimeType:(NSString *)mimeType{
    if (self = [super init]) {
        self.data = data;
        self.name = name;
        self.fileName = fileName;
        self.mimeType = mimeType;
    }
    return self;
}

@end

@interface LK_MultipartHttpBaseRequest ()



@end

@implementation LK_MultipartHttpBaseRequest

-(id)init{
    self = [super init];
    if (self) {
        self.fileMedias = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)appendPartWithFileData:(NSData *)data
                          name:(NSString *)name
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType{
    LK_FilePart *part = [[LK_FilePart alloc]initWithFileData:data name:name fileName:fileName mimeType:mimeType];
    [self.fileMedias addObject:part];
}

@end

@implementation LK_HttpBasePageRequest

-(id)init{
    self = [super init];
    if (self) {
    
        
    
    }
    return self;
}

@end

