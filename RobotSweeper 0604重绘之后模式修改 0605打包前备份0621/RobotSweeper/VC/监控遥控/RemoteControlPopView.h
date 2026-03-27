//
//  RemoteControlPopView.h
//  RobotSweeper
//
//  Created by 余莹 on 2019/3/18.
//  Copyright © 2019 余莹. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RemoteControlPopView : UIView
- (void)initData;
- (void)initView;
- (void)getxmppUserStatusMsg:(NSString *)message;
- (void)getxmppMsg:(NSString*)message;
@end

NS_ASSUME_NONNULL_END
