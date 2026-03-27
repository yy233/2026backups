//
//  CreateLiveOrVoiceView.h
//  Socialize
//
//  Created by 余莹 on 2023/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CreateLiveOrVoiceViewDelegate <NSObject>

- (void)touchChooseFengMianPic;
- (void)touchChangePubOrPriType;
- (void)touchChooseVoiceType;
- (void)touchChooseLiveType;
- (void)touchKaiBoTime;
- (void)nowGoTokaiBo;

@end


@interface CreateLiveOrVoiceView : UIView
@property (nonatomic,strong) UIImageView *fengMianImgV;
@property (nonatomic,strong) UIButton *fengMainBtn;
@property (nonatomic,strong) UITextField *inputTitleTF;
@property (nonatomic,strong) UILabel *btnOfPubOrPirTitle;
@property (nonatomic,strong) UIButton *btnOfPubOrPir;

//音视频类型区域
@property (nonatomic,strong) UIView *bottomChooseRoomTypeBkView;
@property (nonatomic,strong) UILabel *bottomTitleL;
@property (nonatomic,strong) UIButton *typeOfLive;
@property (nonatomic,strong) UIButton *typeOfVoice;


//开播类型区域
@property (nonatomic,strong) UIView *kaiBoType_atOnceOrOnlyAddItemBkView;
@property (nonatomic,strong) UILabel *kaiBoType_atOnceOrOnlyAddItem_title;
@property (nonatomic,strong) UIButton *typeOfAtOnce;//立刻开播
@property (nonatomic,strong) UIButton *typeOfAddItem;//新增数据 延时开播


//开播时间选择区域
@property (nonatomic,strong) UIView *kaiBoBottomChooseTimeBkView;
@property (nonatomic,strong) UILabel *kaiBoTitleL;
@property (nonatomic,strong) UILabel *kaiBoTimeL;
@property (nonatomic,strong) UIImageView *kaiBoRightImgv;
@property (nonatomic,strong) UIButton *kaiBoTimeChooseTopBtn;
@property (nonatomic,strong) UIButton *nowKaiBoBtn;


@property (nonatomic,weak) id <CreateLiveOrVoiceViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
