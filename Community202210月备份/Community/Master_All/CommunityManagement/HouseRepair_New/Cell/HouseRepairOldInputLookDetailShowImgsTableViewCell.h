//
//  HouseRepairOldInputLookDetailShowImgsTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *HouseRepairOldInputLookDetailShowImgsTableViewCell_I = @"HouseRepairOldInputLookDetailShowImgsTableViewCell";

typedef void(^TouchImgBlock)(NSInteger index);
@interface HouseRepairOldInputLookDetailShowImgsTableViewCell : UITableViewCell
@property (nonatomic,copy) TouchImgBlock touchImgBlock;
- (void)fillDataWithImgsArr:(NSArray *)imgsArr;
@end

NS_ASSUME_NONNULL_END
