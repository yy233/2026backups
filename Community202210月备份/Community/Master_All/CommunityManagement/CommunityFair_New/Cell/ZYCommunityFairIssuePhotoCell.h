//
//  ZYCommunityFairIssuePhotoCell.h
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kZYCommunityFairIssuePhotoCollectionViewCell_W (kScreenW - 32 - 22) / 3.0
#define kZYCommunityFairIssuePhotoCollectionViewCell_H (kScreenW - 32 - 22) / 3.0

@protocol ZYCommunityFairIssuePhotoCellDelegate <NSObject>

@optional

- (void)addPhotos;

- (void)imageViewTapWithIndex:(NSInteger)index;

- (void)deletePhotoWithIndex:(NSInteger)index;

@end

@interface ZYCommunityFairIssuePhotoCell : UITableViewCell

@property (nonatomic, strong) NSArray *imagesArray;

@property (nonatomic, weak) id<ZYCommunityFairIssuePhotoCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
