//
//  MyHouseSectionView.h
//  Community
//
//  Created by 余莹 on 2021/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MyHouseSectionHeaderViewManagerBtnTouchUpBool)(BOOL);
@interface MyHouseSectionHeaderView : UIView
@property (nonatomic,strong) UILabel *titleL; 
@property (nonatomic,strong) UIButton *managerDeletBtn;
@property (nonatomic,copy) MyHouseSectionHeaderViewManagerBtnTouchUpBool  managerBtnTouchUpSelectedBool;
@end

NS_ASSUME_NONNULL_END
