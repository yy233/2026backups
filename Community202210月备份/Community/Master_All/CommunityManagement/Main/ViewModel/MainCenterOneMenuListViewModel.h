//
//  MainCenterMenuListViewModel.h
//  Community
//
//  Created by 余莹 on 2020/11/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MenuListBlock)(NSMutableArray *);

@interface MainCenterOneMenuListViewModel : NSObject
@property (nonatomic,copy) MenuListBlock menuListlock;
+ (void)getCenterOneMenuListArrWithMenuBlock:(MenuListBlock)block;
+ (void)getMoreMenuListArrWithMenuBlock:(MenuListBlock)block;
+ (void)getCenterOneMenuListArrWithMenuBlockNew:(MenuListBlock)block;
+ (void)getMoreMenuListArrWithMenuBlockNew:(MenuListBlock)block;
@end

NS_ASSUME_NONNULL_END
