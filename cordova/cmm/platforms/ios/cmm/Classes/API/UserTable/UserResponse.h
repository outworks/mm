//
//  UserResponse.h
//  cmm
//
//  Created by Hcat on 15/3/25.
//
//

#import "LK_HttpResponse.h"
#import "User.h"
#import "Menu.h"

@interface Configer : NSObject

@property(nonatomic,assign) int positionTimeInterval;

@property(nonatomic,strong) NSString *serverUrl;

@end

@interface UserResponse : NSObject

@property(nonatomic,strong)User *smUser;
@property(nonatomic,strong)NSArray *menu;
@property(nonatomic,strong)Configer *config;
@property(nonatomic,strong) NSArray *module;

@end
