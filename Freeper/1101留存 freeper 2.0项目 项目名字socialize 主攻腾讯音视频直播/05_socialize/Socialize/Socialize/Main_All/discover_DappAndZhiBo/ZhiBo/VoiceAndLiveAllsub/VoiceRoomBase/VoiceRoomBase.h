//
//  VoiceRoomBase.h
//  Socialize
//
//  Created by 余莹 on 2023/5/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VoiceRoomChuanZhiModel.h"

NS_ASSUME_NONNULL_BEGIN



typedef void(^VcBlock)(BOOL succes,UIViewController *vc);


@interface VoiceRoomBase : NSObject
singleton_interface(shareVoice); 
#pragma mark === 登录
- (void)voiceRoomLoginAction;
#pragma mark === 退出
- (void)VoiceRoomLogOutAction;

#pragma mark == 头像图片昵称
- (void)voiceSetNickName:(NSString *)userNik andUserHeaderImg:(NSString *)headerImgStr;
#pragma mark === 主播
- (void)creatVoiceRoomWithRootVc:(UIViewController *)rootVc withVoiceXiangGuanInfo:(VoiceRoomChuanZhiModel *)createVoiceRoominfo  withVcBlock:(VcBlock)vcBlock;
#pragma mark === 观众
- (void)enterVoiceRoomWithRootVc:(UIViewController *)rootVc withInfo:(VoiceRoomChuanZhiModel *)enterVoiceRoominfo withVcBlock:(VcBlock)vcBlock;
 




@end

NS_ASSUME_NONNULL_END
