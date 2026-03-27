//
//  ZYMedicalMainFunctionCell.h
//  Community
//
//  Created by ZY on 2021/12/1.
//

#import <UIKit/UIKit.h>

#define kServiceCollectionViewCell_W (kScreenW - 93)/4.0
#define kServiceCollectionViewCell_H 70
#define kHealthCollectionViewCell_W (kScreenW - 43)/2.0
#define kHealthCollectionViewCell_H (kScreenW - 43)/2.0*(86/166.0)

NS_ASSUME_NONNULL_BEGIN

@protocol ZYMedicalMainFunctionCellDelegate <NSObject>

- (void)collectionViewSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZYMedicalMainFunctionCell : UITableViewCell

@property (nonatomic, weak) id<ZYMedicalMainFunctionCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
