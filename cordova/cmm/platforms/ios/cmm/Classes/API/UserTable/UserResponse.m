//
//  UserResponse.m
//  cmm
//
//  Created by Hcat on 15/3/25.
//
//

#import "UserResponse.h"
#import "HomeMenu.h"

@implementation Configer

@end

@implementation UserResponse

+(Class)__menuClass{
    return [Menu class];
}

+(Class)__moduleClass{
    return [HomeMenu class];
}

@end
