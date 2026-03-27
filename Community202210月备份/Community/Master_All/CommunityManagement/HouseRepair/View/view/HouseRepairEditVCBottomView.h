//
//  HouseRepairEditVCBottomView.h
//  Community
//
//  Created by 余莹 on 2020/12/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HouseRepairEditVCBottomViewDelegate <NSObject>
- (void)chooseBtnIsTouchWitllToChoose;//选择图片等
- (void)changeImgWithTouchImgBtnWithNum:(NSInteger)imgNum;//换图
@end
@interface HouseRepairEditVCBottomView : UIView
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIButton *imgOneBtn;
@property (nonatomic,strong) UIButton *imgTwoBtn;
@property (nonatomic,strong) UIButton *imgThrBtn;
@property (nonatomic,strong) UIButton *chooseImgBtn;
@property (nonatomic,strong) HouseRepairEditModel *model;
@property (nonatomic,weak) id <HouseRepairEditVCBottomViewDelegate> delegate;
- (void)imgShowNum:(NSInteger)num;
@end

NS_ASSUME_NONNULL_END
