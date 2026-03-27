//
//  EIntergralMallVcHeaderView.h
//  Community
//
//  Created by 余莹 on 2021/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  EIntergralMallVcHeaderViewDelegate <NSObject>
- (void)headerViewTouchMingXiAction;
- (void)headerViewTouchEMallAction;
- (void)headerViewTouchEOrderAction;

@end

@interface EIntergralMallVcHeaderView : UIView
@property (nonatomic,strong) UIView *topBackV;
@property (nonatomic,strong) UILabel *eNumL;
@property (nonatomic,strong) UIButton *eMingXiBtn;
@property (nonatomic,strong) UIView *bottomBackV;
@property (nonatomic,strong) UIButton *eMallBtn;
@property (nonatomic,strong) UIButton *eOrderBtn;
//
@property (nonatomic,weak) id <EIntergralMallVcHeaderViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
