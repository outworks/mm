//
//  HCatImageUpadataVC.h
//  cmm
//
//  Created by Hcat on 15/4/7.
//
//

#import <UIKit/UIKit.h>

@interface HCatImageUpadataVC : UIViewController

@property(nonatomic,strong)NSString *temporary_taskid;
@property(nonatomic,strong)NSString *temporary_unitid;


@end

@interface ImageFileInfo : NSObject
@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *fileName;
@property(nonatomic,strong) NSString *mimeType;
@property(nonatomic,assign) long long filesize;
@property(nonatomic,strong) NSData *fileData;

-(id)initWithImage:(UIImage *)image;

@end