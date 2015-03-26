//
//  Menu.h
//  cmm
//
//  Created by Hcat on 15/3/25.
//
//

#import <Foundation/Foundation.h>

@interface Menu : NSObject

@property(nonatomic,strong) NSString * menuId;	//	菜单ID
@property(nonatomic,strong) NSString * moduleType;	//	菜单类型
@property(nonatomic,strong) NSString * menuName;	//	菜单名称
@property(nonatomic,strong) NSString * ismenu;	//
@property(nonatomic,strong) NSString * level;	//	菜单级别
@property(nonatomic,strong) NSString * moduleTypeLabel ;	//
@property(nonatomic,strong) NSString * parentId;	//	父ID
@property(nonatomic,strong) NSString * status;	//	状态
@property(nonatomic,strong) NSString * menuIcon;	//	图标
@property(nonatomic,strong) NSString * isnavtive;	//	是否原生
@property(nonatomic,strong) NSString * iosurl;	//	IOS
@property(nonatomic,strong) NSString * androidurl;	//	android
@property(nonatomic,strong) NSString * filePath;	//	WEB插件下载地址
@property(nonatomic,strong) NSString * menuUrl;	//	第三方URL


@end
