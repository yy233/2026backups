//
//  MapBottomViewChangeTool.m
//  RobotSweeper
//
//  Created by 余莹 on 2019/3/20.
//  Copyright © 2019 余莹. All rights reserved.
//

#import "MapBottomViewChangeTool.h"

@implementation MapBottomViewChangeTool
+ (void)hidenOtherAndMoveOneBtnLableWithBtnTag:(int)btntag
                                    bottomV:(MapBottommView*)bottomV{
    
//    TAG_BTN_B+0~4  清扫==0 其余左到右12 34
    
    if (btntag == TAG_BTN_B+2) {
        return;//预约是跳转功能不做bottom的处理
    }
    UIButton *centVOne;
    UILabel *centVTwo;
    for (UIView *sub in  bottomV.subviews) {
        
        if (sub.tag==btntag) {
            sub.hidden = NO;
            if ([sub isKindOfClass:[UIButton class]]) {
                centVOne = (UIButton*)sub;
            }else{
                centVTwo = (UILabel*)sub;
            }
           
        }else{
            sub.hidden = YES;
        }
    }
    
    [MapBottomViewChangeTool setCenter:centVOne vT:centVTwo boomv:bottomV];
}

+ (void)setCenter:(UIButton*)viewOne vT:(UILabel *)viewTwo boomv:(UIView *)bottomV{
//    if (viewOne.tag==TAG_BTN_B) {//0 清扫
//
//    }else{//非清扫
////        CGFloat xC =  viewOne.center.x-Y_mainW*0.5>0?viewOne.center.x-Y_mainW*0.5:Y_mainW*0.5-viewOne.center.x;
//        CGFloat xC = Y_mainW*0.5;
//        viewOne.center = CGPointMake(xC, viewOne.center.y);
//        viewTwo.center = CGPointMake(xC, viewTwo.center.y);
//
//    }
    NSLog(@"设置为中心view");
    [viewOne mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomV).offset(-15);//同水平线顶高不同
        make.centerX.equalTo(bottomV);
        make.height.equalTo(bottomV.mas_height).offset(-55);//用10的高度差 20图片过大
        make.width.offset(Y_mainW*0.18);
    }];
    [viewOne layoutIfNeeded];
   
    //国际化的宽度修改
    BOOL isLongView = NO;
    if(viewTwo.text.length>3){
        isLongView = YES;
    }
   
    [viewTwo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewOne);
        make.width.equalTo(viewOne.mas_width);
        if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(viewOne.mas_bottom).offset(10);
        }else{
            make.height.offset(36);
            make.top.equalTo(viewOne.mas_bottom).offset(2);
        }
    }];
    [viewTwo layoutIfNeeded];
    if (viewTwo.tag==TAG_BTN_B) {//TAG_BTN_B+0;//tag新增 用于点击事件 0121 btnandLabel
        viewTwo.text = NSLocalizedString(@"暂停", nil);

    }else{
        viewTwo.text = NSLocalizedString(@"返回", nil);

    }
    
}

+ (void)showAllBottomV:(MapBottommView*)bottomV{
//      NSLog(@"设置为中心的view还原");
        UILabel *chargeL = nil;
        UIButton *chargeB = nil;
        UILabel *yuyueL = nil;
        UIButton *yuyueB = nil;
        UILabel *cleanL= nil;
        UIButton *cleanB= nil;
        UILabel *xuniqinagL= nil;
        UIButton *xuniqinagB= nil;
        UILabel *yaokongL= nil;
        UIButton *yaokongB= nil;
    
        for (UIView *sub in  bottomV.subviews) {
                sub.hidden = NO;
            if (sub.tag-TAG_BTN_B==0) {
                if ([sub isKindOfClass:[UIButton class]]) {
                   cleanB = (UIButton *)sub;
                }else{
                   cleanL = (UILabel *)sub;
                }
            }else if (sub.tag-TAG_BTN_B==1) {
                if ([sub isKindOfClass:[UIButton class]]) {
                    chargeB = (UIButton *)sub;
                }else{
                    chargeL = (UILabel *)sub;
                }
            }else if (sub.tag-TAG_BTN_B==2) {
                if ([sub isKindOfClass:[UIButton class]]) {
                    yuyueB = (UIButton *)sub;
                }else{
                    yuyueL = (UILabel *)sub;
                }
            }else if (sub.tag-TAG_BTN_B==3) {
                if ([sub isKindOfClass:[UIButton class]]) {
                    xuniqinagB = (UIButton *)sub;
                }else{
                    xuniqinagL = (UILabel *)sub;
                }
            }else if (sub.tag-TAG_BTN_B==4) {
                if ([sub isKindOfClass:[UIButton class]]) {
                    yaokongB = (UIButton *)sub;
                }else{
                    yaokongL = (UILabel *)sub;
                }
    
            }else{
                
            }
    
        }
    [self getYeShuOfBottomWithBv:bottomV chargeBtn:chargeB chargeL:chargeL yuYueBtn:yuyueB yuYueL:yuyueL clearnBtn:cleanB clearnL:cleanL xuNiQiangBtn:xuniqinagB xuNiQiangL:xuniqinagL jiankongBtn:yaokongB jiankongL:yaokongL];
    
//    [bottomV getYeShuOfCleanBigOtherSamall];
//    for (UIView *sub in  bottomV.subviews) {
//        sub.hidden = NO;
//        if (sub.tag==TAG_BTN_B+4) {
//            sub.center = CGPointMake(0, 0);///中心点还原否？否
//        }
//    }
}

//中间图标大两边小的约束 label中英匹配  同bottomv的初始化
+(void)getYeShuOfBottomWithBv:(UIView *)bottomV
                    chargeBtn:(UIButton *)chargeBtn
                      chargeL:(UILabel *)chargeL
                     yuYueBtn:(UIButton *)yuYueBtn
                       yuYueL:(UILabel *)yuYueL
                    clearnBtn:(UIButton *)clearnBtn
                      clearnL:(UILabel *)clearnL
                 xuNiQiangBtn:(UIButton *)xuNiQiangBtn
                   xuNiQiangL:(UILabel *)xuNiQiangL
                  jiankongBtn:(UIButton *)jiankongBtn
                    jiankongL:(UILabel *)jiankongL
{

    //国际化的宽度修改
    BOOL isLongView = NO;
    if(chargeL.text.length>3){//改成’返回‘文本的按钮 更换back|返回
        isLongView = YES;
    }


    [clearnBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomV).offset(-15);//同水平线顶高不同
        make.centerX.equalTo(bottomV);
        make.height.equalTo(bottomV.mas_height).offset(-55);//用10的高度差 20图片过大
        make.width.offset(Y_mainW*0.18);
    }];
    [clearnBtn layoutIfNeeded];
    
    [chargeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomV).offset(-10);
        make.height.equalTo(bottomV.mas_height).offset(-65);
        make.width.offset(Y_mainW*0.18);
        make.left.equalTo(bottomV.mas_left).offset(Y_mainW*0.05);
    }];
    [chargeBtn layoutIfNeeded];
    
    [yuYueBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomV).offset(-10);;
        make.height.equalTo(bottomV.mas_height).offset(-65);
        make.width.offset(Y_mainW*0.18);
        make.left.equalTo(chargeBtn.mas_right);
    }];
    [yuYueBtn layoutIfNeeded];

    [xuNiQiangBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomV).offset(-10);;
        make.height.equalTo(bottomV.mas_height).offset(-65);;
        make.width.offset(Y_mainW*0.18);
        make.left.equalTo(clearnBtn.mas_right);
    }];
    [xuNiQiangBtn layoutIfNeeded];
    
    [jiankongBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomV).offset(-10);;
        make.height.equalTo(bottomV.mas_height).offset(-65);;
        make.width.offset(Y_mainW*0.18);
        make.right.equalTo(bottomV.mas_right).offset(-Y_mainW*0.05);
    }];
    [jiankongBtn layoutIfNeeded];

    //
    [clearnL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(clearnBtn);
        make.width.equalTo(clearnBtn.mas_width);
        if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(clearnBtn.mas_bottom).offset(10);
        }else{
            make.height.offset(36);
            make.top.equalTo(clearnBtn.mas_bottom).offset(2);
        }
    }];
    [clearnL layoutIfNeeded];
    
    [chargeL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(chargeBtn);
        make.width.equalTo(chargeBtn.mas_width);
        if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(chargeBtn.mas_bottom).offset(10);

        }else{
            make.height.offset(36);
            make.top.equalTo(chargeBtn.mas_bottom).offset(2);


        }
    }];
    [chargeL layoutIfNeeded];
    [yuYueL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(yuYueBtn);
        make.width.equalTo(yuYueBtn.mas_width);
        if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(yuYueBtn.mas_bottom).offset(10);
        }else{
            make.height.offset(36);
            make.top.equalTo(yuYueBtn.mas_bottom).offset(2);

        }
    }];
    [yuYueL layoutIfNeeded];
    
    [xuNiQiangL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(xuNiQiangBtn);
        make.width.equalTo(xuNiQiangBtn.mas_width);

        if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(xuNiQiangBtn.mas_bottom).offset(10);

        }else{
            make.height.offset(36);
            make.top.equalTo(xuNiQiangBtn.mas_bottom).offset(2);
        }

    }];
    [xuNiQiangL layoutIfNeeded];
    
    [jiankongL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(jiankongBtn);
        make.width.equalTo(jiankongBtn.mas_width);

        if (!isLongView) {
            make.height.offset(25);
            make.top.equalTo(jiankongBtn.mas_bottom).offset(10);
        }else{
            make.height.offset(36);
            make.top.equalTo(jiankongBtn.mas_bottom).offset(2);

        }
    }];
    [jiankongL layoutIfNeeded];
    
    
    //文本变化 变回原来的
    if([[DataManager shareDataManager].appNowProductTypeNumStr isEqualToString:@"01"] || [[MapVcGetUpXml getDeviceEqSerial] isEqualToString: @"310"]){
        jiankongL.text = NSLocalizedString(@"监控",nil);
    }else{
        jiankongL.text = NSLocalizedString(@"遥控",nil);
    }
    
     xuNiQiangL.text = NSLocalizedString(@"禁扫区", nil) ;
     yuYueL.text = NSLocalizedString(@"预约",nil);
     chargeL.text = NSLocalizedString(@"回充",nil);
     clearnL.text = NSLocalizedString(@"清扫",nil);
    
    
    
    clearnL.numberOfLines = 0;
    chargeL.numberOfLines = 0;
    yuYueL.numberOfLines = 0;
    xuNiQiangL.numberOfLines = 0;
    jiankongL.numberOfLines = 0;
}
@end
