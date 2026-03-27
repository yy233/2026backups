//
//  CityChooseTableViewController.h
//  Community
//
//  Created by 余莹 on 2020/11/19.
//

#import <UIKit/UIKit.h>
#import "BaseChooseTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface CityChooseTableViewController : BaseTableViewController
@property (nonatomic,strong) NSString *searchTextStr;
@property (nonatomic,strong) NSMutableArray *searchSourceArr;//搜索的城市
@property (nonatomic,strong) NSMutableArray *topSourceArr;//推荐城市
@property (nonatomic,strong) NSMutableArray *bottomListHeaderTitleSourceArr;//a b c..
@property (nonatomic,strong) NSMutableDictionary *bottomListSourceDic;
@end
NS_ASSUME_NONNULL_END
