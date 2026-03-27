//
//  SmallShopMyBoxCollectionViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/10.
//

#import <UIKit/UIKit.h>
#import "SmallShopMyBoxModel.h"
NS_ASSUME_NONNULL_BEGIN

static NSString *SmallShopMyBoxCollectionViewCell_I = @"SmallShopMyBoxCollectionViewCell";

typedef void(^CellSubAddDayBtnBlock)(void);

@interface SmallShopMyBoxCollectionViewCell : UICollectionViewCell
@property (nonatomic,copy) CellSubAddDayBtnBlock cellSubAddDayBtnBlock;
- (void)fillDataWithBoxModel:(SmallShopMyBoxModel *)boxModel;


@end

NS_ASSUME_NONNULL_END
