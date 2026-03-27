//
//  IssueChooseShopQuYuVc.h
//  Community
//
//  Created by 余莹 on 2021/2/26.
//  商铺区域列表vc
//  商铺地址列表== 数据是 ==上级别的区域名下小区列表 

#import <UIKit/UIKit.h>
#import "IssueChooseCommunityBaseVc.h"
NS_ASSUME_NONNULL_BEGIN

@interface IssueChooseShopQuYuVc : IssueChooseCommunityBaseVc
@property (nonatomic,assign) NSInteger getQuYuWithUseCityId;
@property (nonatomic,strong) NSMutableArray *shopBuniessQuYuArr;
@property (nonatomic,strong) BaseListArrBlock listBlock;
@end

NS_ASSUME_NONNULL_END
