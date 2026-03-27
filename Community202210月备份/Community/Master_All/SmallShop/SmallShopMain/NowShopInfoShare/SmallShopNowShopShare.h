//
//  SmallShopNowShopShare.h
//  Community
//
//  Created by 余莹 on 2022/3/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SmallShopNowShopShare : NSObject

singleton_interface(share)

@property (nonatomic,strong) NSString *saveNowShopId;//店铺ID
@property (nonatomic,strong) NSString *saveNowShopIMId;//即时通讯ID
@property (nonatomic,strong) NSString *saveNowShopPhone;//店铺电话
@property (nonatomic,strong) NSString *saveNowShopAddress;//店铺地址
@property (nonatomic,assign) CGFloat saveNowShopLat;//店铺地址经纬度
@property (nonatomic,assign) CGFloat saveNowShopLongi;//店铺地址经纬度
@end

NS_ASSUME_NONNULL_END
