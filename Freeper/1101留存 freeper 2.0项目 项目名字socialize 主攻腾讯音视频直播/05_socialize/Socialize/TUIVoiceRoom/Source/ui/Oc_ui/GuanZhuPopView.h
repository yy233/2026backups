//
//  GuanZhuPopView.h
//  TUIVoiceRoom
//
//  Created by 余莹 on 2023/6/13.
//

#import <UIKit/UIKit.h>
#import "VoiceBasePopView.h"
#import "VoiceOcFileUse_Header.h"
NS_ASSUME_NONNULL_BEGIN


@protocol GuanZhuPopViewDelegate <NSObject>

- (void)touchRightTopJuBaoBtnAction;
//
- (void)touchAtMe;
- (void)touchSiXin;
- (void)touchGuanZhu;

@end



@interface GuanZhuPopView : VoiceBasePopView

@property (nonatomic,strong) UIView *guanzhuAllSubViewMainBkView;
//
//@property (nonatomic,strong) UIImageView*topBkImgV;
@property (nonatomic,strong) UIView *bottomBkView;
@property (nonatomic,strong) UILabel *idLable;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UIButton *rightTopJuBaoBtn;//举报
//
@property (nonatomic,strong) UILabel *nickNameL;
@property (nonatomic,strong) UIView *baseInfoBkView;
@property (nonatomic,strong) UITextView *infoTextView;//简介

//bottom
@property (nonatomic,strong) UIButton *callATMeBtn;
@property (nonatomic,strong) UIButton *siXinBtn;
@property (nonatomic,strong) UIButton *guanZhuBtn;

@property (nonatomic,weak) id <GuanZhuPopViewDelegate> guanZhuPopViewDelegate;
- (void)setGuanZhuUserInfoWithName:(NSString *)nameStr withHeadImg:(NSString *)headerImgStr  withUserID:(NSString *)userIdStr withIntordace:(NSString *)intordaceStr withTherInfos:(id)otherInfo;
@end

NS_ASSUME_NONNULL_END
