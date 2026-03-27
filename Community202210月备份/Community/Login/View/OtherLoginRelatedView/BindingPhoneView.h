//
//  BindingPhoneView.h
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface BindingPhoneView : UIView
@property (nonatomic,strong) UIButton *removeSelfBtn;
@property (nonatomic,strong) UIButton *okBtn;
@property (nonatomic,strong) NSString *phoneStr;
- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
