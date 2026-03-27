//
//  MainTableViewCenterOneCell.h
//  Community
//
//  Created by 余莹 on 2020/11/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CenterMenuViewDelegate<NSObject>
- (void)centerMenuViewCollectionCellDidSelectWithItem:(NSIndexPath *)indexPath;
@end

@interface MainTableViewCenterMenuCell : UITableViewCell

@property (nonatomic,strong) NSMutableArray <MainCenterCollectionViewCellModel *> *sourceArr;
@property (nonatomic,strong) id <CenterMenuViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
