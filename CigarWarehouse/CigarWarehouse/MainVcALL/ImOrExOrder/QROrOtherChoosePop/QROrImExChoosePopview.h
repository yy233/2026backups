//
//  QROrImExChoosePopview.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/18.
//

#import <UIKit/UIKit.h>
#import "ImExOrderOtherTool.h"
NS_ASSUME_NONNULL_BEGIN

@interface QROrImExChoosePopview : UIView
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIButton *doQRBtn;
@property (nonatomic,strong) UIButton *doFormBtn;
@property (nonatomic,assign) ImorExOrder_SubType type;

- (void)showPopViewWithDataArr:( NSMutableArray * _Nullable )dataArr
                  withShowType:(ImorExOrder_SubType)type
                 withOtherData:(_Nullable id)otherData
                 withBkvHeight:(CGFloat)bkHeight
                    withSuperV:( UIView * _Nullable )supview;
- (void)dismissPopView;
@end

NS_ASSUME_NONNULL_END
