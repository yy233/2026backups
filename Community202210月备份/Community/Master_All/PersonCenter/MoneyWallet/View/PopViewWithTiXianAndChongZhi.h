//
//  PopViewWithTiXianAndChongZhi.h
//  Community
//
//  Created by 余莹 on 2021/10/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ChooseType_Null,
    ChooseType_WeiXin,
    ChooseType_ZhiFuBao,
} ChooseType;

@protocol PopViewWithTiXianAndChongZhiDelegate <NSObject>

- (void)popViewWithChooseType:(ChooseType)chooseType;

@end

@interface PopViewWithTiXianAndChongZhi : BasePopTableView
@property (nonatomic,weak) id <PopViewWithTiXianAndChongZhiDelegate> chooseTypeDelegate;
@end

NS_ASSUME_NONNULL_END
