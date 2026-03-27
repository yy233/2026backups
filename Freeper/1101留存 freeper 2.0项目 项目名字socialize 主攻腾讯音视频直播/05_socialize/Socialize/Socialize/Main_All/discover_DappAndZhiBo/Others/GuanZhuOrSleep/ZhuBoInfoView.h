//
//  ZhuBoInfoView.h
//  Socialize
//
//  Created by 余莹 on 2023/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZhuBoInfoView : UIView
@property (nonatomic,strong) UIImageView*topBkImgV;
@property (nonatomic,strong) UIView *bottomBkView;
@property (nonatomic,strong) UILabel *idLable;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UIButton *rightTopJuBaoBtn;
@property (nonatomic,strong) UILabel *nickNameL;
@property (nonatomic,strong) UIView *baseInfoBkView;
@property (nonatomic,strong) UITextView *infoTextView;

@end

NS_ASSUME_NONNULL_END
