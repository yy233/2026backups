//
//  BaseElectronicSignatureVC.h
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import <UIKit/UIKit.h>
#import "ElectronicSignatureHeaderSearchView.h"
#import "ElectronicNewsListVc.h"
#import "ZYElectronicRealNameAuthenticationVc.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseElectronicSignatureVC : ZYBaseViewController
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ElectronicSignatureHeaderSearchView *headerView;
@end

NS_ASSUME_NONNULL_END
