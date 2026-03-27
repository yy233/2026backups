//
//  MainTableViewTopMenuCell.h
//  Community
//
//  Created by 余莹 on 2021/7/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MainTableViewTopMenuCellDelegate<NSObject>
- (void)topMenuViewCollectionCellDidSelectWithItem:(NSIndexPath *)indexPath;
@end

@interface MainTableViewTopMenuCell : UITableViewCell

@property (nonatomic,strong) NSMutableArray <MainCenterCollectionViewCellModel *> *sourceArr;
@property (nonatomic,strong) id <MainTableViewTopMenuCellDelegate> delegate;
@end
NS_ASSUME_NONNULL_END
