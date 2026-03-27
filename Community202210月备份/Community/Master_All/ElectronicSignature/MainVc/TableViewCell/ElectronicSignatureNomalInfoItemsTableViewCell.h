//
//  ElectronicSignatureNomalInfoItemsTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import <UIKit/UIKit.h>
 

NS_ASSUME_NONNULL_BEGIN
@protocol ElectronicSignatureNomalInfoItemsTableViewCellDelegate <NSObject>
- (void)nomalInfoItemsCellTouchUpItemWithIndex:(NSInteger)index;
@end

@interface ElectronicSignatureNomalInfoItemsTableViewCell : UITableViewCell
- (void)showInfoItemsCellWithData;
@property (nonatomic,weak) id <ElectronicSignatureNomalInfoItemsTableViewCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
