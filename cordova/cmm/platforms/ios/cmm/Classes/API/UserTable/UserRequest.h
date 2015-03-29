//
//  UserRequest.h
//  cmm
//
//  Created by Hcat on 15/3/25.
//
//

#import "LK_HttpRequest.h"

@interface UserRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *username; 	//用户名
@property(nonatomic,strong) NSString *pass; 	//密码

@end

@interface UserSignRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString *userId; 	//用户名
@property(nonatomic,strong) NSString *signName; 	//密码

@end
