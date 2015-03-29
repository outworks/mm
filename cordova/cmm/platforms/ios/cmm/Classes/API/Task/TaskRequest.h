//
//  TaskRequest.h
//  cmm
//
//  Created by ilikeido on 15-3-29.
//
//

#import <UIKit/UIKit.h>
#import "LK_HttpRequest.h"

@interface TaskRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *requestType;

@property(nonatomic,strong) NSString *userId;

@end
