//
//  VoiceMemberPopListView.h
//  TUIVoiceRoom
//
//  Created by 余莹 on 2023/5/31.
// 

#import <UIKit/UIKit.h>
#import "VoiceBasePopListView.h"
#import "VoiceOcTool.h"
 
static NSString * _Nonnull kVoiceMemberPopListViewCell_ShowOnLineCell_I = @"VoiceMemberPopListViewCell_ShowOnLineCell";
static NSString * _Nonnull kVoiceManagerPopListViewCell_GanZhongShangMaiCell_I = @"VoiceManagerPopListViewCell_showGanZhongShangDealMaiCell";
static NSString * _Nonnull kVoiceManagerPopListViewCell_SetManagerPersonCell_I = @"VoiceManagerPopListViewCell_SetManagerPersonCell";

static CGFloat Header_H_Title = 80;//75
static CGFloat Header_H_TitleAndSearchBar  = 120;//75+34
static CGFloat Header_H_TitleAndSearchBarAndTwoBtns  = 170;;//75+34+50
static CGFloat Footer_H_TwoBtns  = 90;//88


static int popView_Tag_setManagerPerson = 1001;
static int popView_Tag_oneLineOrAllPersion = 1002;
static int popView_Tag_managerShangMaiShengqing = 1003;

#pragma mark ==weak
#define pop_WEAKSELF     __weak typeof(self)      weakSelf = self;
#define pop_STRONGSELF   __strong typeof(self)    strongSelf = weakSelf;

NS_ASSUME_NONNULL_BEGIN

@interface VoiceMemberPopListView : VoiceBasePopListView

@end

//主播端_成员cell
@interface VoiceMemberPopListViewCell_ShowOnLineCell : UITableViewCell
@property (nonatomic,strong) UIImageView *heaImg;
@property (nonatomic,strong) UILabel *addressL;
@property (nonatomic,strong) UILabel *typeL;
@property (nonatomic,strong) UIButton *rightBtn;
- (void)changeLabelMasOnlyShwoAddress;
@end

//主播端_上麦管理cell 观众上麦申请 主播端同意拒绝cell
@interface VoiceManagerPopListViewCell_showGanZhongShangDealMaiCell : VoiceMemberPopListViewCell_ShowOnLineCell
@property (nonatomic,strong) UIButton *rightBtn_TongYi;
@property (nonatomic,strong) UIButton *rightBtn_JuJue;
@end




//主播端_设置管理者cell
@protocol VoiceManagerPopListViewCell_SetManagerPersonCellDelegate <NSObject>

- (void)touchSetManagerOrDeleManagerBool:(BOOL)isSetManagerPersonBool withUserId:(NSString *)userImID;

@end

@interface VoiceManagerPopListViewCell_SetManagerPersonCell : VoiceMemberPopListViewCell_ShowOnLineCell
@property (nonatomic,strong) id <VoiceManagerPopListViewCell_SetManagerPersonCellDelegate> managerPersonDelegate;
@end




//t_header
@interface HeaderTitleAndSearchView : UIView
@property (nonatomic,strong) UILabel *popViewListTopTitleL;
@property (nonatomic,strong) UISearchBar *popViewListTopSearchBar;
- (void)onlyShowTitleLabel;
@end

//t_header +btn2
@interface HeaderTypeChangeView : HeaderTitleAndSearchView
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@end

//zhubo_t_footer
@interface FooterJinYinView : UIView
@property (nonatomic,strong) UIButton *allJinYinBtn;
@property (nonatomic,strong) UIButton *allJieChuJinYinBtn;
@end

NS_ASSUME_NONNULL_END
