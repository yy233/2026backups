//
//  ParkingPayMonthlyNumBtnTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/8/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CellChangeMonthlyNumBlock)(NSInteger);//传入月数量

@interface ParkingPayMonthlyNumBtnTableViewCell :  BaseTableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UITextField *textF;
@property (nonatomic,strong) UIButton *subtractBtn;
@property (nonatomic,strong) UIButton *addBtn;
//
@property (nonatomic,assign) NSInteger monthlyN;
@property (nonatomic,copy) CellChangeMonthlyNumBlock monthlyNumChangeBlock;

@end

NS_ASSUME_NONNULL_END
