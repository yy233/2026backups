//
//  DisCoverCreateLiveOrVoiceRoomVc.h
//  Socialize
//
//  Created by 余莹 on 2023/5/23.
//  直播创建页

#import <UIKit/UIKit.h>
#import "LiveUseCarmeraView.h" //实时摄像头获取view
NS_ASSUME_NONNULL_BEGIN

@interface ZhiBoBaseInfoInputAndCreateLiveOrVoiceTypeRoomChooseVc : Y_BaseViewController
@property (nonatomic,strong) UIImageView *centerBgZheXianView;
@property (nonatomic,strong) UIImageView *maxBgView;//弃用的视频类型背景
@property (nonatomic,strong) LiveUseCarmeraView *liveUseCarmeraView;//当前用的摄像头实时音像view
@property (nonatomic,assign) BOOL isLijiZhiBoCreatIng;//是否立即直播且正在创建

- (void)setNavBlackBk;
@end

NS_ASSUME_NONNULL_END
