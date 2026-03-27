//
//  MainLateMyServiceCell.h
//  Community
//
//  Created by 余莹 on 2021/8/9.
//

#import <UIKit/UIKit.h>
#import "MainLateMyServiceSubCollectionViewCell.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^MainMyServiceSubCellTouchBlock)(NSInteger);  

@interface MainLateMyServiceCell : UITableViewCell

@property (nonatomic,copy) MainMyServiceSubCellTouchBlock touchSubCellBlock;
@end

NS_ASSUME_NONNULL_END
