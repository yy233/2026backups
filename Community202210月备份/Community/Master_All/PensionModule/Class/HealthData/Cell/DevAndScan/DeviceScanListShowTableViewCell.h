//
//  DeviceScanListShowTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/11/13.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CellTouchRightBtnActionBlock)(ZHJBTDevice *);

@interface DeviceScanListShowTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *statusShowBtn;
@property (nonatomic,strong) UIButton *rightClickBtn;
@property (nonatomic,strong) UIActivityIndicatorView *rightIndicatorView;

- (void)fillDataWithDev:(ZHJBTDevice *)dev;
@property (nonatomic,copy) CellTouchRightBtnActionBlock clickBtnBlock;

//
@property (nonatomic,assign) DeviceState saveOldDevState;
@property (nonatomic,assign) BOOL touchDevConnectedYesChangeBool;
@end

NS_ASSUME_NONNULL_END
