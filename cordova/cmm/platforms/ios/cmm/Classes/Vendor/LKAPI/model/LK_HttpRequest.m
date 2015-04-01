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


@implementation LK_HttpBasePageRequest

-(id)init{
    self = [super init];
    if (self) {
        _curPageNum = 1;
        _pageSize = 20;
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
        if(!name){
            self.name = @"file";
        }
        self.fileName = fileName;
        self.mimeType = mimeType;
    }
    return self;
}

-(id)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        if (image) {
            _name = @"file";
            _mimeType = @"image/jpg";
            if (UIImagePNGRepresentation(image) == nil)
            {
                self.data = UIImageJPEGRepresentation(image, 0.8);
                _fileName = [NSString stringWithFormat:@"%ld.jpg",(long)[[NSDate date ]timeIntervalSince1970]];
            }
            else
            {
                self.data = UIImagePNGRepresentation(image);
                _fileName = [NSString stringWithFormat:@"%ld.png",(long)[[NSDate date ]timeIntervalSince1970]];
                _mimeType = @"image/png";
            }
        }
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

- (void)appendImage:(UIImage *)image
               name:(NSString *)name{
    LK_FilePart *part = [[LK_FilePart alloc]initWithImage:image];
    if (name) {
        part.name = name;
    }
    [self.fileMedias addObject:part];
}

@end



