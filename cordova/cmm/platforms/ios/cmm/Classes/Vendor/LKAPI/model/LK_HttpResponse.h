//
//  LK_Response.h
//  ffcsdemo
//
//  Created by hesh on 13-9-12.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LK_HttpBaseResponse : NSObject
@property(nonatomic,strong) NSObject *data;
@property(nonatomic,assign) NSInteger result;
@property(nonatomic,strong) NSString *msg;
@end

@interface LK_BasePageRespson : NSObject



@end

@interface LK_HttpBasePageResponse : LK_HttpBaseResponse

@property(nonatomic,strong) LK_BasePageRespson *page;

@end




