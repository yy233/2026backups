//
//  ZhengZuIssueHouseVc.h
//  Community
//
//  Created by 余莹 on 2021/1/19.
//。租赁编辑页

#import <UIKit/UIKit.h>
#import "HouseAllTypeBaseHeaderView.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    IssueHouse_Type_ZhengZu,//整租
    IssueHouse_Type_DanJian,//单间
    IssueHouse_Type_HeZu,//合租
    IssueHouse_Type_ShopBuniess,//商铺
} IssueHouse_Type;

@interface HouseAllTypeBaseIssueVc : BaseTableViewController_DW
@property (nonatomic,strong) HouseAllTypeBaseHeaderView *headerView;
@property (nonatomic,strong) NSMutableArray *dataSourceTitleArr;
@property (nonatomic,strong) NSMutableArray *dataSourceConnectArr;
@property (nonatomic,strong) NSMutableArray *photosAllUrlArr;
@property (nonatomic,strong) NSMutableArray *photosAllImgArr;
//
@property (nonatomic,assign) IssueHouse_Type type;

//修改状态下 用的ID
@property (nonatomic,assign) NSInteger editUseRentHouseId;
@property (nonatomic,assign) HouseRentDetailVcHouseModel *editUseModel;
@end

NS_ASSUME_NONNULL_END
