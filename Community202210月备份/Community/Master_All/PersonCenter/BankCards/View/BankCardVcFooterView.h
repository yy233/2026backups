//
//  BankCardVcFooterView.h
//  Community
//
//  Created by 余莹 on 2021/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankCardVcFooterView : UIView
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *detailL;
@property (nonatomic,strong) BaseTableViewFooterView *footerBtnView;
@end

NS_ASSUME_NONNULL_END
