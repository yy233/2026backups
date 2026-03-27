//
//  ZYChatUserInfoCenterCell.h
//  Community
//
//  Created by ZY on 2021/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYChatUserInfoCenterCellDelegate <NSObject>

- (void)chatUserInfoCenterCollectionViewCellSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZYChatUserInfoCenterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *collectionContentView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic, weak) id<ZYChatUserInfoCenterCellDelegate> delegate;
- (void)fillDataWithModel:(ChatUserModel *)model;

@end

NS_ASSUME_NONNULL_END
