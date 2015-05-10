//
//  VersionUpdataAPI.h
//  cmm
//
//  Created by Hcat on 15/5/11.
//
//

#import <Foundation/Foundation.h>
#import "LK_HttpResponse.h"
#import "LK_HttpRequest.h"

@interface VersionUpdataRequest : LK_HttpBaseRequest

@property(nonatomic,strong) NSString * userId; //	用户名	String	非空	50
@property(nonatomic,strong) NSString * clientType; //	平台类型	String	非空		android、ios

@end

@interface VersionUpdataResponse : NSObject

@property(nonatomic,strong) NSString * filePath; //	文件地址	String
@property(nonatomic,strong) NSString * nversion; //	最新版本号	String
@property(nonatomic,strong) NSString * sversion; //	强制更新的版本号	String


@end


@interface VersionUpdataAPI : NSObject

+(void)versionUpdataHttpAPI:(VersionUpdataRequest *)request Success:(void (^)(VersionUpdataResponse *response,NSInteger result,NSString *msg))sucess fail:(void (^)(NSString *description))fail;


@end
