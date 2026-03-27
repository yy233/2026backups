//
//  PopViewChooseVisitTime.h
//  Community
//
//  Created by 余莹 on 2020/12/4.
//

#import <UIKit/UIKit.h>
#import "PopTimeSubBtnView.h"

#define Width_All_Days (Screen_W-32)
#define Width_WeakShow (Screen_W-32)/7

#define Width_One_Day (Screen_W-32)/7
#define Height_One_Day 50

#define cancel_Btn_Tag 180
#define ok_Btn_Tag 181

#define left_Btn_Tag 190
#define right_Btn_Tag 191

#define days_Btn_Tag 200


NS_ASSUME_NONNULL_BEGIN

@protocol  PopViewChooseVisitTimeDelegate<NSObject>
- (void)popViewChooseVisitTimeChooseDayArr:(NSMutableArray *)timeStrArr;
@end


@interface PopViewChooseVisitTime : BasePopView

@property (nonatomic,strong) UIView *topOneBackView;
@property (nonatomic,strong) UIView *topTwoBackView;
@property (nonatomic,strong) UIView *centerWeakBackView;//l 16-r 16
@property (nonatomic,strong) UIView *centerDaysBackView;//16-16
@property (nonatomic,strong) UIView *bottomBackView;

@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *okBtn;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *leftMonthBtn;
@property (nonatomic,strong) UIButton *rightMonthBtn;
@property (nonatomic,strong) UIButton *centerShowMonthBtn;

@property (nonatomic,strong) UIButton *bottomTipBtn;

@property (nonatomic,strong) NSMutableArray *arrOfBtnClik;

@property (nonatomic,strong) NSMutableArray *saveClickDayIvNum;//改变月份时 存下之前已有的时间


@property (nonatomic,weak) id <PopViewChooseVisitTimeDelegate> delegate; 
@end

NS_ASSUME_NONNULL_END
