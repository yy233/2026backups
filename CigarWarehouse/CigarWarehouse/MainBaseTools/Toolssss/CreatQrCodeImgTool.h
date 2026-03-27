//
//  CreatQrCodeImgTool.h
//  Community
//
//  Created by 余莹 on 2021/6/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CreatQrCodeImgTool : NSObject
+ (UIImage *)creatQrCodeImgWithOnlyStr:(NSString *)textStr; 
@end

NS_ASSUME_NONNULL_END
