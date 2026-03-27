//
//  ZYMessageTopCell.h
//  Community
//
//  Created by ZY on 2021/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYMessageTopCellDelegate <NSObject>

- (void)messageTopCollectionViewCellSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZYMessageTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic, weak) id<ZYMessageTopCellDelegate> delegate;

- (void)fillFriendsWithArr:(NSMutableArray *)arr;
@end

NS_ASSUME_NONNULL_END
