//
//  ShareFun.m
//  PhoneSMS
//
//  Created by Hcat on 13-10-4.
//  Copyright (c) 2013年 Hcat. All rights reserved.
//

#import "ShareFun.h"
#import "ShareValue.h"


@implementation ShareFun

NSString *DEVELOP_URL;
BOOL isTongyi;

+(AppDelegate *) shareAppDelegate
{
	AppDelegate *t_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	return t_appDelegate;
}

+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize) size{
    
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+(UIImage *) getPathforImage:(NSString *)imageName withType:(NSString *)t_type{
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:t_type];
    UIImage *t_image = [UIImage imageWithContentsOfFile:path];
    
    return  t_image;
}

+(UIImage *) getPathforImage:(NSString *)imageName{
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    UIImage *t_image = [UIImage imageWithContentsOfFile:path];
    
    return  t_image;
}

+(NSURL *)fileUrlFormPath:(NSString *)path{
    NSString *realPath = [NSString stringWithFormat:@"%@%@",[ShareValue sharedShareValue].fileBaseUrl,path];
    return [NSURL URLWithString:realPath];
    
}

@end
