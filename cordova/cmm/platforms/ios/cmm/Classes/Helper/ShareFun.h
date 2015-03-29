//
//  ShareFun.h
//  PhoneSMS
//
//  Created by Hcat on 13-10-4.
//  Copyright (c) 2013年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface ShareFun : NSObject



//描述：取得系统AppDelegate
+ (AppDelegate *) shareAppDelegate;

//描述：图片自适应UIView尺寸
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

//描述：根据文件名取得图片
+(UIImage *) getPathforImage:(NSString *)imageName;

+(UIImage *) getPathforImage:(NSString *)imageName withType:(NSString *)t_type;

+(NSURL *)urlFormPath:(NSString *)path;

@end
