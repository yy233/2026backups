//
//  ZYMessageTopCollectionViewCell.h
//  Community
//
//  Created by ZY on 2021/4/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYMessageTopCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)fillData:(NSMutableDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
