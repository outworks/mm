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


@interface UserResponse : NSObject

@property(nonatomic,strong)User *smUser;
@property(nonatomic,strong)NSArray *menu;
@property(nonatomic,strong)NSDictionary *config;
@end
