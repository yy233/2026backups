//
//  ParkingTemporaryVcTopView.h
//  Community
//
//  Created by 余莹 on 2021/8/6.
//

#import <UIKit/UIKit.h>
#import "MyCarAddOrEditView.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^SaveBtnActionBlock)();

@interface ParkingTemporaryVcTopView : MyCarAddOrEditView
@property (nonatomic,copy) SaveBtnActionBlock saveBlock;
@end

NS_ASSUME_NONNULL_END
