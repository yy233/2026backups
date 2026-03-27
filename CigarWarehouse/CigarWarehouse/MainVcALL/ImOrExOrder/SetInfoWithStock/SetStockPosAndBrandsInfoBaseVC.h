//
//  SetStockPosAndBrandsInfo.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/18.
//

#import <UIKit/UIKit.h>
#import "ListBaseViewController.h"
#import "PosAndBrandInfoAddTools.h"
#import "ImExOrderOtherTool.h"
NS_ASSUME_NONNULL_BEGIN

@interface SetStockPosAndBrandsInfoBaseVC : ListBaseViewController
@property (nonatomic,assign) ImorExOrder_SubType type;
@end

NS_ASSUME_NONNULL_END
