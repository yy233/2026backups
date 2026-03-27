//
//  AccompanyMoreChooseTypeTableViewCell.h
//  Community
//  随行 多选状态cell
//  Created by 余莹 on 2020/12/10.
//

#import <UIKit/UIKit.h>
#import "AccompanyTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN
@protocol AccompanyMoreChooseTypeTableViewCellDelegate <NSObject>
- (void)cellIsMoreChooseTypeChooseBtnActionIsSelected:(BOOL)selected WithPersonModel:(GuestInfoModel *)model;
- (void)cellIsMoreChooseTypeChooseBtnActionIsSelected:(BOOL)selected WithCarModel:(CarInfoModel *)model;
@end
@interface AccompanyMoreChooseTypeTableViewCell : AccompanyTableViewCell
@property (nonatomic,strong) id <AccompanyMoreChooseTypeTableViewCellDelegate> moreChooseTypeCellDelegate;
@end

NS_ASSUME_NONNULL_END
