//
//  VoiceOcTool.h
//  TUIVoiceRoom
//
//  Created by 余莹 on 2023/5/31.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VoiceRoomLocalized.h"

//抢红包
#define Chat_Got_RedEnv_Notice                 @"Chat_Got_RedEnv_Notice"
#define Chat_Got_RedEnv_Notice_Result          @"Chat_Got_RedEnv_Notice_Result"
#define Chat_Got_RedEnv_Notice_Result_isFail   @"Chat_Got_RedEnv_Notice_Result_isFail"
#define Chat_Got_RedEnv_SaveUnoIdKey           @"Save_Got_RedEnv_Uno" //保存自己抢过的红包ID 用于cell展示时的类型处理

NS_ASSUME_NONNULL_BEGIN

@interface VoiceOcTool : NSObject
+ (UIImage *)getVoiceUseImgWithImgIconNameStr:(NSString *)iconName;

+ (UIImage *)getHeaderGrayColorImg;

+ (UIImage *)getVoiceUseImgWithNmaeStr:(NSString *)imgNameStr;

+ (NSString *)suoDuanAddressStr:(NSString *)addressStrOrDomainStr;
@end


#pragma mark === 其他工具

#pragma mark ===  滚动文本  KJMarqueeLabel2


typedef NS_ENUM(NSUInteger, KJMarqueeLabelType) {
    KJMarqueeLabelTypeLeft = 0,//向左边滚动
    KJMarqueeLabelTypeLeftRight = 1,//先向左边，再向右边滚动
};
@interface KJMarqueeLabel2 : UILabel <UIScrollViewDelegate>
@property(nonatomic,unsafe_unretained)KJMarqueeLabelType marqueeLabelType;
@property(nonatomic,unsafe_unretained)CGFloat speed;//速度
@property(nonatomic,unsafe_unretained)CGFloat secondLabelInterval;
@property(nonatomic,unsafe_unretained)NSTimeInterval stopTime;//滚到顶的停止时间

@end

NS_ASSUME_NONNULL_END
