//
//  Menu.m
//  cmm
//
//  Created by Hcat on 15/3/25.
//
//

#import "Menu.h"


@implementation Menu

-(void)save{
    [Menu deleteWithWhere:[NSString stringWithFormat:@"menuId=%@",_menuId]];
    [self saveToDB];
}

@end
