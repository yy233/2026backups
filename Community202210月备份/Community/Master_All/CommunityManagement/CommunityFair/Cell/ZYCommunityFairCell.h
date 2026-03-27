//
//  ZYCommunityFairCell.h
//  Community
//
//  Created by ZY on 2021/8/3.
//

#import <UIKit/UIKit.h>
#import "ZYCommunityFairListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommunityFairCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *editView;

@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (nonatomic, copy) NSString *editStr;

@property (nonatomic, strong) ZYCommunityFairListDataListModel *model;

@end

NS_ASSUME_NONNULL_END
