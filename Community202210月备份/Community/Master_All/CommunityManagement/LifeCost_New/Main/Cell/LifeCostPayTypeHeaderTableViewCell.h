//
//  LifeCostPayTypeHeaderTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LifeCostPayTypeHeaderTableViewCellCityChangeBtnBlock)(void);

@interface LifeCostPayTypeHeaderTableViewCell : UITableViewCell
@property (nonatomic,strong) UIButton *cityChangeBtn;
@property (nonatomic,strong) UIView *backV;
@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,copy) LifeCostPayTypeHeaderTableViewCellCityChangeBtnBlock headerCellCityChangeBtnBlock;
- (void)fillHeaderCellCityNameWithStr:(NSString *)cityName;
@end

NS_ASSUME_NONNULL_END
