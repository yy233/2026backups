//
//  ZYXianjingJuanCell.h
//  Community
//
//  Created by ZY on 2021/6/8.
//

#import <UIKit/UIKit.h>
#import "ZYXianjingJuanListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYXianjingJuanCell : BaseTableViewCell

@property (nonatomic,strong) UIButton *bottomBtn;

@property (nonatomic, strong) ZYXianjingJuanListDataRecordsModel *model;

@end

NS_ASSUME_NONNULL_END
