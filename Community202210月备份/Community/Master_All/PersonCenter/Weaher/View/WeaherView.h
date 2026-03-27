//
//  WeaherView.h
//  Community
//
//  Created by 刘久炼 on 2021/2/24.
//

#import <UIKit/UIKit.h>
#import "ZYWeatherModel.h"

@protocol WeaherViewDelegate <NSObject>

@optional - (void)addressClicked;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WeaherView : UIView

@property (nonatomic, weak) id<WeaherViewDelegate> delegate;

@property (nonatomic, strong) ZYWeatherDataModel *dataModel;

@end

NS_ASSUME_NONNULL_END
