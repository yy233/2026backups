//
//  MapBottomView.m
//  RobotSweeper
//
//  Created by Joey on 2018/5/7.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "MapBottommView.h"

@implementation MapBottommView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.clearnBtn];
        [self addSubview:self.chargeBtn];
        [self addSubview:self.yuYueBtn];
        [self addSubview:self.xuNiQiangBtn];
        [self addSubview:self.jiankongBtn];
        
        [self addSubview:self.clearnL];
        [self addSubview:self.chargeL];
        [self addSubview:self.yuYueL];
        [self addSubview:self.xuNiQiangL];
        [self addSubview:self.jiankongL];
        [self getYeShuOfCleanBigOtherSamall];//0115修改
//        [self getNewYueshuAllOne];//一：一大小的5个按钮
//        [self getNewYueshuOneOne];//中间大两边小的按钮
//        [self getNewYueshu];//中间过宽 占比过界的约束
//        [self getNewYuesu];//图片都很大的1:1展示 文本应该显示不够高
//           [self setShangXia];//空的UI
        
        
        
        //新增手势0121
        [self gesInitOfV];
        
    }
    return self;
}

#pragma mark -- 手势

- (void)gesInitOfV{
    
    _gesOfclearnL = [[UITapGestureRecognizer alloc]init];
    _gesOfclearnL.numberOfTouchesRequired = 1;
    _gesOfclearnL.numberOfTapsRequired = 1;
    [_clearnL addGestureRecognizer:_gesOfclearnL];
    
    
    _gesOfchargeL = [[UITapGestureRecognizer alloc]init];
    _gesOfchargeL.numberOfTouchesRequired = 1;
    _gesOfchargeL.numberOfTapsRequired = 1;
    [_chargeL addGestureRecognizer:_gesOfchargeL];
    
    _gesOfyuYueL = [[UITapGestureRecognizer alloc]init];
    _gesOfyuYueL.numberOfTouchesRequired = 1;
    _gesOfyuYueL.numberOfTapsRequired = 1;
    [_yuYueL addGestureRecognizer:_gesOfyuYueL];
    
    _gesOfxuNiQiangL = [[UITapGestureRecognizer alloc]init];
    _gesOfxuNiQiangL.numberOfTouchesRequired = 1;
    _gesOfxuNiQiangL.numberOfTapsRequired = 1;
    [_xuNiQiangL addGestureRecognizer:_gesOfxuNiQiangL];
    
    _gesOfjiankongL = [[UITapGestureRecognizer alloc]init];
    _gesOfjiankongL.numberOfTouchesRequired = 1;
    _gesOfjiankongL.numberOfTapsRequired = 1;
    [_jiankongL addGestureRecognizer:_gesOfjiankongL];

}
#pragma mark -- 约束

//中间图标大两边小的约束 label中英匹配 0115新增
-(void)getYeShuOfCleanBigOtherSamall{
    //国际化的宽度修改
    BOOL isLongView = NO;
    if(_chargeL.text.length>3){
        isLongView = YES;
    }
    
    
    [_clearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-15);//同水平线顶高不同
        make.centerX.equalTo(self);
         make.height.equalTo(self.mas_height).offset(-55);//用10的高度差 20图片过大
        make.width.offset(Y_mainW*0.18);
    }];
    [_chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);
        make.height.equalTo(self.mas_height).offset(-65);
        make.width.offset(Y_mainW*0.18);
         make.left.equalTo(self.mas_left).offset(Y_mainW*0.05);
    }];
    [_yuYueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-65);
        make.width.offset(Y_mainW*0.18);
        make.left.equalTo(_chargeBtn.mas_right);
    }];
    
    [_xuNiQiangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-65);;
        make.width.offset(Y_mainW*0.18);
        make.left.equalTo(_clearnBtn.mas_right);
    }];
    [_jiankongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-65);;
        make.width.offset(Y_mainW*0.18);
        make.right.equalTo(self.mas_right).offset(-Y_mainW*0.05);
    }];
    
    //
    [_clearnL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_clearnBtn);
        make.width.equalTo(_clearnBtn.mas_width);
         if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(_clearnBtn.mas_bottom).offset(10);
        }else{
            make.height.offset(36);
            make.top.equalTo(_clearnBtn.mas_bottom).offset(2);
        }
    }];
    [_chargeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_chargeBtn);
        make.width.equalTo(_chargeBtn.mas_width);
         if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(_chargeBtn.mas_bottom).offset(10);
            
        }else{
            make.height.offset(36);
            make.top.equalTo(_chargeBtn.mas_bottom).offset(2);
            
            
        }
    }];
    [_yuYueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_yuYueBtn);
        make.width.equalTo(_yuYueBtn.mas_width);
         if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(_yuYueBtn.mas_bottom).offset(10);
        }else{
            make.height.offset(36);
            make.top.equalTo(_yuYueBtn.mas_bottom).offset(2);
            
        }
    }];
    
    [_xuNiQiangL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_xuNiQiangBtn);
        make.width.equalTo(_xuNiQiangBtn.mas_width);
 
        if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(_xuNiQiangBtn.mas_bottom).offset(10);
            
        }else{
            make.height.offset(36);
            make.top.equalTo(_xuNiQiangBtn.mas_bottom).offset(2);
        }
        
    }];
    [_jiankongL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_jiankongBtn);
        make.width.equalTo(_jiankongBtn.mas_width);
 
        if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(_jiankongBtn.mas_bottom).offset(10);
        }else{
            make.height.offset(36);
            make.top.equalTo(_jiankongBtn.mas_bottom).offset(2);
            
        }
    }];
    
    
}
//4一比一的图标
- (void)getNewYueshuAllOne{
    //国际化的宽度修改
    BOOL isLongView = NO;
    if(_chargeL.text.length>3){
        isLongView = YES;
    }
    
    [_clearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);
        make.centerX.equalTo(self);
        make.height.equalTo(self.mas_height).offset(-65);
        make.width.offset(Y_mainW*0.18);
    }];
    [_chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);
        make.height.equalTo(self.mas_height).offset(-65);
        make.width.offset(Y_mainW*0.18);
        //        make.left.equalTo(self.mas_left).offset(Y_mainW*0.1);
        make.left.equalTo(self.mas_left).offset(Y_mainW*0.05);
    }];
    [_yuYueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-65);;
        make.width.offset(Y_mainW*0.18);
        make.left.equalTo(_chargeBtn.mas_right);
    }];
    
    [_xuNiQiangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-65);;
        make.width.offset(Y_mainW*0.18);
        make.left.equalTo(_clearnBtn.mas_right);
    }];
    [_jiankongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-65);;
        make.width.offset(Y_mainW*0.18);
        make.right.equalTo(self.mas_right).offset(-Y_mainW*0.05);
    }];
    
    
    //
    [_clearnL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_clearnBtn);
        make.width.equalTo(_clearnBtn.mas_width);
//        make.height.offset(25);
        if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(_clearnBtn.mas_bottom).offset(10);
        }else{
            make.height.offset(36);
            make.top.equalTo(_clearnBtn.mas_bottom).offset(2);
        }
        
    }];
    [_chargeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_chargeBtn);
        make.width.equalTo(_chargeBtn.mas_width);
//        make.height.offset(25);
        if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(_chargeBtn.mas_bottom).offset(10);

        }else{
            make.height.offset(36);
            make.top.equalTo(_chargeBtn.mas_bottom).offset(2);

            
        }
    }];
    [_yuYueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_yuYueBtn);
        make.width.equalTo(_yuYueBtn.mas_width);
//        make.height.offset(25);
        if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(_yuYueBtn.mas_bottom).offset(10);
        }else{
            make.height.offset(36);
            make.top.equalTo(_yuYueBtn.mas_bottom).offset(2);

        }
    }];
    
    [_xuNiQiangL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_xuNiQiangBtn);
        make.width.equalTo(_xuNiQiangBtn.mas_width);
//        make.height.offset(25);
        
        if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(_xuNiQiangBtn.mas_bottom).offset(10);
            
        }else{
            make.height.offset(36);
            make.top.equalTo(_xuNiQiangBtn.mas_bottom).offset(2);
        }
        
    }];
    [_jiankongL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_jiankongBtn);
        make.width.equalTo(_jiankongBtn.mas_width);
//        make.height.offset(25);
       
        if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(_jiankongBtn.mas_bottom).offset(10);
        }else{
            make.height.offset(36);
            make.top.equalTo(_jiankongBtn.mas_bottom).offset(2);
            
        }
    }];
    
}
//3套图标
- (void)getNewYueshuOneOne{
    [_clearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);
        make.centerX.equalTo(self);
        make.height.equalTo(self.mas_height).offset(-45);
        make.width.offset(Y_mainW*0.18);
    }];
    [_chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);
        make.height.equalTo(self.mas_height).offset(-65);
        make.width.offset(Y_mainW*0.18);
        //        make.left.equalTo(self.mas_left).offset(Y_mainW*0.1);
        make.left.equalTo(self.mas_left).offset(Y_mainW*0.05);
    }];
    [_yuYueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-65);;
        make.width.offset(Y_mainW*0.18);
        make.left.equalTo(_chargeBtn.mas_right);
    }];
    
    [_xuNiQiangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-65);;
        make.width.offset(Y_mainW*0.18);
        make.left.equalTo(_clearnBtn.mas_right);
    }];
    [_jiankongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-65);;
        make.width.offset(Y_mainW*0.18);
        make.right.equalTo(self.mas_right).offset(-Y_mainW*0.05);
    }];
    
    
    //
    [_clearnL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_clearnBtn);
        make.width.equalTo(_clearnBtn.mas_width);
        make.height.offset(25);
        make.top.equalTo(_clearnBtn.mas_bottom);
    }];
    [_chargeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_chargeBtn);
        make.width.equalTo(_chargeBtn.mas_width);
        make.height.offset(25);
        make.top.equalTo(_chargeBtn.mas_bottom).offset(10);
    }];
    [_yuYueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_yuYueBtn);
        make.width.equalTo(_yuYueBtn.mas_width);
        make.height.offset(25);
        make.top.equalTo(_yuYueBtn.mas_bottom).offset(10);
    }];
    
    [_xuNiQiangL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_xuNiQiangBtn);
        make.width.equalTo(_xuNiQiangBtn.mas_width);
        make.height.offset(25);
        make.top.equalTo(_xuNiQiangBtn.mas_bottom).offset(10);
        
    }];
    [_jiankongL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_jiankongBtn);
        make.width.equalTo(_jiankongBtn.mas_width);
        make.height.offset(25);
        make.top.equalTo(_jiankongBtn.mas_bottom).offset(10);
    }];
}
//2套图标
- (void)getNewYueshu{
    [_clearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);
        make.centerX.equalTo(self);
        make.height.equalTo(self.mas_height).offset(-45);
        make.width.offset(Y_mainW*0.25);
    }];
    [_chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);
        make.height.equalTo(self.mas_height).offset(-65);
        make.width.offset(Y_mainW*0.15);
//        make.left.equalTo(self.mas_left).offset(Y_mainW*0.1);
        make.left.equalTo(self.mas_left).offset(Y_mainW*0.06);
    }];
    [_yuYueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-65);;
        make.width.offset(Y_mainW*0.15);
        make.left.equalTo(_chargeBtn.mas_right);
        make.right.equalTo(_clearnBtn.mas_left).offset(Y_mainW*0.075);
    }];
    
    [_xuNiQiangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-65);;
        make.width.offset(Y_mainW*0.15);
        make.left.equalTo(_clearnBtn.mas_right).offset(-Y_mainW*0.075);
    }];
    [_jiankongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-65);;
        make.width.offset(Y_mainW*0.15);
//        make.left.equalTo(_xuNiQiangBtn.mas_right);
         make.right.equalTo(self.mas_right).offset(-Y_mainW*0.06);
    }];
    
    
    //
    [_clearnL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_clearnBtn);
        make.width.equalTo(_clearnBtn.mas_width);
        make.height.offset(25);
        make.top.equalTo(_clearnBtn.mas_bottom);
    }];
    [_chargeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_chargeBtn);
        make.width.equalTo(_chargeBtn.mas_width);
        make.height.offset(25);
        make.top.equalTo(_chargeBtn.mas_bottom).offset(10);
    }];
    [_yuYueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_yuYueBtn);
        make.width.equalTo(_yuYueBtn.mas_width);
        make.height.offset(25);
        make.top.equalTo(_yuYueBtn.mas_bottom).offset(10);
    }];
    
    [_xuNiQiangL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_xuNiQiangBtn);
        make.width.equalTo(_xuNiQiangBtn.mas_width);
        make.height.offset(25);
        make.top.equalTo(_xuNiQiangBtn.mas_bottom).offset(10);
        
    }];
    [_jiankongL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_jiankongBtn);
        make.width.equalTo(_jiankongBtn.mas_width);
        make.height.offset(25);
        make.top.equalTo(_jiankongBtn.mas_bottom).offset(10);
    }];
}
//1套图标
- (void)getNewYuesu{
    [_clearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);
        make.centerX.equalTo(self);
        make.height.equalTo(self.mas_height).offset(-45);
        make.width.offset(Y_mainW*0.3);
    }];
    [_chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-45);;
        make.width.offset(Y_mainW*0.15);
        make.left.equalTo(self.mas_left).offset(Y_mainW*0.1);
    }];
    [_yuYueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-45);;
        make.width.offset(Y_mainW*0.15);
        make.left.equalTo(_chargeBtn.mas_right);
        make.right.equalTo(_clearnBtn.mas_left);
    }];
    
    [_xuNiQiangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-45);;
        make.width.offset(Y_mainW*0.15);
        make.left.equalTo(_clearnBtn.mas_right);
    }];
    [_jiankongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-10);;
        make.height.equalTo(self.mas_height).offset(-45);;
        make.width.offset(Y_mainW*0.15);
        make.left.equalTo(_xuNiQiangBtn.mas_right);
    }];
    
    
    //
    [_clearnL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_clearnBtn);
        make.width.equalTo(_clearnBtn.mas_width);
        make.height.offset(25);
        make.top.equalTo(_clearnBtn.mas_bottom);
    }];
    [_chargeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_chargeBtn);
        make.width.equalTo(_chargeBtn.mas_width);
        make.height.offset(25);
        make.top.equalTo(_chargeBtn.mas_bottom);
    }];
    [_yuYueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_yuYueBtn);
        make.width.equalTo(_yuYueBtn.mas_width);
        make.height.offset(25);
        make.top.equalTo(_yuYueBtn.mas_bottom);
    }];
    
    [_xuNiQiangL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_xuNiQiangBtn);
        make.width.equalTo(_xuNiQiangBtn.mas_width);
        make.height.offset(25);
        make.top.equalTo(_xuNiQiangBtn.mas_bottom);

    }];
    [_jiankongL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_jiankongBtn);
        make.width.equalTo(_jiankongBtn.mas_width);
        make.height.offset(25);
        make.top.equalTo(_jiankongBtn.mas_bottom);
    }];
    
}

//旧时用一个控件btn的imgview和title，现不用.
- (void)setShangXia{
    //回充
    _clearnBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_clearnBtn setTitleEdgeInsets:UIEdgeInsetsMake(_clearnBtn.imageView.frame.size.height+10 ,-_clearnBtn.imageView.frame.size.width, 0.0,0.0)];
    [_clearnBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0,0.0, -_clearnBtn.titleLabel.bounds.size.width)];
    
    //回充
    _chargeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_chargeBtn setTitleEdgeInsets:UIEdgeInsetsMake(_chargeBtn.imageView.frame.size.height+10 ,-_chargeBtn.imageView.frame.size.width, 0.0,0.0)];
    [_chargeBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0,20, -_chargeBtn.titleLabel.bounds.size.width)];
    //预约
    _yuYueBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_yuYueBtn setTitleEdgeInsets:UIEdgeInsetsMake(_yuYueBtn.imageView.frame.size.height+10 ,-_yuYueBtn.imageView.frame.size.width, 0.0,0.0)];
    [_yuYueBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0,20, -_yuYueBtn.titleLabel.bounds.size.width)];
    
    //虚拟墙
   
    _xuNiQiangBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//使图片和文字水平居中显示
    _xuNiQiangBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_xuNiQiangBtn setTitleEdgeInsets:UIEdgeInsetsMake(_xuNiQiangBtn.imageView.frame.size.height+10 ,-_xuNiQiangBtn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [_xuNiQiangBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0,20,-_yuYueBtn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    
    //监控
    _jiankongBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _jiankongBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_jiankongBtn setTitleEdgeInsets:UIEdgeInsetsMake(_jiankongBtn.imageView.frame.size.height+10 ,-_jiankongBtn.imageView.frame.size.width, 0.0,0.0)];
    [_jiankongBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0.0,20.0, -_jiankongBtn.titleLabel.bounds.size.width)];
    
    
}
#pragma mark -- getter
- (UIButton *)clearnBtn{
    if (!_clearnBtn) {
        _clearnBtn.backgroundColor = [UIColor brownColor];
        _clearnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
//        [_clearnBtn setTitle:@"清扫" forState:UIControlStateNormal];
        [_clearnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _clearnBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _clearnBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_clearnBtn setImage:[UIImage imageNamed:@"2qingsao_black"] forState:UIControlStateNormal];
//        [_clearnBtn setImage:[UIImage imageNamed:@"2zanting_black"] forState:UIControlStateSelected];
//
//        [_clearnBtn setImage:[UIImage imageNamed:@"2qingsao_color"] forState:UIControlStateHighlighted];
//        [_clearnBtn setImage:[UIImage imageNamed:@"2zanting_color"] forState:UIControlStateHighlighted|UIControlStateSelected];
        
        _clearnBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //适配三合一
        
         //回充按钮包含灰色按钮适应
        [_clearnBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_qingsao"] forState:UIControlStateNormal];
        [_clearnBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_zanting"] forState:UIControlStateSelected];
        
        [_clearnBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_qingsao"] forState:UIControlStateHighlighted];
        [_clearnBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_zanting"] forState:UIControlStateHighlighted|UIControlStateSelected];
        
        _clearnBtn.tag = TAG_BTN_B+0;

    }
    return _clearnBtn;
}
- (UIButton *)chargeBtn{
    if (!_chargeBtn) {
         _chargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   
//        [_chargeBtn setTitle:@"回充" forState:UIControlStateNormal];
        [_chargeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         _chargeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
         _chargeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_chargeBtn setImage:[UIImage imageNamed:@"2chongdian_black"] forState:UIControlStateNormal];
//        [_chargeBtn setImage:[UIImage imageNamed:@"2zanting_black"] forState:UIControlStateSelected];
//        [_chargeBtn setImage:[UIImage imageNamed:@"2chongdian_color"] forState:UIControlStateHighlighted];
//         [_chargeBtn setImage:[UIImage imageNamed:@"2chongdian_color"] forState:UIControlStateHighlighted|UIControlStateSelected];
//       [_chargeBtn setImage:[UIImage imageNamed:@"2chongdian_black"] forState:UIControlStateHighlighted];
//       [_chargeBtn setImage:[UIImage imageNamed:@"2zanting_black"] forState:UIControlStateHighlighted|UIControlStateSelected];
        _chargeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        //三合一
        
         //回充按钮包含灰色按钮适应
        
        [_chargeBtn setImage:[[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_huichong"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_chargeBtn setImage:[[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_huichong_an"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
         [_chargeBtn setImage:[[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_huichong"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
        [_chargeBtn setImage:[[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_huichong_an"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted|UIControlStateSelected];
    
        _chargeBtn.tag = TAG_BTN_B+1;
    }
    return _chargeBtn;
}
- (UIButton *)yuYueBtn{
    if (!_yuYueBtn) {
        _yuYueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_yuYueBtn setTitle:@"预约" forState:UIControlStateNormal];
        [_yuYueBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       
        _yuYueBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _yuYueBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_yuYueBtn setImage:[UIImage imageNamed:@"2dingshi_black"] forState:UIControlStateNormal];
//        [_yuYueBtn setImage:[UIImage imageNamed:@"2dingshi_color"] forState:UIControlStateHighlighted];
        _yuYueBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        //三合一
        [_yuYueBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_yuyue"] forState:UIControlStateNormal];
        [_yuYueBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_yuyue_an"] forState:UIControlStateHighlighted];
        _yuYueBtn.tag = TAG_BTN_B+2;
    }
    return _yuYueBtn;
}
- (UIButton *)xuNiQiangBtn{
    if (!_xuNiQiangBtn) {
        _xuNiQiangBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
//        _xuNiQiangBtn.backgroundColor = [UIColor redColor];
        _xuNiQiangBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [_xuNiQiangBtn setTitle:@"虚拟墙" forState:UIControlStateNormal];
        [_xuNiQiangBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      
        _xuNiQiangBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_xuNiQiangBtn setImage:[UIImage imageNamed:@"2xuniqiang_black"] forState:UIControlStateNormal];
//        [_xuNiQiangBtn setImage:[UIImage imageNamed:@"2xuniqiang_color"] forState:UIControlStateSelected];
//        [_xuNiQiangBtn setImage:[UIImage imageNamed:@"2xuniqiang_color"] forState:UIControlStateHighlighted];
//        [_xuNiQiangBtn setImage:[UIImage imageNamed:@"2xuniqiang_color"] forState:UIControlStateHighlighted|UIControlStateSelected];
//
//        [_xuNiQiangBtn setImage:[UIImage imageNamed:@"z_xuniqiang_hui"] forState:UIControlStateSelected];
        _xuNiQiangBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //三合一
        [_xuNiQiangBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_xuniqiang"] forState:UIControlStateNormal];
        [_xuNiQiangBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_xuniqiang_an"] forState:UIControlStateSelected];
        [_xuNiQiangBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_xuniqiang_an"] forState:UIControlStateHighlighted];
        [_xuNiQiangBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_xuniqiang_an"] forState:UIControlStateHighlighted|UIControlStateSelected];
        
        _xuNiQiangBtn.tag = TAG_BTN_B+3;
    }
    return _xuNiQiangBtn;
}
- (UIButton *)jiankongBtn{
    if (!_jiankongBtn) {
        _jiankongBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
//         [_jiankongBtn setTitle:@"监控" forState:UIControlStateNormal];
         [_jiankongBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _jiankongBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _jiankongBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_jiankongBtn setImage:[UIImage imageNamed:@"2duankai_black"] forState:UIControlStateNormal];
//        [_jiankongBtn setImage:[UIImage imageNamed:@"2duankai_color"] forState:UIControlStateHighlighted];
        _jiankongBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //三合一 //更换坚果为蓝色的主题 图片部分也要if
        if([[DataManager shareDataManager].appNowProductTypeNumStr isEqualToString:@"01"] || [[MapVcGetUpXml getDeviceEqSerial] isEqualToString:@"310"]){
            [_jiankongBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_jiankong"] forState:UIControlStateNormal];
            [_jiankongBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_jiankong_an"] forState:UIControlStateHighlighted];
        }else{
            [_jiankongBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_yaokong"] forState:UIControlStateNormal];
            [_jiankongBtn setImage:[SkinManager skin_imageWithTypeAndNameWithImageName:@"mapmmv_yaokong_an"] forState:UIControlStateHighlighted];
        }
       
        _jiankongBtn.tag = TAG_BTN_B+4;
    }
    return _jiankongBtn;
}


#pragma mark -- get
- (UILabel *)clearnL{
    if (!_clearnL) {
        _clearnL = [[UILabel alloc]init];
        _clearnL.text = NSLocalizedString(@"清扫",nil);
        _clearnL.textAlignment = NSTextAlignmentCenter;
        _clearnL.font = [UIFont systemFontOfSize:12];
        _clearnL.numberOfLines = 0;
        _clearnL.tag = TAG_BTN_B+0;//tag新增 用于点击事件 0121
        _clearnL.userInteractionEnabled = YES;
    }
  
    return _clearnL;
}

- (UILabel *)chargeL{
    if (!_chargeL) {
        _chargeL = [[UILabel alloc]init];
        _chargeL.text = NSLocalizedString(@"回充",nil);
        _chargeL.textAlignment = NSTextAlignmentCenter;
        _chargeL.font = [UIFont systemFontOfSize:12];
        _chargeL.numberOfLines = 0;
        _chargeL.tag = TAG_BTN_B+1;
        _chargeL.userInteractionEnabled = YES;
    }
    return _chargeL;
}

- (UILabel *)yuYueL{
    if (!_yuYueL) {
        _yuYueL = [[UILabel alloc]init];
        _yuYueL.text = NSLocalizedString(@"预约",nil);
        _yuYueL.textAlignment = NSTextAlignmentCenter;
        _yuYueL.font = [UIFont systemFontOfSize:12];
        _yuYueL.numberOfLines = 0;
        _yuYueL.tag = TAG_BTN_B+2;
        _yuYueL.userInteractionEnabled = YES;
    }
    return _yuYueL;
}

- (UILabel *)xuNiQiangL{
    if (!_xuNiQiangL) {
        _xuNiQiangL = [[UILabel alloc]init];
//        _xuNiQiangL.text = NSLocalizedString(@"虚拟墙", nil) ;
         _xuNiQiangL.text = NSLocalizedString(@"禁扫区", nil) ;
        _xuNiQiangL.textAlignment = NSTextAlignmentCenter;
        _xuNiQiangL.font = [UIFont systemFontOfSize:12];
        _xuNiQiangL.numberOfLines = 0;
        _xuNiQiangL.tag = TAG_BTN_B+3;
        _xuNiQiangL.userInteractionEnabled = YES;
    }
    return _xuNiQiangL;
}
- (UILabel *)jiankongL{
    if (!_jiankongL) {
        _jiankongL = [[UILabel alloc]init];
        if([[DataManager shareDataManager].appNowProductTypeNumStr isEqualToString:@"01"] || [[MapVcGetUpXml getDeviceEqSerial] isEqualToString: @"310"]){
            _jiankongL.text = NSLocalizedString(@"监控",nil);
        }else{
            _jiankongL.text = NSLocalizedString(@"遥控",nil);
        }
        _jiankongL.numberOfLines = 0;
        _jiankongL.textAlignment = NSTextAlignmentCenter;
        _jiankongL.font = [UIFont systemFontOfSize:12];
        _jiankongL.tag = TAG_BTN_B+4;
        _jiankongL.userInteractionEnabled = YES;
    }
    return _jiankongL;
}

@end
