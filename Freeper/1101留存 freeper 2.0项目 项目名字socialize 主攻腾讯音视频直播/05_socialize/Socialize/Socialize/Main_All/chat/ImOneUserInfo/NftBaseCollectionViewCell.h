//
//  NftBaseCollectionViewCell.h
//  Socialize
//
//  Created by 余莹 on 2023/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *NftBaseCollectionViewCell_ShowMoney_I = @"NftBaseCollectionViewCell_ShowMoney";
static NSString *NftBaseCollectionViewCell_I = @"NftBaseCollectionViewCell";

@interface NftBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *nftImgV;
@property (nonatomic,strong) UILabel *nftLabel;

@end

#pragma mark ===
@interface NftBaseCollectionViewCell_ShowMoney : NftBaseCollectionViewCell
@property (nonatomic,strong) UIImageView *moneyIcon;
@property (nonatomic,strong) UILabel *mongyL;
@end

NS_ASSUME_NONNULL_END
