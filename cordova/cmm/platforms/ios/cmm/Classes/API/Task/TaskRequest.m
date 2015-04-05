//
//  TaskRequest.m
//  cmm
//
//  Created by ilikeido on 15-3-29.
//
//

#import "TaskRequest.h"
#import "ShareValue.h"

@implementation TaskRequest

-(id)init{
    self = [super init];
    if (self) {
        self.userId = [ShareValue sharedShareValue].regiterUser.userId;
    }
    return self;
}

@end

@implementation TaskDetailRequest

-(id)init{
    self = [super init];
    if (self) {
        self.userId = [ShareValue sharedShareValue].regiterUser.userId;
    }
    return self;
}

@end
