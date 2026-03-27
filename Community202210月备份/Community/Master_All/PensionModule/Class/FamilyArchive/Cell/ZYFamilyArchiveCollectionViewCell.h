//
//  ZYFamilyArchiveCollectionViewCell.h
//  Community
//
//  Created by ZY on 2021/11/18.
//

#import <UIKit/UIKit.h>
#import "ZYFamilyArchiveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYFamilyArchiveCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@property (nonatomic, strong) ZYFamilyArchiveModel *model;

@end

NS_ASSUME_NONNULL_END
