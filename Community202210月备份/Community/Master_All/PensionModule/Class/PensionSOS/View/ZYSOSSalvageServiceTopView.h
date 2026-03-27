//
//  ZYSOSSalvageServiceTopView.h
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSOSSalvageServiceTopViewDelegate <NSObject>

//用按住状态 处理这段时期的 语音实时转换成文字
- (void)voiceButtonEventBegin;
- (void)voiceButtonEventEnd;
@end

@interface ZYSOSSalvageServiceTopView : UIView

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (nonatomic, weak) id<ZYSOSSalvageServiceTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
