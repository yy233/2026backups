//
//  LdleGoodDetailVC.h
//  Community
//
//  Created by 余莹 on 2022/6/11.
//

#import "BaseTableViewController.h"
#import "LdleGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LdleGoodDetailVC : BaseViewController

@property (nonatomic,strong) NSString *idStr;
 
@property (nonatomic,strong) LdleGoodsModel *yuLanInfoModel; //预览用到的数据

@end

NS_ASSUME_NONNULL_END
