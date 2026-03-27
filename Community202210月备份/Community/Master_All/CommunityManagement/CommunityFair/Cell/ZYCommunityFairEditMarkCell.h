//
//  ZYCommunityFairEditMarkCell.h
//  Community
//
//  Created by ZY on 2021/8/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommunityFairEditMarkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) TTGTextTagCollectionView *textTagCollectionView;

@end

NS_ASSUME_NONNULL_END
