//
//  ZYPensionMainFunctionCell.h
//  Community
//
//  Created by ZY on 2021/11/5.
//

#import <UIKit/UIKit.h>

#define kFunctionCollectionViewCell_W (kScreenW - 49)/3.0
#define kFunctionCollectionViewCell_H (kScreenW - 49)/3.0*(76/111.0)

NS_ASSUME_NONNULL_BEGIN

@protocol ZYPensionMainFunctionCellDegate <NSObject>

- (void)collectionViewSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZYPensionMainFunctionCell : UITableViewCell

@property (nonatomic, weak) id<ZYPensionMainFunctionCellDegate> delegate;

@end

NS_ASSUME_NONNULL_END
