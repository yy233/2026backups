//
//  ImgAndBtnCollectionViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImgAndBtnCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIView *objBackView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIButton *centerBtn;
@property (nonatomic,strong) UIButton *deletBtn;
@property (nonatomic,strong) UIButton *editBtn;
- (void)showCenterAddBtnWithBool:(BOOL)isShow;
- (void)hiddenAllSubViewWithBool:(BOOL)showAllOrHiddenAll;
@end

NS_ASSUME_NONNULL_END
