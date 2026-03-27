//
//  PopViewCarType.h
//  Community
//
//  Created by 余莹 on 2020/12/11.
//

#import <UIKit/UIKit.h>
#import "PopViewAccomPanyCar.h"
NS_ASSUME_NONNULL_BEGIN
@protocol PopViewCarTypeDelegate <NSObject>
- (void)popViewChooseCarTypeModle:(CarTypeModel *)typeMode;
@end

@interface PopViewCarType : PopViewAccomPanyCar
@property (nonatomic,weak) id <PopViewCarTypeDelegate> delegateOfCarType;
@end

NS_ASSUME_NONNULL_END
