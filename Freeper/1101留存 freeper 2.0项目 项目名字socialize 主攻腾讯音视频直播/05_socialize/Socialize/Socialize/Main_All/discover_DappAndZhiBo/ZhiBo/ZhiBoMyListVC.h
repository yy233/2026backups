//
//  ZhiBoMyListVC.h
//  Socialize
//
//  Created by 余莹 on 2023/7/1.
//  我的直播列表

#import "Y_BaseViewController.h"
#import "VoiceRoomChuanZhiModel.h"
#import "ZhiBoMyListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZhiBoMyListVC : Y_BaseViewController
- (void)creatVoiceRoomUseSwiftVcWithInfo:(VoiceRoomChuanZhiModel *)vChuanZhiModel;

//0928 直播分享到群 相关点击时用到的
//观众
- (void)aleatOk_LookerGotoZhiBoWithInfoMode:(ZhiBoShowInfoModel*)zhiBoInfoModel;
//去开直播
- (void)goToZhiBoVcWithCreatUserWithThisZhiBoInfoMode:(ZhiBoShowInfoModel*)zhiBoInfoModel;
@end

NS_ASSUME_NONNULL_END
