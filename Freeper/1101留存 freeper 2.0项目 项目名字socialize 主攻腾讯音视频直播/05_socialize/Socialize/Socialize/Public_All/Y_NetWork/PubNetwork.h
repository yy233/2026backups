//
//  PubNetwork.h
//  Socialize
//
//  Created by 余莹 on 2023/5/29.
//

#import <Foundation/Foundation.h>
#import "PubSendUpImgOkGetArrObjModel.h"
//module  icon:图标: 0, avatar:头像:1， life:生活照:2,  im:聊天:3, nft:NFT:4, feeback:反馈:5
#define Img_Module_Key             @"module"
#define Img_ModuleType_icon         @"icon"
#define Img_ModuleType_avatar       @"avatar"
#define Img_ModuleType_life         @"life"
#define Img_ModuleType_im           @"im"
#define Img_ModuleType_nft          @"nft"
#define Img_ModuleType_feeback      @"feeback"

NS_ASSUME_NONNULL_BEGIN

@interface PubNetwork : NSObject
+ (void)pub_sendImgWithOneImgObj:(UIImage *)willSendImg withBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)pub_sendImgWithOneImgObj:(UIImage *)willSendImg andParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block;

+ (void)pub_sendImgWithImgObjArr:(NSMutableArray *)arr withBlock:(BaseDicAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
