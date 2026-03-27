//
//  MainTableViewShoppingCell.h
//  Community
//
//  Created by 余莹 on 2020/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ShoppingViewDelegate<NSObject>
- (void)shoppingViewCollectionCellDidSelectWithItem:(NSIndexPath *)indexPath;
- (void)shoppingViewCollectionCellDidSelectWithScrollViewItem:(NSInteger)index;

@end

@interface MainTableViewShoppingCell : UITableViewCell
@property (nonatomic,strong) NSMutableArray <MainCenterCollectionViewShoppingCellModel *> *sourceArr;
@property (nonatomic,strong) NSMutableArray <TableViewTopAndCenterBannerCellModel *>*scrollViewSourceArr;
@property (nonatomic,strong) id <ShoppingViewDelegate> delegate;
@end
NS_ASSUME_NONNULL_END
