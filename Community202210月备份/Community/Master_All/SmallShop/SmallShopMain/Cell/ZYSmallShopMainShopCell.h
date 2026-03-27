//
//  ZYSmallShopMainShopCell.h
//  Community
//
//  Created by ZY on 2022/2/28.
//

#import <UIKit/UIKit.h>

#define kZYSmallShopMainShopCollectionViewCell_H 125+(kScreenW-46)/2.0
#define kZYSmallShopMainShopCollectionViewCell_MaxH 145+(kScreenW-46)/2.0*kMaxAspectRatio

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopMainShopCellDelegate <NSObject>

- (void)collectionViewSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZYSmallShopMainShopCell : UITableViewCell

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak) id<ZYSmallShopMainShopCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
