//
//  BaseChooseTableViewController.h
//  Community
//
//  Created by 余莹 on 2020/11/20.
//

#import <UIKit/UIKit.h>
#import "ChooseBaseHeaderViewOfSearchBar.h"
#import "ChooseBaseHeaderViewOfRightAndSearchBar.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseChooseTableViewController : BaseTableViewController
//@property (nonatomic,strong) UISearchBar *searchBar;//弃用
@property (nonatomic,strong) ChooseBaseHeaderViewOfSearchBar *headerView;
@property (nonatomic,strong) ChooseBaseHeaderViewOfRightAndSearchBar *communityHeaderView;//
//@property (nonatomic,strong) NSMutableArray *dataSourceArr;//父类有
@property (nonatomic,assign) NSInteger cityId;
@property (nonatomic,assign) NSInteger commnuityId;
@property (nonatomic,assign) NSInteger unitId;
@property (nonatomic,assign) NSInteger buildingId;
@property (nonatomic,assign) NSInteger floorId;
@property (nonatomic,assign) NSInteger addressId;
//以上的请求id（楼栋单元楼层ID）部分弃用   用字典baseParms
@property (nonatomic,strong) NSMutableDictionary *baseParms;//请求参数dic
- (void)headerSearchViewHiden:(BOOL)isHiden;
- (void)popUserCertificationVcWithName:(NSString *)nameStr And:(NSInteger)Id;
 
@end

NS_ASSUME_NONNULL_END
