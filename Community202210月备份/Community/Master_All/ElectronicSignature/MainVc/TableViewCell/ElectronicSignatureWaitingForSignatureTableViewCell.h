//
//  ElectronicSignatureWaitingForSignatureTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol ElectronicSignatureWaitingForSignatureTableViewCellDelegate <NSObject>
- (void)waitingForSignatureCellTouchUpItemWithIndex:(NSInteger)index;
@end

@interface ElectronicSignatureWaitingForSignatureTableViewCell : UITableViewCell
- (void)showCellWithData;
@property (nonatomic,weak) id <ElectronicSignatureWaitingForSignatureTableViewCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
