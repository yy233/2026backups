//
//  VoiceTopView.h
//  TUIVoiceRoom
//
//  Created by 余莹 on 2023/5/31.
//

#import <UIKit/UIKit.h>
#import "TRTCVoiceRoomDef.h"
#import "VoiceOcTool.h"
@class KJMarqueeLabel2;

NS_ASSUME_NONNULL_BEGIN

 @protocol VoiceTopViewDelegate <NSObject>

- (void)voiceTopViewDelegateWithTouchMember:(id)member;

@end


@interface VoiceTopView : UIView
//bk
@property (nonatomic,strong) UIView *leftBk;
@property (nonatomic,strong) UIView *rightBk;
@property (nonatomic,strong) UIView *gongGaoBk;
//
@property (nonatomic,strong) UICollectionView *collectionView;
//right
@property (nonatomic,strong) UIImageView *headerImgv;
//@property (nonatomic,strong) NSTimer *nameUserTimeer;
//@property (nonatomic,strong) UILabel *nickNameLabel_s;
@property (nonatomic,strong) KJMarqueeLabel2 *nickNameLabel;


@property (nonatomic,strong) UIImageView *reDuImgV;//热度
@property (nonatomic,strong) UILabel *reDuNumLabel;
@property (nonatomic,strong) UIButton *guanZhuRedBtn;
//left
@property (nonatomic,strong) UIView *memberBkView;
@property (nonatomic,strong) UIButton *closeBtn;
//gonggao
@property (nonatomic,strong) UIImageView *gonggaoImgv;
@property (nonatomic,strong) UILabel *gonggaoLabel;
//虚拟人数数据
@property (nonatomic,assign) NSInteger xuNiPersonSave;

//
#pragma mark ==
//房间名字
- (void)topViewSetInfoWithRoomName:(NSString *)roomName;
- (void)topViewSetInfoWithHeaderUrlStr:(NSString *)headerUrl;
- (void)topViewSetInfoWithRoomName:(NSString *)roomName withHeaderUrl:(NSString *)headerUrl;
- (void)topViewSetGongGaoInfoWithGongGaoStr:(NSString *)gongGao;
- (void)topViewSetListWithMemberListInfo:(NSMutableArray <VoiceRoomUserInfo *> *)memberList;
//- (void)topViewInfoWithZhuBoUserInfo:(VoiceRoomUserInfo *)zhuBoUserInfo withMyInfo:(VoiceRoomUserInfo *)myUserInfo;
- (void)topViewInfoIsZhuBoBool:(BOOL)isZhuBo;
- (void)topViewSetReDuNum:(int)reDuNum;
//- (void)topViewSetMainViewModel:(TRTCVoiceRoomViewModel *)vm;
#pragma mark == 刷新相关
- (void)reloadAudienceList;
- (void)reloadRoomInfoWithVoiceRoomInfo:(VoiceRoomInfo *)infoModel;
- (void)reloadRoomAvatar:(NSString*)currBkImgUrl;
- (void)reloadRoomXuNiPersonIndex:(int)showNum;
#pragma mark ==

@property (nonatomic,weak) id <VoiceTopViewDelegate> topViewDelegate;

@end


#pragma mark ==  VoiceTopRedEnvView 红包

#pragma mark ==  VoiceTopRedEnvView 主播发送红包。观众等待抢的红包信息

 
typedef void(^ShowGotRedInfoMsgBlock)(NSString *msgStr);
@protocol VoiceTopRedEnv_WaitGotView_Delegate <NSObject>
- (void)touchRedEnvAction;
@end

@interface VoiceTopRedEnv_WaitGotView : UIView
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *redEnv_imgV;
@property (nonatomic,strong) UIButton *redEnv_TopBtn;
@property (nonatomic,weak)  id <VoiceTopRedEnv_WaitGotView_Delegate> delegate;
//

@property (nonatomic,strong) NSDictionary *saveThisNewRedEnvOfData;
@property (nonatomic,strong) NSString *willUseGroupIdStr;
@property (nonatomic,strong) NSString *saveThisNewRedEnvOfDataUnoIDStr;
- (void)fillDataOfNewOneDataStr:(NSString *)message;
@property (nonatomic,strong) NSMutableArray *zhuBoSendRedEnvList_GotRedEnvSuccessUseListArr;
@property (nonatomic,copy) ShowGotRedInfoMsgBlock showGotRedInfoMsgBlock;



@end



#pragma mark ==  VoiceTopRedEnvView 主播得到观众的打赏红包
@interface VoiceTopRedEnvView_ZhuBoGotDaShangeAndShowTipView : UIView
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *headeView;
@property (nonatomic,strong) UILabel *moneyAndUnitL;
@property (nonatomic,strong) UILabel *subL;

- (void)fillDataOfNewOneDataStr:(NSString *)message;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
