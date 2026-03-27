//
//  QROrImExChoosePopview.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/18.
//

#import "QROrImExChoosePopview.h"

@interface QROrImExChoosePopview ()
@property (nonatomic,assign) CGFloat selfBkView_Height;
@property (nonatomic,assign) float animationTime;

@end

@implementation QROrImExChoosePopview


- (NSMutableArray *)dataSourceArr{
    if(!_dataSourceArr){
        _dataSourceArr = @[].mutableCopy;
    }
    return _dataSourceArr;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, Screen_H);    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.doQRBtn];
        [self.backView addSubview:self.doFormBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    if (self.selfBkView_Height <= 20.0) {
        self.selfBkView_Height  = 160.0;//默认值
    }
    self.animationTime = 0.6;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.02];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backView.superview);
        make.centerY.equalTo(_backView.superview).multipliedBy(0.8);
        make.width.equalTo(_backView.superview).multipliedBy(0.8);
        make.height.offset(self.selfBkView_Height);
    }];
    
    [_doQRBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_doQRBtn.superview);
        make.height.equalTo(_doQRBtn.superview).multipliedBy(0.5);
        make.left.equalTo(_doQRBtn.superview).offset(20);
        make.right.equalTo(_doQRBtn.superview.mas_centerX).offset(-10);
    }];
    
    [_doFormBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_doFormBtn.superview);
        make.height.equalTo(_doFormBtn.superview).multipliedBy(0.5);
        make.left.equalTo(_doQRBtn.superview.mas_centerX).offset(10);
        make.right.equalTo(_doQRBtn.superview).offset(-20);
    }];
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 10;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor  = CC_Brown_D;
        }
    return _backView;
}

- (UIButton *)doQRBtn{
    if (!_doQRBtn) {
        _doQRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doQRBtn newAnBtnWithTextStr:@""];
        [_doQRBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:15.0]];
        [_doQRBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_doQRBtn newAnBtnWithBackColor:CC_Red_Drak_A];
        [_doQRBtn newAnBtnWithLayerCorNerNum:10 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    }
    return _doQRBtn;
}
 
- (UIButton *)doFormBtn{
    if (!_doFormBtn) {
        _doFormBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doFormBtn newAnBtnWithTextStr:@""];
        [_doFormBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:15.0]];
        [_doFormBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_doFormBtn newAnBtnWithBackColor:CC_Red_Drak_A];
        [_doFormBtn newAnBtnWithLayerCorNerNum:10 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    }
    return _doFormBtn;
}
#pragma mark ====
- (void)showPopViewWithDataArr:(NSMutableArray *)dataArr
                  withShowType:(ImorExOrder_SubType)type
                 withOtherData:(id)otherData
                 withBkvHeight:(CGFloat)bkHeight
                    withSuperV:(UIView *)supview{
    
    
      if (!supview) {
  //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
          UIWindow *window = [Tool toolGetKeyWindow];
          supview = window.rootViewController.view;
      }
      self.selfBkView_Height = bkHeight;

      dispatch_async(dispatch_get_main_queue(), ^{
          [supview addSubview:self];
          //
//          [self.backView setFrame:CGRectMake(0, Screen_H, Screen_W, 0)];
          [self setFrame:CGRectMake(0, Screen_H, Screen_W, 0)];
          [UIView animateWithDuration:self.animationTime animations:^{
              self.alpha = 1.0;
//              self.backView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
              self.frame = CGRectMake(0, 0, Screen_W, Screen_H);
          } completion:nil];
          if (isNotNil(dataArr)) {
              self.dataSourceArr = dataArr;
          }
          [self typeDataSetWith:type];
      });
}
- (void)dismissPopView{
    CGPoint center = self.backView.center;
    [UIView animateWithDuration:self.animationTime
                     animations:^{
        self.alpha = 0.0;
//        [self.backView setCenter:CGPointMake(center.x, center.y+Screen_H)];
        [self setCenter:CGPointMake(center.x, center.y+Screen_H)];
    } completion:^(BOOL finished){
        [self.backView removeFromSuperview];
        [self removeFromSuperview];

    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismissPopView];
}

#pragma mark ====
- (void)typeDataSetWith:(ImorExOrder_SubType)type{
    self.type = type;
    switch (type) {
        case ImorExOrder_SubType_ImAction:
        {
            [self.doQRBtn newAnBtnWithTextStr:@"扫码入库"];
            [self.doFormBtn newAnBtnWithTextStr:@"填写表单入库"];
        }
            break;
        case ImorExOrder_SubType_ExAction:
        {
            [self.doQRBtn newAnBtnWithTextStr:@"扫码出库"];
            [self.doFormBtn newAnBtnWithTextStr:@"填写表单出库"];
        }
            break;

            
        default:
            break;
    }
    
}
 
@end
