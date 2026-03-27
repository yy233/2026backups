//
//  ZYCommunityFairEditPhotoCell.h
//  Community
//
//  Created by ZY on 2021/8/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYCommunityFairEditPhotoCellDelegate <NSObject>

@optional

- (void)addPhotos;

- (void)imageViewTapWithIndex:(NSInteger)index;

- (void)deletePhotoWithIndex:(NSInteger)index;

@end

@interface ZYCommunityFairEditPhotoCell : UITableViewCell

@property (nonatomic, strong) NSArray *imagesArray;

@property (nonatomic, weak) id<ZYCommunityFairEditPhotoCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
