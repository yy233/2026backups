//
//  MainCenterAddressBookCollectionViewCell.h
//  Community
//
//  Created by 余莹 on 2020/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainCenterAddressBookCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *backImgView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *headerImgView;
@property (nonatomic,strong)UIButton *phoneImgBtn;


@property (nonatomic,strong) MainCenterCollectionViewAddressBookCellModel *model;
@end

NS_ASSUME_NONNULL_END
