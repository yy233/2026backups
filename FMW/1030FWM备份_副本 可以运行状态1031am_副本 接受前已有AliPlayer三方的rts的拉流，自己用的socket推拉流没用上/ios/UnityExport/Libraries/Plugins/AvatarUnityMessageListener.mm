//
//  AvatarUnityMessageListener.m
//  AvatarUnityBridge
//
//  Created by Sr on 2022/11/17.
//

#import "AvatarUnityMessageListener.h"

@interface AvatarUnityMessageCenter()

@property (nonatomic, strong, readonly) NSHashTable *listeners;

@end

@implementation AvatarUnityMessageCenter

+ (AvatarUnityMessageCenter *)defaultCenter {
    static AvatarUnityMessageCenter *center;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            center = [[AvatarUnityMessageCenter alloc] initDefaultInstance];
        }
    });
    return center;
}

- (instancetype)initDefaultInstance {
    if (self = [super init]) {
        _listeners = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (void)addMessageListener:(id<AvatarUnityMessageListener>)listener {
    [_listeners addObject:listener];
}

- (void)removeMessageListener:(id<AvatarUnityMessageListener>)listener {
    [_listeners removeObject:listener];
}

@end

extern "C" {
    void sendMessageToAvatarApp(const char* message) {
        NSString *stringMessage = [NSString stringWithUTF8String:message];
        for (id<AvatarUnityMessageListener> listener in AvatarUnityMessageCenter.defaultCenter.listeners) {
            [listener didReceiveUnityMessage:stringMessage];
        }
    }
}
