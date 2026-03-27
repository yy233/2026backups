//
//  ZhiBoTopTypeChooseView.h
//  Socialize
//
//  Created by 余莹 on 2023/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// typedef enum : NSUInteger {
//    ZhiBoListTopType_LiveIng = 0,
//    ZhiBoListTopType_waitLive,
//    ZhiBoListTopType_Live,
//}  ZhiBoListTopType;

typedef enum : NSUInteger {
   ZhiBoListTopType_LiveIng = 0,
   ZhiBoListTopType_waitLive,
}  ZhiBoListTopType;

@protocol ZhiBoTopTypeChooseViewCollectionViewDelegate <NSObject>
- (void)nowSelectedType:(ZhiBoListTopType)discoverTopType;
@end
  
@interface ZhiBoTopTypeChooseView : UIView

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,weak) id <ZhiBoTopTypeChooseViewCollectionViewDelegate>delegate;
@property (nonatomic,assign) ZhiBoListTopType nowZhiBoListTopSelectedType;

@end

#pragma mark ===
@interface SubCollectionCell : UICollectionViewCell
@property (nonatomic,strong) UIButton *showBtn;
@end
 
 

NS_ASSUME_NONNULL_END
