//
//  PopViewSubHeaderView.h
//  Community
//
//  Created by 余莹 on 2022/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PopViewSubHeaderViewBtnCancelOrOkBtnBlock)(BOOL isTouchhOkBtnBool);

@interface PopViewSubHeaderView : UIView

@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *okBtn;
@property (nonatomic,copy) PopViewSubHeaderViewBtnCancelOrOkBtnBlock isTouchhOkBtnBoolBlock;

@end

NS_ASSUME_NONNULL_END
