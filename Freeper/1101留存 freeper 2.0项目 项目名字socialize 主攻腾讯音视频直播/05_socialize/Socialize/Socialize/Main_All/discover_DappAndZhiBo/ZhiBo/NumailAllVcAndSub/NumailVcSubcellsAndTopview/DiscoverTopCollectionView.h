//
//  DiscoverTopCollectionView.h
//  Socialize
//
//  Created by 余莹 on 2023/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


//typedef enum : NSUInteger {
//    ZhiBoListTopType_LiveIng = 0,
//    ZhiBoListTopType_waitLive,
//    ZhiBoListTopType_Live,
//}  ZhiBoListTopType;

@protocol DiscoverTopCollectionViewDelegate <NSObject>
//- (void)nowSelectedType:(ZhiBoListTopType)discoverTopType;
@end
  
@interface DiscoverTopCollectionView : UIView

//@property (nonatomic,strong) UICollectionView *collectionV;
//@property (nonatomic,strong) UIButton *searchBtn;
//@property (nonatomic,weak) id <DiscoverTopCollectionViewDelegate>delegate;
//@property (nonatomic,assign) ZhiBoListTopType nowZhiBoListTopSelectedType;

@end

#pragma mark ===
@interface subCollectionCell : UICollectionViewCell
//@property (nonatomic,strong) UIView *bkView;
//@property (nonatomic,strong) UILabel *centLabel;
@property (nonatomic,strong) UIButton *showBtn;

@end
NS_ASSUME_NONNULL_END
