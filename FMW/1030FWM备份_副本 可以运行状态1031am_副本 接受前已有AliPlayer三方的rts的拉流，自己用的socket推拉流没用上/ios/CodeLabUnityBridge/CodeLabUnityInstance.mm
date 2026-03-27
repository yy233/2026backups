//
//  CodeLabUnityInstance.m
//  CodeLabUnityBridge
//
//  Created by Sera on 2023/8/4.
//

#import "CodeLabUnityInstance.h"
#import <UnityFramework/UnityFramework.h>
#import <UnityFramework/AvatarUnityMessageListener.h>

@interface UIViewController (UnityStatusBar)

+ (void)codeLabUnity_patchUnityViewController;

@end

@implementation CodeLabUnityWindowPresentationOptions

- (instancetype)init {
    if (self = [super init]) {
        _transitionStyle = CodeLabUnityWindowTransitionStyleCoverVertical;
        _isAnimated = YES;
        _isVisible = YES;
    }
    return self;
}

@end

@interface CodeLabUnityWindowHandle ()

@property (nonatomic, copy) NSUUID *uuid;

- (instancetype)initWithUUID:(NSUUID *)uuid;

@end

@interface CodeLabUnityUnloadListener: NSObject <UnityFrameworkListener>

@property (nonatomic, copy) void (^unloadHandler)(void);

@end

@implementation CodeLabUnityUnloadListener

- (void)unityDidUnload:(NSNotification *)notification {
    NSAssert(NSThread.isMainThread, @"");
    if (self.unloadHandler) {
        self.unloadHandler();
    }
}

@end

@interface CodeLabUnityInstance() <AvatarUnityMessageListener>

@property (nonatomic, readonly) char **argv;
@property (nonatomic, readonly) int argc;

@property (nonatomic) BOOL isWarmingUp;
@property (nonatomic) BOOL warmedUp;

@property (nonatomic) BOOL isRunning;
@property (nonatomic) BOOL isUnloading;

@property (nonatomic, strong, readonly) NSMutableArray<void (^)(void)> *warmupCompletionHandlers;

@property (nonatomic, strong, readonly) NSHashTable *messageListeners;
@property (nonatomic, strong, readonly) NSHashTable *renderDelegates;

@property (nonatomic) CodeLabUnityWindowTransitionStyle activeTransitionStyle;

@property (nonatomic, strong) CodeLabUnityWindowHandle *activeWindowHandle;

@end

@implementation CodeLabUnityInstance

static UnityFramework *unityFramework = nil;
static UIWindow *hostWindow = nil;
static const struct mach_header_64 * executableHeader;
//static Class CodeLabUnityDirectMessagerClass;

+ (instancetype)sharedInstance {
    static CodeLabUnityInstance *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CodeLabUnityInstance alloc] initShared];
    });
    return instance;
}

+ (void)registerHostWindow:(UIWindow *)window executableHader:(nonnull const struct mach_header_64 *)header {
    hostWindow = window;
    executableHeader = header;
}

- (instancetype)initShared {
    if (self = [super init]) {
        NSAssert(hostWindow != nil, @"");
                
        NSURL *bundleURL = [NSBundle.mainBundle.bundleURL URLByAppendingPathComponent:@"/Frameworks/UnityFramework.framework"];
        NSBundle *unityBundle = [NSBundle bundleWithPath:bundleURL.path];
        [unityBundle load];
        UnityFramework *framework = [unityBundle.principalClass getInstance];
        [framework setExecuteHeader:executableHeader];
        [framework setDataBundleId:"com.unity3d.framework"];
        unityFramework = framework;
        
        [UIViewController codeLabUnity_patchUnityViewController];
        
        _isPaused = NO;
        
        _argc = 1;
        char *arg0 = (char *)malloc(1);
        arg0[0] = '\0';
        _argv = (char **)malloc(1);
        _argv[0] = arg0;
        
        _warmupCompletionHandlers = [NSMutableArray array];
        _messageListeners = [NSHashTable weakObjectsHashTable];
        _renderDelegates = [NSHashTable weakObjectsHashTable];
        [(AvatarUnityMessageCenter *)[NSClassFromString(@"AvatarUnityMessageCenter") defaultCenter] addMessageListener:self];
    }
    return self;
}

- (BOOL)isActive {
    return self.isRunning;
}

- (void)setIsPaused:(BOOL)isPaused {
    _isPaused = isPaused;
    [unityFramework pause:isPaused];
}

- (void)warmupWithCompletionHandler:(void (^)())completionHandler {
    NSAssert(NSThread.isMainThread, @"");
    
    if (!unityFramework) {
        completionHandler();
        return;
    }
    
    if (self.warmedUp) {
        completionHandler();
    } else {
        [self.warmupCompletionHandlers addObject:completionHandler];
        if (!self.isWarmingUp) {
            self.isWarmingUp = YES;
            CodeLabUnityUnloadListener *listener = [[CodeLabUnityUnloadListener alloc] init];
            __block id l = listener;
            [listener setUnloadHandler:^{
                for (__typeof(completionHandler) hander in self.warmupCompletionHandlers) {
                    hander();
                }
                [self.warmupCompletionHandlers removeAllObjects];
                l = nil;
                self.warmedUp = YES;
                self.isWarmingUp = NO;
            }];
            [unityFramework registerFrameworkListener:listener];
            [unityFramework runEmbeddedWithArgc:_argc argv:_argv appLaunchOpts:@{}];
            UIWindow *rootWindow = unityFramework.appController.window;
            rootWindow.hidden = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [unityFramework unloadApplication];
            });
        }
    }
}

- (void)presentUnityWindowWithOptions:(CodeLabUnityWindowPresentationOptions *)options overlayViewController:(UIViewController *)overlayViewController preparation:(void (^ _Nullable)())preparation completion:(void (^)(CodeLabUnityWindowHandle *, NSError *))completionHandler {
    NSAssert(NSThread.isMainThread, @"");
    
    if (!unityFramework) {
        completionHandler(nil, [NSError errorWithDomain:@"CodeLabUnityInstance" code:0 userInfo:@{NSLocalizedDescriptionKey: @"[内部错误] 3D渲染框架加载失败."}]);
        return;
    }
    
    if (self.isRunning || self.isUnloading) {
        completionHandler(nil, [NSError errorWithDomain:@"CodeLabUnityInstance" code:0 userInfo:@{NSLocalizedDescriptionKey: @"[内部错误] CodeLabUnityInstance is busy."}]);
        return;
    }
    
    self.isRunning = YES;
    self.isUnloading = NO;
    
    self.activeTransitionStyle = options.transitionStyle;
    
    [self warmupWithCompletionHandler:^{
        [unityFramework runEmbeddedWithArgc:self -> _argc argv: self -> _argv appLaunchOpts:@{}];
        self -> _isPaused = NO;
        
        if (preparation) {
            preparation();
        }
        UIViewController *unityViewController = unityFramework.appController.rootViewController;
        if (unityViewController && overlayViewController) {
            [unityViewController addChildViewController:overlayViewController];
            overlayViewController.view.frame = unityViewController.view.bounds;
            overlayViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [unityViewController.view addSubview:overlayViewController.view];
            [overlayViewController didMoveToParentViewController:unityViewController];
        }
        UIWindow *window = unityFramework.appController.window;
        CodeLabUnityWindowHandle *handle = [[CodeLabUnityWindowHandle alloc] initWithUUID:NSUUID.UUID];
        self.activeWindowHandle = handle;
        if (!options.isVisible) {
            window.hidden = YES;
            [hostWindow makeKeyAndVisible];
            completionHandler(handle, nil);
        } else {
            [self showWindowAnimated:options.isAnimated completion:^{
                completionHandler(handle, nil);
            }];
        }
    }];
}

- (void)dismissUnityWindowAnimated:(BOOL)animated completion:(void (^)(NSError * _Nullable))completionHandler {
    NSAssert(NSThread.isMainThread, @"");
    if (self.isUnloading || !self.isRunning) {
        completionHandler([NSError errorWithDomain:@"AvatarUnityInstance" code:1 userInfo:@{NSLocalizedDescriptionKey: @"[内部错误] 没有可以关闭的窗口"}]);
        return;
    }
    
    NSString *willUnloadMessage = @"{\"messageType\":1007,\"content\":{}}";
    NSLog(@"%@",willUnloadMessage);
    [self sendMessage:willUnloadMessage];
    
    self.isUnloading = YES;
    self.activeWindowHandle = nil;
    
    [unityFramework pause:false];
    _isPaused = NO;
    
    CodeLabUnityUnloadListener *listener = [[CodeLabUnityUnloadListener alloc] init];
    __block id l = listener;
    [listener setUnloadHandler:^{
        l = nil;
        [self hideWindowAnimated:animated completion:^{
            for (UIViewController *children in unityFramework.appController.rootViewController.childViewControllers) {
                [children willMoveToParentViewController:nil];
                [children.view removeFromSuperview];
                [children removeFromParentViewController];
            }
            
            self.isRunning = NO;
            self.isUnloading = NO;
            
            completionHandler(nil);
        }];
    }];
    [unityFramework.appController.rootViewController dismissViewControllerAnimated:animated completion:nil];
    [unityFramework registerFrameworkListener:listener];
    [unityFramework unloadApplication];
}

- (void)sendMessage:(NSString *)json {
    NSAssert(NSThread.isMainThread, @"");
    if (self.isRunning && !self.isUnloading) {
        [unityFramework sendMessageToGOWithName:"Avatar"
                                   functionName:"receiveNativeMessage"
                                        message:json.UTF8String];
    } else {
        NSLog(@"Unity Message Ignored: %@", json);
    }
}

- (void)didReceiveUnityMessage:(NSString *)message {
    NSLog(@"didReceiveUnityMessage: %@", message);

    for (id<CodeLabUnityInstanceMessageListener> l in _messageListeners) {
        [l didReceiveUnityMessage:message];
    }
}

//- (void)handleFrameResolved:(CVPixelBufferRef)frame atTime:(CMTime)time {
//    CVPixelBufferRetain(frame);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        for (id<CodeLabUnityInstanceRenderDelegate> l in self -> _renderDelegates) {
//            [l didRenderFrame:frame atTime:time];
//        }
//        CVPixelBufferRelease(frame);
//    });
//}

- (void)addMessageListener:(id<CodeLabUnityInstanceMessageListener>)listener {
    [_messageListeners addObject:listener];
}

- (void)removeMessageListener:(id<CodeLabUnityInstanceMessageListener>)listener {
    [_messageListeners removeObject:listener];
}

- (void)addRenderDelegate:(id<CodeLabUnityInstanceRenderDelegate>)delegate {
    [_renderDelegates addObject:delegate];
}

- (void)removeRenderDelegate:(id<CodeLabUnityInstanceRenderDelegate>)delegate {
    [_renderDelegates removeObject:delegate];
}

- (void)hideWindowAnimated:(BOOL)animated completion:(void (^)())completion {
    UIWindow *window = unityFramework.appController.window;
    
    if (!window) {
        completion();
        return;
    }
    
    if (window.isHidden) {
        completion();
        return;
    }
    CGRect originalFrame = UIScreen.mainScreen.bounds;
    CGRect frame = originalFrame;
    switch (self.activeTransitionStyle) {
        case CodeLabUnityWindowTransitionStyleCoverVertical:{
            frame.origin.y = window.frame.size.height;
        } break;
        case CodeLabUnityWindowTransitionStyleCoverVerticalFromTop: {
            frame.origin.y = -window.frame.size.height;
        }break;
        case CodeLabUnityWindowTransitionStylePush: {
            frame.origin.x = window.frame.size.width;
        } break;
        default: break;
    }
    [UIView animateWithDuration:animated ? 0.53 : 0.0 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        window.frame = frame;
    } completion:^(BOOL finished) {
        window.frame = originalFrame;
        window.hidden = YES;
        [hostWindow makeKeyAndVisible];
        completion();
    }];
}

- (void)showWindowAnimated:(BOOL)animated completion:(void (^)())completion {
    NSAssert(self.isRunning, @"");
    if (!self.isRunning) {
        completion();
        return;
    }
    UIWindow *window = unityFramework.appController.window;
    CGRect originalFrame = UIScreen.mainScreen.bounds;
    CGRect hiddenFrame = originalFrame;
    switch (self.activeTransitionStyle) {
        case CodeLabUnityWindowTransitionStyleCoverVertical:{
            hiddenFrame.origin.y = originalFrame.size.height;
        } break;
        case CodeLabUnityWindowTransitionStyleCoverVerticalFromTop:{
            hiddenFrame.origin.y = -originalFrame.size.height;
        } break;
        case CodeLabUnityWindowTransitionStylePush: {
            hiddenFrame.origin.x = originalFrame.size.width;
        } break;
        default: break;
    }
    [window makeKeyAndVisible];
    window.frame = hiddenFrame;
    if (animated) {
        [UIView animateWithDuration:0.53 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            window.frame = originalFrame;
        } completion:^(BOOL finished) {
            completion();
        }];
    } else {
        window.frame = originalFrame;
        completion();
    }
}

@end


@implementation CodeLabUnityWindowHandle

- (instancetype)initWithUUID:(NSUUID *)uuid {
    if (self = [super init]) {
        _uuid = uuid;
    }
    return self;
}

- (BOOL)isPaused {
    return CodeLabUnityInstance.sharedInstance.isPaused;
}

- (void)setIsPaused:(BOOL)isPaused {
    NSAssert(CodeLabUnityInstance.sharedInstance.activeWindowHandle == self, @"");
    if (CodeLabUnityInstance.sharedInstance.activeWindowHandle != self) {
        return;
    }
    [CodeLabUnityInstance.sharedInstance setIsPaused:isPaused];
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(NSError * _Nullable))completionHandler {
    NSAssert(CodeLabUnityInstance.sharedInstance.activeWindowHandle == self, @"");
    if (CodeLabUnityInstance.sharedInstance.activeWindowHandle != self) {
        completionHandler([NSError errorWithDomain:@"AvatarUnityInstance" code:2 userInfo:@{NSLocalizedDescriptionKey: @"[内部错误] 试图关闭不属于 AvatarUnityWindowHandle 的窗口"}]);
        return;
    }
    [CodeLabUnityInstance.sharedInstance dismissUnityWindowAnimated:animated completion:completionHandler];
}

- (void)showAnimated:(BOOL)animated completion:(void (^)(NSError * _Nullable))completion {
    NSAssert(CodeLabUnityInstance.sharedInstance.activeWindowHandle == self, @"");
    if (CodeLabUnityInstance.sharedInstance.activeWindowHandle != self) {
        completion([NSError errorWithDomain:@"AvatarUnityInstance" code:2 userInfo:@{NSLocalizedDescriptionKey: @"[内部错误] 试图展示不属于 AvatarUnityWindowHandle 的窗口"}]);
        return;
    }
    [CodeLabUnityInstance.sharedInstance showWindowAnimated:animated completion:^{
        completion(nil);
    }];
}

- (void)hideAnimated:(BOOL)animated completion:(void (^)(NSError * _Nullable))completion {
    NSAssert(CodeLabUnityInstance.sharedInstance.activeWindowHandle == self, @"");
    if (CodeLabUnityInstance.sharedInstance.activeWindowHandle != self) {
        completion([NSError errorWithDomain:@"AvatarUnityInstance" code:2 userInfo:@{NSLocalizedDescriptionKey: @"[内部错误] 试图隐藏不属于 AvatarUnityWindowHandle 的窗口"}]);
        return;
    }
    [CodeLabUnityInstance.sharedInstance hideWindowAnimated:animated completion:^{
        completion(nil);
    }];
}

@end

#import <objc/runtime.h>

static void class_swizzleSelector(Class _class, SEL originalSelector, SEL newSelector)
{
    Method origMethod = class_getInstanceMethod(_class, originalSelector);
    Method newMethod = class_getInstanceMethod(_class, newSelector);
    if(class_addMethod(_class, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(_class, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@implementation UIViewController (UnityStatusBar)

- (BOOL)prefersStatusBarHidden_avatarUnity {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle_avatarUnity {
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)childViewControllerForStatusBarHidden_avatarUnity {
    return self.childViewControllers.lastObject;
}

- (UIViewController *)childViewControllerForStatusBarStyle_avatarUnity {
    return self.childViewControllers.lastObject;
}

- (void)addChildViewController_avatarUnity:(UIViewController *)childController {
    [self addChildViewController_avatarUnity:childController];
    [self setNeedsStatusBarAppearanceUpdate];
}

+ (void)codeLabUnity_patchUnityViewController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        class_swizzleSelector(NSClassFromString(@"UnityViewControllerBase"), @selector(prefersStatusBarHidden), @selector(prefersStatusBarHidden_avatarUnity));
        class_swizzleSelector(NSClassFromString(@"UnityViewControllerBase"), @selector(preferredStatusBarStyle), @selector(preferredStatusBarStyle_avatarUnity));
        class_swizzleSelector(NSClassFromString(@"UnityViewControllerBase"), @selector(childViewControllerForStatusBarHidden), @selector(childViewControllerForStatusBarHidden_avatarUnity));
        class_swizzleSelector(NSClassFromString(@"UnityViewControllerBase"), @selector(childViewControllerForStatusBarStyle), @selector(childViewControllerForStatusBarStyle_avatarUnity));
        class_swizzleSelector(NSClassFromString(@"UnityViewControllerBase"), @selector(addChildViewController:), @selector(addChildViewController_avatarUnity:));
    });
}

@end

