//
//  WeatherCityChooseVCTableViewController.h
//  Community
//
//  Created by 刘久炼 on 2021/2/25.
//

#import "BaseChooseTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface WeatherCityChooseVC : BaseViewControllerNotNoticeWithUI

@property (nonatomic,strong) NSString *searchTextStr;
@property (nonatomic,strong) NSMutableArray *searchSourceArr;//搜索的城市
@property (nonatomic,strong) NSMutableArray *topSourceArr;//推荐城市
@property (nonatomic,strong) NSMutableArray *bottomListHeaderTitleSourceArr;//a b c..
@property (nonatomic,strong) NSMutableDictionary *bottomListSourceDic;

@end

NS_ASSUME_NONNULL_END
