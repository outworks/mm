//
//  HomeMenu.h
//  cmm
//
//  Created by ilikeido on 16/3/25.
//
//

#import <Foundation/Foundation.h>

//模式菜单
@interface HomeMenu : NSObject

@property(nonatomic,strong) NSString *menuUrl;
@property(nonatomic,strong) NSString *menuIcon;
@property(nonatomic,strong) NSString *menuName;
@property(nonatomic,strong) NSString *menuId;
@property(nonatomic,strong) NSString *parentId;

@end
