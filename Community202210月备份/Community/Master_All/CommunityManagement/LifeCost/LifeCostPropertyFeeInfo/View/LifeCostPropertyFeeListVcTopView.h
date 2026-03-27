//
//  LifeCostPropertyFeeListVcTopView.h
//  Community
//
//  Created by 余莹 on 2021/7/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    LifeCostPropertyFeeListVcTopView_Staus_NoPay,
    LifeCostPropertyFeeListVcTopView_Staus_Payed,
} LifeCostPropertyFeeListVcTopView_Staus;// 0.未缴 1.已缴

@protocol LifeCostPropertyFeeListVcTopViewDelegate <NSObject>

- (void)chooseStaussIndexWithStaus:(LifeCostPropertyFeeListVcTopView_Staus)staus;
- (void)topAddressBtnTouchAction;
@end


@interface LifeCostPropertyFeeListVcTopView : UIView
@property (nonatomic,strong) UIImageView *leftImgV;
@property (nonatomic,strong) UIButton *addressBtn;
//
@property (nonatomic,strong) UIView *twoBtnBackView;
@property (nonatomic,strong) UIView *twoBtnCenterLineView;
@property (nonatomic,strong) UIButton *oneBtn;
@property (nonatomic,strong) UIButton *twoBtn;

//
@property (nonatomic,weak) id <LifeCostPropertyFeeListVcTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
