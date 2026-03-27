//
//  MainAllTypeInformationSubListVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/8/31.
//

#import <UIKit/UIKit.h>
#import "MainImInfoSubMsgModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MainAllTypeInformationSubListVcTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *contentL;

- (void)fillDataWithModel:(MainImInfoSubMsgModel *)model;
@end

NS_ASSUME_NONNULL_END
