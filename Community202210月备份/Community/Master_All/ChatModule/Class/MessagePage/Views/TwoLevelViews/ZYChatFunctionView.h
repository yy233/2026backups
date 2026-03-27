//
//  ZYChatFunctionView.h
//  Community
//
//  Created by ZY on 2021/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ZYChatFunctionViewDelegate_Touch_photo = 0,
    ZYChatFunctionViewDelegate_Touch_camera,
    ZYChatFunctionViewDelegate_Touch_position,
    ZYChatFunctionViewDelegate_Touch_heimingdan,
} ZYChatFunctionViewDelegate_Touch_IndexType;

@protocol ZYChatFunctionViewDelegate <NSObject>

- (void)collectionViewCellSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZYChatFunctionView : UIView

@property (nonatomic, weak) id<ZYChatFunctionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
