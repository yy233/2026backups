//
//  DiscoverMainView.h
//  Socialize
//
//  Created by 余莹 on 2023/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiscoverTopView : UIView
//@property (nonatomic,assign) CGFloat topH;
@property (weak, nonatomic) IBOutlet UIButton *tuiJianBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *liveBtn;
+ (DiscoverTopView *)instaceThisViewSelf;
@end

NS_ASSUME_NONNULL_END
