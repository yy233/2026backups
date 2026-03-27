//
//  FeedbackCollectionViewTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/28.
//

#import <UIKit/UIKit.h>
#import "FeedbackBaseTitleTableViewCell.h"
#import "ZYSealImageModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FeedbackCollectionViewTableViewCellDelegate <NSObject>
- (void)addPhotosAction;
- (void)deletPhotoActionWithIndex:(NSInteger)itemNum;
- (void)imgViewTapWithIndex:(NSInteger)index;
@end

@interface FeedbackCollectionViewTableViewCell : FeedbackBaseTitleTableViewCell

@property (nonatomic,weak) id <FeedbackCollectionViewTableViewCellDelegate> deleagte;

@property (nonatomic, strong) NSArray<ZYSealImageDataModel *> *imageArray;

@end

NS_ASSUME_NONNULL_END
