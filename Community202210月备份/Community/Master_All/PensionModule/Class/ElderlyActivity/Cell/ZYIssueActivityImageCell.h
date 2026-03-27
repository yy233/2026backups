//
//  ZYIssueActivityImageCell.h
//  Community
//
//  Created by ZY on 2021/11/15.
//

#import <UIKit/UIKit.h>

#define kIssueActivityImageCell_W (kScreenW-32-22)/3.0
#define kIssueActivityImageCell_H (kScreenW-32-22)/3.0

NS_ASSUME_NONNULL_BEGIN

@protocol ZYIssueActivityImageCellDelegate <NSObject>

@optional

- (void)addPhotos;

- (void)imageViewTapWithIndex:(NSInteger)index;

- (void)deletePhotoWithIndex:(NSInteger)index;

@end

@interface ZYIssueActivityImageCell : UITableViewCell

@property (nonatomic, strong) NSArray *imagesArray;

@property (nonatomic, weak) id<ZYIssueActivityImageCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
