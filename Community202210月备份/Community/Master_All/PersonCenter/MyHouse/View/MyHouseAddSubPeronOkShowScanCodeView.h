//
//  MyHouseAddSubPeronOkShowScanCodeView.h
//  Community
//
//  Created by 余莹 on 2021/10/16.
//

#import <UIKit/UIKit.h>
 
NS_ASSUME_NONNULL_BEGIN

@interface MyHouseAddSubPeronOkShowScanCodeView : UIView
@property (nonatomic,strong) UIImageView *headerImg;
@property (nonatomic,strong) UILabel *topLabel;
@property (nonatomic,strong) UILabel *topDetailLabel;
@property (nonatomic,strong) UILabel *scanBottomHouseInfoDetailLabel;
@property (nonatomic,strong) UIButton *bottomScanBtn;
@property (nonatomic,strong) UIButton *bottomHeadBtn;
@property (nonatomic,strong) BaseTableViewFooterView *savePhoneBtnView;
@property (nonatomic,strong) UIView *scanCodeImgBackV;
@property (nonatomic,strong) UIImageView *scanCodeImg;

- (void)addPersonOkUrlIs:(NSString *)urlStr;
@end

NS_ASSUME_NONNULL_END
