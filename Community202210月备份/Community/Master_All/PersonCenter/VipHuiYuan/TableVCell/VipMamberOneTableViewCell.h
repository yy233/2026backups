//
//  VipMamberOneTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import <UIKit/UIKit.h>
#import "VipMamberTableViewCellBaseDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface VipMamberOneTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *tipL;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,weak) id <VipMamberTableViewCellBaseDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
