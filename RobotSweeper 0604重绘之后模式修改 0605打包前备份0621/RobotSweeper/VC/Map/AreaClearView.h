//
//  AreaClearView.h
//  RobotSweeper
//
//  Created by Joey on 2018/4/27.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaClearView : UIView

@property (nonatomic,assign) CGRect imgRect;
@property (nonatomic,strong) UIImage *img;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,assign) CGFloat bottomHight;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *yesBtn;
@property (nonatomic,strong) UIView *backViewBottom;

- (instancetype)initWithFrame:(CGRect)frame
                      imgRext:(CGRect)imgRext
                    imgOfImgV:(UIImage *)img
                  bottomHight:(CGFloat)bottomH;
@end
