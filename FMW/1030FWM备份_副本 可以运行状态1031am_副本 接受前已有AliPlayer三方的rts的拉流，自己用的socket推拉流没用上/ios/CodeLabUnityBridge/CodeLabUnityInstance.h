//
//  CodeLabUnityInstance.h
//  CodeLabUnityBridge
//
//  Created by Sera on 2023/8/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <mach-o/ldsyms.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CodeLabUnityInstanceMessageListener
- (void)didReceiveUnityMessage:(NSString *)message;
@end

@protocol CodeLabUnityInstanceRenderDelegate
- (void)didRenderFrame:(CVPixelBufferRef)pixelBuffer atTime:(CMTime)time;
@end

typedef NS_ENUM(NSUInteger, CodeLabUnityWindowTransitionStyle) {
    CodeLabUnityWindowTransitionStyleCoverVerticalFromTop,
    CodeLabUnityWindowTransitionStyleCoverVertical,
    CodeLabUnityWindowTransitionStylePush,
    CodeLabUnityWindowTransitionStyleNone
};

@interface CodeLabUnityWindowPresentationOptions : NSObject
@property (nonatomic) CodeLabUnityWindowTransitionStyle transitionStyle;
@property (nonatomic) BOOL isAnimated;
@property (nonatomic) BOOL isVisible;
@end

@interface CodeLabUnityWindowHandle : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic) BOOL isPaused;

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(NSError * __nullable))completionHandler;

- (void)hideAnimated:(BOOL)animated completion:(void (^)(NSError * __nullable))completion  NS_SWIFT_NAME(hide(animated:completion:));

- (void)showAnimated:(BOOL)animated completion:(void (^)(NSError * __nullable))completion NS_SWIFT_NAME(show(animated:completion:));

@end

@interface CodeLabUnityInstance : NSObject

@property (nonatomic, class, strong, readonly) CodeLabUnityInstance *sharedInstance;

+ (void)registerHostWindow:(UIWindow *)window executableHader:(const struct mach_header_64 *)header;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, readonly) BOOL isPaused;

@property (nonatomic, readonly) BOOL isActive;

- (void)presentUnityWindowWithOptions:(CodeLabUnityWindowPresentationOptions *)options overlayViewController:(UIViewController * __nullable)overlayViewController preparation:( void (^ __nullable)(void) )preparation completion:(void (^)(CodeLabUnityWindowHandle * __nullable, NSError * __nullable))completionHandler;

- (void)warmupWithCompletionHandler:(void (^)(void))completionHandler;

- (void)sendMessage:(NSString *)json;

- (void)addMessageListener:(id<CodeLabUnityInstanceMessageListener>)listener;

- (void)removeMessageListener:(id<CodeLabUnityInstanceMessageListener>)listener;

- (void)addRenderDelegate:(id<CodeLabUnityInstanceRenderDelegate>)delegate;

- (void)removeRenderDelegate:(id<CodeLabUnityInstanceRenderDelegate>)delegate;


@end

NS_ASSUME_NONNULL_END
