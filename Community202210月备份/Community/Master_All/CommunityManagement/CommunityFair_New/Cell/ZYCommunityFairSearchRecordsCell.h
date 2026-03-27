//
//  ZYCommunityFairSearchRecordsCell.h
//  Community
//
//  Created by ZY on 2022/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommunityFairSearchRecordsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, strong) TTGTextTagCollectionView *textTagCollectionView;

@end

NS_ASSUME_NONNULL_END
