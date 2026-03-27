//
//  TrajectoryView.h
//  RobotSweeper
//
//  Created by 余莹 on 2019/4/16.
//  Copyright © 2019 余莹. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TrajectoryView : UIView
/** 本v缩放时坐标不变 所有的轨迹点在缩放时会同时计算缩放，但是线会根据1/倍数*/

@property (nonatomic,strong)NSMutableArray *pointsArr;//当前轨迹数据 元素为pointvaleu 该数据是用 已得到的xmpp数据进行坐标左上角为00点
@property (nonatomic,assign)CGFloat nowH;//当前高度
@property (nonatomic,assign)CGFloat nowW;//当前宽度
@property (nonatomic,assign)CGFloat mapScale;//当前倍数

- (void)upTraViewOfScrollViewZooming;
@end

NS_ASSUME_NONNULL_END
