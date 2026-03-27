//
//  BaseChoosePopView.h
//  Community
//
//  Created by 余莹 on 2021/8/5.
////暂时不用这个pop


#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^YesBtnTouchBlock)(NSMutableArray *);

@interface BaseChoosePopView : UIView

@property (strong, nonatomic)   UIView *btnBackView;
@property (strong, nonatomic)   UIView *titleBackView;
@property (strong, nonatomic)   UILabel *titleLabel;
@property (strong, nonatomic)   UIButton *cancelBtn;
@property (strong, nonatomic)   UIButton *yesBtn;
@property (strong, nonatomic)   UITableView *tableViewOfChooseLanguage;
//
@property (nonatomic,strong) NSMutableArray *arrOfTableViewData;
@property (nonatomic,strong) NSMutableArray *arrOfTableViewDataNum;

- (void)setDataWithTitleArr:(NSMutableArray *)arrOfPopTitle
                     numArr:(NSMutableArray *)arrOfPopTitleNum;
@property (nonatomic,copy) YesBtnTouchBlock yesBlock;
@end

NS_ASSUME_NONNULL_END
