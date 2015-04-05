//
//  Task.m
//  cmm
//
//  Created by ilikeido on 15-3-29.
//
//

#import "Task.h"
#import "Unit.h"

@implementation Task

-(NSString *)stateString{
    if ([@"1" isEqual:_state]) {
        return @"未启动";
    }
    if ([@"2" isEqual:_state]) {
        return @"进行中";
    }
    if ([@"3" isEqual:_state]) {
        return @"已完成";
    }
    if ([@"4" isEqual:_state]) {
        return @"超期完成";
    }
    if ([@"5" isEqual:_state]) {
        return @"中止";
    }
    return nil;
}

+(Class)__unitClass{
    return [Unit class];
}

@end
