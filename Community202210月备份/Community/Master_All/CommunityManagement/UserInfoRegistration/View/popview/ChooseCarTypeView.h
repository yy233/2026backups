//
//  ChooseCarTypeView.h
//  Community
//
//  Created by 余莹 on 2020/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ChoosCarTypeDelegate <NSObject>
- (void)chooseCarType:(NSString *)carStr;//暂时未用 待类型数据
@end
@interface ChooseCarTypeView : UIView
@property (nonatomic,weak) id <ChoosCarTypeDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
