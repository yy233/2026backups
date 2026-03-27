//
//  PopViewBuniessShopQiZuMainZu.h
//  Community
//
//  Created by 余莹 on 2021/3/22.
// 商铺的 起租期 免租期 待写

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    PopViewBuniessShopChooseQiZuMainZu_Type_QiZu,    //起租
    PopViewBuniessShopChooseQiZuMainZu_Type_MianZu,  //免租
} PopViewBuniessShopChooseQiZuMainZu_Type;

@protocol PopViewBuniessShopChooseQiZuMainZuDelegate <NSObject>
- (void)shopBuniessQiZuMainZuInfo:(NSMutableArray *)qiZuMianZuArr; //num
@end
@interface PopViewBuniessShopChooseQiZuMainZu : BasePopView
//
@property (nonatomic,assign) PopViewBuniessShopChooseQiZuMainZu_Type selfNowType;
@property (nonatomic,weak) id <PopViewBuniessShopChooseQiZuMainZuDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *saveQuZuMianZuArr;
@end

NS_ASSUME_NONNULL_END
