//
//  MainBannerListViewModel.h
//  Community
//
//  Created by 余莹 on 2020/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    Banner_Position_Top=1,
    Banner_Position_Bottom=2,
} BannerPositionType;

typedef void(^BannerListBlock)(NSArray *);

@interface MainBannerListViewModel : NSObject
@property (nonatomic,copy) BannerListBlock bannerListBlock;
- (void)getTopBannerListDataWithListBlock:(BannerListBlock)block;
+ (void)getTopBannerListDataWithListBlock:(BannerListBlock)block;
//- (void)getCenterBannerListDataWithListBlock:(BannerListBlock)block;
//+ (void)getCenterBannerListDataWithListBlock:(BannerListBlock)block;
+ (void)getShoppingBannerListDataWithListBlock:(BannerListBlock)block;
@end  

NS_ASSUME_NONNULL_END
