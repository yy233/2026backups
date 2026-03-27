//
//  AdviceView.h
//  Community
//
//  Created by 余莹 on 2020/12/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdviceView : UIView
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *textviewTopPlaceholdeLabel;

@property (nonatomic,strong) UIButton *complaintsBtn;//投诉
@property (nonatomic,strong) UIButton *adviceBtn;//建议
@property (nonatomic,strong) UITextView *textView; 
@property (nonatomic,strong) UIView *allImgBackView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

NS_ASSUME_NONNULL_END
