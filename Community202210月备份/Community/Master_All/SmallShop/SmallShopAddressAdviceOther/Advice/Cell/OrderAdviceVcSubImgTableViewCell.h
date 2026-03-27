//
//  OrderAdviceVcSubImgTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *OrderAdviceVcSubImgTableViewCell_I = @"OrderAdviceVcSubImgTableViewCell";

typedef void(^TouchSubImgCollectionCellBlock)(NSInteger itemIndex);

@interface OrderAdviceVcSubImgTableViewCell : UITableViewCell
@property (nonatomic,copy) TouchSubImgCollectionCellBlock touchSubImgCollectionCellBlock;
- (void)fillShowArrWith:(NSMutableArray *)showArr;

@end

NS_ASSUME_NONNULL_END
