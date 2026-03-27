//
//  EIntergralMallVcCollectionViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EIntergralMallVcCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIView *backV;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleL;
//
@property (nonatomic,strong) UILabel *eNumL;
@property (nonatomic,strong) UILabel *danWeiL;//E币
@property (nonatomic,strong) UIButton *immediatelyChangeBtn;//立即兑换
@end

NS_ASSUME_NONNULL_END
