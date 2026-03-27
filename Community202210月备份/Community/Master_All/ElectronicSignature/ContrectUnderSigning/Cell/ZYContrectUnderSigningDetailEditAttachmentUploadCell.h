//
//  ZYContrectUnderSigningDetailEditAttachmentUploadCell.h
//  Community
//
//  Created by ZY on 2021/5/19.
//

#import <UIKit/UIKit.h>
#import "ZYSealImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYContrectUnderSigningDetailEditAttachmentUploadCellDelegate <NSObject>

- (void)contrectUnderSigningDetailEditAttachmentUploadCellSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)deleteButtonSelectedIndex:(NSInteger)index;

@end

@interface ZYContrectUnderSigningDetailEditAttachmentUploadCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic, weak) id<ZYContrectUnderSigningDetailEditAttachmentUploadCellDelegate> delegate;

@property (nonatomic, strong) NSArray<ZYSealImageDataModel *> *imageArray;

@end

NS_ASSUME_NONNULL_END
