//
//  User.h
//  cmm
//
//  Created by Hcat on 15/3/25.
//
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic,strong) NSString * userId;	//用户ID
@property(nonatomic,strong) NSString * userName;	//	名字
@property(nonatomic,strong) NSString * signImgUrl;	//	头像
@property(nonatomic,strong) NSString * jobId;	//	职位
@property(nonatomic,strong) NSString * unitId;	//	片区
@property(nonatomic,strong) NSString * payMent;	//	我的薪酬
@property(nonatomic,strong) NSString * signName;	//	个性签名


@end
