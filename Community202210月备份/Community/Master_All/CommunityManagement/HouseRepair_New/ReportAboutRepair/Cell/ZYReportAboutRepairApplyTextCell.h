//
//  ZYReportAboutRepairApplyTextCell.h
//  Community
//
//  Created by ZY on 2022/3/7.
//

#import <UIKit/UIKit.h>

#define kZYReportAboutRepairApplyTextCollectionViewCell_W (kScreenW-83)/4.0
#define kZYReportAboutRepairApplyTextCollectionViewCell_H (kScreenW-83)/4.0

NS_ASSUME_NONNULL_BEGIN

@protocol ZYReportAboutRepairApplyTextCellDelegate <NSObject>

@optional

- (void)addPhotos;

- (void)imageViewTapWithIndex:(NSInteger)index;

- (void)deletePhotoWithIndex:(NSInteger)index;

@end

@interface ZYReportAboutRepairApplyTextCell : UITableViewCell

@property (nonatomic, strong) NSArray *imagesArray;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, weak) id<ZYReportAboutRepairApplyTextCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
