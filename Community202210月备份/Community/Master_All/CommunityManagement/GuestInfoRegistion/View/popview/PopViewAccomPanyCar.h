//
//  PopViewAccomPanyCar.h
//  Community
//
//  Created by 余莹 on 2020/12/9.
//

#import <UIKit/UIKit.h>
#import "BasePopView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol PopViewAccomPanyCarDelegate <NSObject>
- (void)carAddNewModel:(CarInfoModel *)newCarInfoModel removeOldCarInfoModel:(CarInfoModel *)oldCarInfomodell;
@end
@interface PopViewAccomPanyCar : BasePopView
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *oneBackV;
@property (nonatomic,strong) UIView *cartypeItemBackView;
@property (nonatomic,strong) NSMutableArray <CarTypeModel*> *cartypeModleArr;//车 类型 数组
@property (nonatomic,strong) CarTypeModel *carTypeMode;//当前类型数据

@property (nonatomic,weak) id < PopViewAccomPanyCarDelegate> delegate;
- (void)showInView:(UIView *)supview thePopViewSubViewHeight:(float)subViewHeight WithArray:(NSMutableArray *)array WithOldCarInfoModel:(CarInfoModel *)oldModel;//新增一种show方式
//参数可为空
@end 
NS_ASSUME_NONNULL_END
