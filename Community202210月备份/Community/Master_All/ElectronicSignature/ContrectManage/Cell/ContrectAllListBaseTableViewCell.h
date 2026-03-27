//
//  ContrectAllListBaseTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/28.
//

#import <UIKit/UIKit.h>
#import "ZYContrectAllListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContrectAllListBaseTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *timeL;
//
@property (nonatomic,strong) UIView *centerLabelsBackView;
@property (nonatomic,strong) UILabel *wqLabel;
@property (nonatomic,strong) UILabel *tqLabel;
@property (nonatomic,strong) UILabel *finishLabel;
@property (nonatomic,strong) UILabel *cancelLabel;
//
@property (nonatomic,strong) UIButton *faBtn;
@property (nonatomic,strong) UIButton *souBtn;
//
@property (nonatomic,strong) UIImageView *qianImgView;
//

@property (nonatomic, strong) ZYContrectAllListDataListModel *model;

- (void)cellTypeIsWaitingAll;
- (void)cellTypeIsWaitingMe;
- (void)cellTypeIsWaitingTa;
- (void)cellTypeIsWaitingFinish;
- (void)cellDataIsDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
