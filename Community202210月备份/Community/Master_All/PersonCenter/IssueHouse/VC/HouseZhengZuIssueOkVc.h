//
//  HouseZhengZuIssueOkVc.h
//  Community
//
//  Created by 余莹 on 2021/1/22.
//  租赁编辑页——整租类型 提交页

#import <UIKit/UIKit.h>
#import "IssueHouseOkSendInfoViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseZhengZuIssueOkVc : BaseTableViewController_DW
//子类需要的
//蓝色圆view的数据arr
@property (nonatomic,strong) NSMutableArray *sectionBluesSubBtnCellTitleArr;
@property (nonatomic,strong) NSMutableArray *sectionBluesSubBtnCellOneContentArr;
@property (nonatomic,strong) NSMutableArray *sectionBluesSubBtnCellTwoContentArr;
@property (nonatomic,strong) NSMutableArray *sectionBluesSubBtnCellThrContentArr;
@property (nonatomic,strong) NSMutableArray *sectionBluesSubBtnCellFourContentArr;
@property (nonatomic,strong) NSMutableArray *sectionBluesSubBtnCellFiveContentArr;
//子model cell各自的已经选择的model
@property (nonatomic,strong) PopViewBuniessShopAndHouseChoosePayWayModel *payWayModel;//押赴方式
@property (nonatomic,strong) IssueHouseConstModel *houseTypeModel;//房屋类型
@property (nonatomic,strong) NSMutableArray *saveChooseCodeArrOfZhuangXiug;//model arr 存储 _装修情况
@property (nonatomic,strong) NSMutableArray *saveChooseCodeArrOfHouseSheShi;//model arr 存储 _房间设施
@property (nonatomic,strong) NSMutableArray *saveChooseCodeArrOfHouseLiangDian;//model arr 存储 _房间亮点
@property (nonatomic,strong) NSMutableArray *saveChooseCodeArrOfYaoQiu;//model arr 存储 _出租要求
//index (用于滑动后 选择状态消失的记录)
@property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfZhuangXiug;//  arr 存储 _装修情况
@property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfHouseSheShi;//  arr 存储 _房间设施
@property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfHouseLiangDian;//  arr 存储 _房间亮点
@property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfYaoQiu;//  arr 存储 _出租要求
//________子类所需要
//公共设施
@property (nonatomic,strong) NSMutableArray *saveChooseCodeArrOfGongGongSheShi;//model code arr
@property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfGongGongSheShi;//index
//房屋设施
@property (nonatomic,strong) NSMutableArray *saveChooseCodeArrOfFangWuSheShi;//model code arr
@property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfFangWuSheShi;//index
//室友期望
@property (nonatomic,strong) NSMutableArray *saveChooseCodeArrOfQiWang;//model code arr
@property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfQiWang;//index
//性别
@property (nonatomic,strong) NSMutableArray *saveChooseCodeArrOfGender;//model code arr
@property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfGender;//index
//日期
@property (nonatomic,strong) NSMutableArray *saveChooseCodeArrOfRentdayType;// model  arr 存储 日期 单选
@property (nonatomic,strong) NSMutableArray *saveChooseIndexArrOfRentdayType;//  arr 存储 日期 单选

//前页需要的
@property (nonatomic,assign) IssueHouse_Type type;
@property (nonatomic,strong) IssueHouseAddNewModel *houseAllDataModel;//上传数据所用的model键值处理
//
- (void)popTwoVC;
@end

NS_ASSUME_NONNULL_END
