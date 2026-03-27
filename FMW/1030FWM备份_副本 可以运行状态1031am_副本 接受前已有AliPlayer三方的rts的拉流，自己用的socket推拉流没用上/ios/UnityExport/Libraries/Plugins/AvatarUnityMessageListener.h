//
//  AvatarUnityMessageListener.h
//  AvatarUnityBridge
//
//  Created by Sr on 2022/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AvatarUnityMessageListener

- (void)didReceiveUnityMessage:(NSString *)message;

@end

@interface AvatarUnityMessageCenter : NSObject

@property (nonatomic, readonly, strong, class) AvatarUnityMessageCenter *defaultCenter;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)addMessageListener:(id<AvatarUnityMessageListener>)listener;
- (void)removeMessageListener:(id<AvatarUnityMessageListener>)listener;

@end

NS_ASSUME_NONNULL_END
