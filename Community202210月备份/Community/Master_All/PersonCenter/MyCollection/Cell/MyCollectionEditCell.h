//
//  MyCollectionEditCell.h
//  Community
//
//  Created by 刘久炼 on 2021/2/24.
//

#import <UIKit/UIKit.h>

#import "MyCollectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MyCollectionEditCellDelegate <NSObject>

@optional - (void)cellSeletedWithModel: (MyCollectionModel *)model status: (NSInteger) status;

@end

@interface MyCollectionEditCell : UITableViewCell

@property (nonatomic, weak) id<MyCollectionEditCellDelegate> delegate;

@property(nonatomic, strong) MyCollectionModel *model;


@end

NS_ASSUME_NONNULL_END
