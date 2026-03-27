//
//  PopViewWithChangeFamilyTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/11/26.
//

#import <UIKit/UIKit.h>
#import "ZYFamilyArchiveModel.h"

NS_ASSUME_NONNULL_BEGIN
 @interface PopViewWithChangeFamilyTableViewCell : UITableViewCell

@property (nonatomic,strong) UIButton *rightBtn;

- (void)fillDataWithModel:(ZYFamilyArchiveModel *)model;

@end

NS_ASSUME_NONNULL_END
