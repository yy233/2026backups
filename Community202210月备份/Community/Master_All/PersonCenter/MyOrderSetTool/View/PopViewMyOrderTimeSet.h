//
//  PopViewMyOrderTimeSet.h
//  Community
//
//  Created by 余莹 on 2021/2/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PopViewMyOrderTimeSetDelegate <NSObject>
- (void)popViewTouchSaveWithTimeHStr:(NSString *)hStr
                            withMStr:(NSString *)mStr
                          withDayStr:(NSString *)dStr;
- (void)popViewTouchSaveEditCellIndex:(NSInteger)index
                         withTimeHStr:(NSString *)hStr
                            withMStr:(NSString *)mStr
                          withDayStr:(NSString *)dStr;

@end

@interface PopViewMyOrderTimeSet : BasePopView
@property (nonatomic,strong) UIPickerView *pickV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *subBtnsTitleL;
@property (nonatomic,strong) UIView *subBtnBackView;
@property (nonatomic,strong) BaseTableViewFooterView *saveBtnView;
@property (nonatomic,weak) id <PopViewMyOrderTimeSetDelegate> delegate;
//
- (void)showInViewEditCellIndex:(NSInteger)index andWithArray:(NSMutableArray *)timeArr;

@end

NS_ASSUME_NONNULL_END
