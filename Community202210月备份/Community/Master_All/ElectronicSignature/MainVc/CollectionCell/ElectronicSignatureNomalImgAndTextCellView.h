//
//  ElectronicSignatureNomalImgAndTextSearchView.h
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ElectronicSignatureNomalImgAndTextCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIView *backV;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleL;
- (void)setCellNewUIWithTitleAndImgHaveJianJu;
@end

NS_ASSUME_NONNULL_END
