//
//  BankCardVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankCardVcTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *typeL;
@property (nonatomic,strong) UILabel *cardNumberL;
@property (nonatomic,strong) UILabel *lastNumL;
@end

NS_ASSUME_NONNULL_END
