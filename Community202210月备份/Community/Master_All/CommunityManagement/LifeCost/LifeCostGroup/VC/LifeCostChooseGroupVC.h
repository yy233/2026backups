//
//  LifeCostChooseGroupVC.h
//  Community
//
//  Created by 余莹 on 2021/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostChooseGroupVC : BaseTableViewController
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) NSMutableArray *isChooseTypeArr;
@property (nonatomic,strong) NSString *thisGroupNameStr;
@property (nonatomic,strong) NSDictionary *reDic;
@property (nonatomic,strong) NSMutableArray *keyArr;
- (void)initData;//已有的组数据

@end

NS_ASSUME_NONNULL_END
