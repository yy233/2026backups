//
//  BaseTableViewFooterView.h
//  Community
//
//  Created by 余莹 on 2020/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//只会使用fram里的宽高做btn的宽和总高
@interface BaseTableViewFooterView : UIView
@property (nonatomic,strong) UIView *footerBackview;
@property (nonatomic,strong) UIButton *footerBtn;
- (void)setBtnFram:(CGRect)fram;
- (void)setBtnFramWithNotCenterxIsCenteryOfMasWithFram:(CGRect)fram;
@end

NS_ASSUME_NONNULL_END
