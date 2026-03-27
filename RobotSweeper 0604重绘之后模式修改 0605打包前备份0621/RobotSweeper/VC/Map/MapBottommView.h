//
//  MapBottomView.h
//  RobotSweeper
//
//  Created by Joey on 2018/5/7.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapBottommView : UIView
@property (nonatomic,strong)UIButton *clearnBtn;
@property (nonatomic,strong)UIButton *chargeBtn;
@property (nonatomic,strong)UIButton *yuYueBtn;
@property (nonatomic,strong)UIButton *xuNiQiangBtn;
@property (nonatomic,strong)UIButton *jiankongBtn;
@property (nonatomic,strong)UILabel *clearnL;
@property (nonatomic,strong)UILabel *chargeL;
@property (nonatomic,strong)UILabel *yuYueL;
@property (nonatomic,strong)UILabel *xuNiQiangL;
@property (nonatomic,strong)UILabel *jiankongL;

@property (nonatomic,strong)UITapGestureRecognizer *gesOfclearnL;
@property (nonatomic,strong)UITapGestureRecognizer *gesOfchargeL;
@property (nonatomic,strong)UITapGestureRecognizer *gesOfyuYueL;
@property (nonatomic,strong)UITapGestureRecognizer *gesOfxuNiQiangL;
@property (nonatomic,strong)UITapGestureRecognizer *gesOfjiankongL;
-(void)getYeShuOfCleanBigOtherSamall;
@end
