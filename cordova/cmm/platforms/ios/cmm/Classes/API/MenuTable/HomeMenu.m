//
//  HomeMenu.m
//  cmm
//
//  Created by ilikeido on 16/3/25.
//
//

#import "HomeMenu.h"

@implementation HomeMenu

-(NSString *)menuUrl{
    if (_menuUrl) {
        return [_menuUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return _menuUrl;
}

@end
