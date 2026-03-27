//
//  BottomBtnsView.h
//  Socialize
//
//  Created by 余莹 on 2023/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZhuBoSleepBottomBtnsViewDelegate <NSObject>
- (void)touchOtherZhuBoRoom;
@end


@interface ZhuBoSleepBottomBtnsView : UIView
@property (nonatomic,strong) UILabel *titL;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) id <ZhuBoSleepBottomBtnsViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
