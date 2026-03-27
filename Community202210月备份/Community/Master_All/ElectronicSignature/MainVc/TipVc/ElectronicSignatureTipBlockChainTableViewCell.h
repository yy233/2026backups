//
//  ElectronicSignatureTipBlockChainTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import <UIKit/UIKit.h>
 
NS_ASSUME_NONNULL_BEGIN

@interface ElectronicSignatureTipBlockChainTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *rightImg;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *detailL;
- (void)showRightTextAndLeftImgCell;
- (void)showLeftTextAndRightImgCell;
@end

NS_ASSUME_NONNULL_END
