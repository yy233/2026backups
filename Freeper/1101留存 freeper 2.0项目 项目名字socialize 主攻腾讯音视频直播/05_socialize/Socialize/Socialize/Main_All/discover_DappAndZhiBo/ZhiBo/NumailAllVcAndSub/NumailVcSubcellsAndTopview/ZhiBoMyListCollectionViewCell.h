//
//  ZhiBoMyListCollectionViewCell.h
//  Socialize
//
//  Created by 余莹 on 2023/7/3.
//

#import <UIKit/UIKit.h>

#import "OYCountDownManager.h"
#define MyZhiBoListNotificationTimeCell  @"MyZhiBoListNotificationTimeCell"

NS_ASSUME_NONNULL_BEGIN

@interface ZhiBoMyListCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIView *backViewMain;
@property (nonatomic,strong)UIView *backViewTop;
@property (nonatomic,strong)UIView *backViewBottom;
//
@property (nonatomic,strong)UIImageView *bkimgView;
@property (nonatomic,strong)UILabel *zhuBoUserNameLabel;
@property (nonatomic,strong)UIView *titleBkV;
@property (nonatomic,strong)UILabel *titleLabel;
//
@property (nonatomic,strong)UIButton *pubOrPivTypeBtn;
@property (nonatomic,strong)UIButton *zhiBoTypeBtn;
@property (nonatomic,strong)UIButton *statueTypeBtn;
@property (nonatomic,strong)UILabel *kaiBoJuLiTimeTitleLabel;
@property (nonatomic,strong)UILabel *kaiBoJuLiTimeLabel;


- (void)upDataTimeInfoWithNowUseDaoJiShiHMSTimeIv:(NSString *)cellUseTimeIv;
#pragma mark === 倒计时
////作用是只是刷新显示在屏幕上的时间
//@property(nonatomic,assign)BOOL isDisplay;
//- (void)initTimeInfoWithModelStartDatetime:(NSString *)startDatetime;
//- (void)upDataTimeInfoWithSecondIv:(NSInteger)SecondIv;




@end

NS_ASSUME_NONNULL_END
