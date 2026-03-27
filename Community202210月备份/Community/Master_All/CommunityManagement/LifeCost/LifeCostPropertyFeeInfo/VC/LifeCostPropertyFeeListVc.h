//
//  LifeCostPropertyFeeListVc.h
//  Community
//
//  Created by 余莹 on 2021/7/6.
//

#import <UIKit/UIKit.h>


#import "LifeCostPropertyFeeListVcTopView.h"
#import "LifeCostPropertyFeeListVcBottomPayInfoView.h"
#import "LifeCostPropertyFeeInfoVcLate.h"

//
#import "LifeCostPropertyFeeListVcNomalBtnAndTitleTableViewCell.h"
#define  LifeCostPropertyFeeListVcNomalBtnAndTitleTableViewCell_Identifier          @"LifeCostPropertyFeeListVcNomalBtnAndTitleTableViewCell"
#import "LifeCostPropertyFeeListVcNomalWuYeTableViewCell.h"
#define  LifeCostPropertyFeeListVcNomalWuYeTableViewCell_Identifier          @"LifeCostPropertyFeeListVcNomalWuYeTableViewCell"

//
#import "LifeCostWuyeJiaofeiListModel.h"
#import "LifeCostWuyeModel.h"
//
#import "PopViewChooseLifeCostChoosePayType.h"

#define Btn_Tag_Section    (200)
#define Btn_Tag_Row        (1000)

NS_ASSUME_NONNULL_BEGIN

 
@interface LifeCostPropertyFeeListVc : BaseViewController

@property (nonatomic,strong) PopViewWithChangeCommunity *popViewWithChangeCommunity;//社区切换用到的popv
@property (nonatomic,strong) LifeCostPropertyFeeListVcTopView *topView;
@property (nonatomic,strong) LifeCostPropertyFeeListVcBottomPayInfoView *bottomView;
@property (nonatomic,assign) LifeCostPropertyFeeListVcTopView_Staus selfViewStaus;
@property (nonatomic,strong) CommunityModel *saveThisVcUseCommuityInfo;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
//
@property (nonatomic,strong) NSMutableArray *chooseSectionSaveArr;//section 0000初始化
//@property (nonatomic,strong) NSMutableArray *chooseRowSaveArr; //00 01  10 11 20 21 ...(首位为sectionnum 次位为是否选择状态) 弃用 本vc的子选择在model里加属性
@property (nonatomic,assign) BOOL allChooseType;
//
@property (nonatomic,strong) PopViewChooseLifeCostChoosePayType *PopViewPayTypeChoose;
@property (nonatomic,strong) NSMutableArray *popViewPayTypeChooseListTextArr;
@property (nonatomic,strong) NSMutableDictionary *parmsDicUseWillSendAdd;//支付成功后add接口所用数据
@property (nonatomic,assign) double payMoeyNumDouble;
@property (nonatomic,strong) NSMutableArray *payOrderIdArrs;
- (void)choosePayType;
@end

NS_ASSUME_NONNULL_END
 
