//
//  DappUsePopView.h
//  Socialize
//
//  Created by 余莹 on 2023/6/8.
//

#import <UIKit/UIKit.h>
#import "BasePopView.h"


typedef enum : NSUInteger {
    DappUsePopView_ChooseType_Refresh,
    DappUsePopView_ChooseType_ShouCang,
    DappUsePopView_ChooseType_CopyLink,
    DappUsePopView_ChooseType_Share,
    DappUsePopView_ChooseType_LiuLanQiOp,
} DappUsePopView_ChooseType;

NS_ASSUME_NONNULL_BEGIN


@protocol DappUsePopViewDelegate <NSObject>

- (void)touchIndexType:(NSInteger)indexType;
 
@end

@interface DappUsePopView : BasePopView
@property (nonatomic,weak) id <DappUsePopViewDelegate> popViewTouchDelegate;
@property (nonatomic,assign) BOOL isShouCangTypeBool;
@end


@interface PopsubCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UILabel *titL;
@property (nonatomic,strong) UIButton *wightBtn;

@end
NS_ASSUME_NONNULL_END

