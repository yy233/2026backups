//
//  PopViewOfUserQRUseInfo.h
//  Socialize
//
//  Created by 余莹 on 2023/7/24.
//

#import "BasePopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PopViewOfUserQRUseInfo : BasePopView

@property (nonatomic,strong) UIView *showUseCenterBackView;
@property (nonatomic,strong) UILabel *addressL;
@property (nonatomic,strong) UILabel *imidL;
@property (nonatomic,strong) UIImageView *headerImgv;
@property (nonatomic,strong) UIImageView *qRImgv;
@property (nonatomic,strong) UIButton *deletBtn;

- (void)fillPopQrInfoWithUse;
@end

NS_ASSUME_NONNULL_END
