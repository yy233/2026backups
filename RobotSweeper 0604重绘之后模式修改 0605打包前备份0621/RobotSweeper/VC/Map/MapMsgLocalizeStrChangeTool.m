//
//  MapMsgLocalizeStrChangeTool.m
//  RobotSweeper
//
//  Created by Joey on 2018/11/27.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "MapMsgLocalizeStrChangeTool.h"

@implementation MapMsgLocalizeStrChangeTool
//MARK:_________国际化 intstr_>数据

+ (NSString *)localizeCodeMsgWithIntStr:(NSString *)msgIntStr{

 
    NSString *newStr  = @"NULL";
    NSString *strOfCodeAndTxt = @"NULL";
    int msgInt = [msgIntStr intValue];
    switch ( msgInt) {
        case  0:
        newStr = NSLocalizedString(@"待机中", comment: nil);
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            newStr = NSLocalizedString(@"清扫中", comment: nil);
            break;
        case 5:
            newStr = NSLocalizedString(@"清扫中", comment: nil);
            break;
        case 6:
            newStr = NSLocalizedString(@"清扫中", comment: nil);
            break;
        case 7:
            newStr = NSLocalizedString(@"清扫中", comment: nil);
            break;
        case 8:
             break;
        case 9:
//            newStr = NSLocalizedString(@"停止清扫", comment: nil);
            newStr = NSLocalizedString(@"待机中", comment: nil);//1221更换文本与对应状态
            
            break;
        case 10:
            newStr = NSLocalizedString(@"请拔掉充电线", comment: nil);// error
            break;
        case 11:
//            newStr = NSLocalizedString(@"开始回充", comment: nil);
            newStr = NSLocalizedString(@"回充中", comment: nil);//1221更换文本与对应状态
            break;
        case 12:
//            newStr = NSLocalizedString(@"停止回充", comment: nil);
            newStr = NSLocalizedString(@"待机中", comment: nil);//1221更换文本与对应状态
            break;
        case 13:
            newStr = NSLocalizedString(@"充电中", comment: nil);
            break;
        case 14:
//            newStr = NSLocalizedString(@"充电完成", comment: nil);
            newStr = NSLocalizedString(@"充电已满", comment: nil);//1221更换文本与对应状态
            
            break;
        case 15:
            newStr = NSLocalizedString(@"回充失败", comment: nil);//回充失败 charging_faild
            break;
        case 16:
            newStr = NSLocalizedString(@"未找到集尘盒", comment: nil); //err
            strOfCodeAndTxt = [NSString stringWithFormat:@"E000 %@",newStr];
            newStr = strOfCodeAndTxt;//1224新增err
            break;
        case 17:
            newStr = NSLocalizedString(@"集尘盒已放回", comment: nil);
            break;
        case 18:
            newStr = NSLocalizedString(@"集尘盒已满", comment: nil); //err
            break;
        case 19:
            newStr = NSLocalizedString(@"定位", comment: nil);
            break;
        case 20:
            newStr = NSLocalizedString(@"电量不足", comment: nil);
            strOfCodeAndTxt = [NSString stringWithFormat:@"E003 %@",newStr];
            newStr = strOfCodeAndTxt;
            break;
        case 21:
            newStr = NSLocalizedString(@"开始升级", comment: nil);
            break;
        case 22:
            newStr = NSLocalizedString(@"升级中", comment: nil);
            break;
        case 23:
            newStr = NSLocalizedString(@"升级成功", comment: nil);
            break;
        case 24:
            newStr = NSLocalizedString(@"升级失败", comment: nil);
            break;
        case 25:
//            newStr = NSLocalizedString(@"E023", comment: nil);
            newStr = NSLocalizedString(@"激光测距值固定", comment: nil);
            //仅文字
            strOfCodeAndTxt = [NSString stringWithFormat:@"E023 %@",newStr];
            newStr = strOfCodeAndTxt;
            //code码 和 文字
            break;
        case 26:
//            newStr = NSLocalizedString(@"E023", comment: nil);
            newStr = NSLocalizedString(@"激光头损坏", comment: nil);
            //仅文字
            strOfCodeAndTxt = [NSString stringWithFormat:@"E023 %@",newStr];
            newStr = strOfCodeAndTxt;
            //code码 和 文字
            break;
        case 27:
//            newStr = NSLocalizedString(@"E022", comment: nil);
            newStr = NSLocalizedString(@"视频板通信异常", comment: nil);
            //仅文字
            strOfCodeAndTxt = [NSString stringWithFormat:@"E022 %@",newStr];
            newStr = strOfCodeAndTxt;
            //code码 和 文字
            break;
        case 28:
//            newStr = NSLocalizedString(@"E011", comment: nil);
            newStr = NSLocalizedString(@"惯导板通信异常", comment: nil);
            //仅文字
            strOfCodeAndTxt = [NSString stringWithFormat:@"E011 %@",newStr];
            newStr = strOfCodeAndTxt;
            //code码 和 文字

            break;
        case 29:
//            newStr = NSLocalizedString(@"E019", comment: nil);
            newStr = NSLocalizedString(@"控制板1分钟未收到导航板心跳", comment: nil);
            //仅文字
            strOfCodeAndTxt = [NSString stringWithFormat:@"E019 %@",newStr];
            newStr = strOfCodeAndTxt;
            //code码 和 文字

            break;
        case 30:
//            newStr = NSLocalizedString(@"E020", comment: nil);
            newStr = NSLocalizedString(@"导航板1分钟未收到控制板传感器数据", comment: nil);
            //仅文字
            strOfCodeAndTxt = [NSString stringWithFormat:@"E020 %@",newStr];
            newStr = strOfCodeAndTxt;
            //code码 和 文字
            break;
        case 31:
            newStr = NSLocalizedString(@"扫地机被抬起", comment: nil);
            break;
        case 32:
            newStr = NSLocalizedString(@"左轮悬空", comment: nil);
            strOfCodeAndTxt = [NSString stringWithFormat:@"E004 %@",newStr];
            newStr = strOfCodeAndTxt;
            break;
        case 33:
            newStr = NSLocalizedString(@"右轮悬空", comment: nil);
            strOfCodeAndTxt = [NSString stringWithFormat:@"E005 %@",newStr];
            newStr = strOfCodeAndTxt;
            break;
        case 34:
            newStr = NSLocalizedString(@"边检值固定", comment: nil);
            break;
        case 35:
            newStr = NSLocalizedString(@"边检值异常", comment: nil);
            break;
        case 36:
//            newStr = NSLocalizedString(@"E012", comment: nil);
            newStr = NSLocalizedString(@"左侧边检故障", comment: nil);
            //仅文字
            strOfCodeAndTxt = [NSString stringWithFormat:@"E012 %@",newStr];
            newStr = strOfCodeAndTxt;
            //code码 和 文字
            break;
        case 37:
//            newStr = NSLocalizedString(@"E013", comment: nil);
            newStr = NSLocalizedString(@"中间边检故障", comment: nil);
            //仅文字
            strOfCodeAndTxt = [NSString stringWithFormat:@"E013 %@",newStr];
            newStr = strOfCodeAndTxt;
            //code码 和 文字
            break;
        case 38:
//            newStr = NSLocalizedString(@"E014", comment: nil);
            newStr = NSLocalizedString(@"右侧边检故障", comment: nil);
            //仅文字
            strOfCodeAndTxt = [NSString stringWithFormat:@"E014 %@",newStr];
            newStr = strOfCodeAndTxt;
            //code码 和 文字
            break;
        case 39:
            newStr = NSLocalizedString(@"超声波值固定", comment: nil);
            break;
        case 40:
            newStr = NSLocalizedString(@"超声波值异常", comment: nil);
            break;
        case 41:
            newStr = NSLocalizedString(@"地检值固定", comment: nil);
            break;
        case 42:
            newStr = NSLocalizedString(@"地检值异常", comment: nil);
            break;
        case 43:
//            newStr = NSLocalizedString(@"E015", comment: nil);
            newStr = NSLocalizedString(@"左地检值异常", comment: nil);
            //仅文字
            strOfCodeAndTxt = [NSString stringWithFormat:@"E015 %@",newStr];
            newStr = strOfCodeAndTxt;
            //code码 和 文字
            break;
        case 44:
//            newStr = NSLocalizedString(@"E016", comment: nil);
            newStr = NSLocalizedString(@"中间地检值异常", comment: nil);
            //仅文字
            strOfCodeAndTxt = [NSString stringWithFormat:@"E016 %@",newStr];
            newStr = strOfCodeAndTxt;
            //code码 和 文字
            break;
        case 45:
//            newStr = NSLocalizedString(@"E017", comment: nil);
            newStr = NSLocalizedString(@"右地检值异常", comment: nil);
            //仅文字
            strOfCodeAndTxt = [NSString stringWithFormat:@"E017 %@",newStr];
            newStr = strOfCodeAndTxt;
            //code码 和 文字
            break;
        case 46:
//            newStr = NSLocalizedString(@"E018", comment: nil);
            newStr = NSLocalizedString(@"风机过载", comment: nil);//风扇过电流
            //仅文字
            strOfCodeAndTxt = [NSString stringWithFormat:@"E018 %@",newStr];
            newStr = strOfCodeAndTxt;
            //code码 和 文字
            break;
        case 47:
            newStr = NSLocalizedString(@"风扇锁定", comment: nil);
            break;
        case 48:
            newStr = NSLocalizedString(@"前盖碰撞装置失效", comment: nil);
            strOfCodeAndTxt = [NSString stringWithFormat:@"E002 %@",newStr];
            newStr = strOfCodeAndTxt;
            break;
        case 49:
            newStr = NSLocalizedString(@"红外传感器值固定", comment: nil);
            break;
        case 50:
            newStr = NSLocalizedString(@"红外传感器值异常", comment: nil);
            break;
        case 51:
            newStr = NSLocalizedString(@"驱动轮不转", comment: nil);
            break;
        case 52:
            newStr = NSLocalizedString(@"驱动轮过电流", comment: nil);
            break;
        case 53:
//            newStr = NSLocalizedString(@"扫地机被卡主", comment: nil);
              newStr = NSLocalizedString(@"扫地机被卡住", comment: nil);//扫地机被卡主
            strOfCodeAndTxt = [NSString stringWithFormat:@"E024 %@",newStr];
            newStr = strOfCodeAndTxt;
            //1224
            break;
        case 54:
            newStr = NSLocalizedString(@"滚扫过载", comment: nil);
            strOfCodeAndTxt = [NSString stringWithFormat:@"E010 %@",newStr];
            newStr = strOfCodeAndTxt;
            break;
        case 55:
            newStr = NSLocalizedString(@"中扫锁定", comment: nil);
            break;
        case 56:
            newStr = NSLocalizedString(@"边刷过电流", comment: nil);
            break;
        case 57:
            newStr = NSLocalizedString(@"边刷锁定", comment: nil);
            break;
        case 58:
//            newStr = NSLocalizedString(@"E021", comment: nil);
            newStr = NSLocalizedString(@"电池发生故障", comment: nil);
            //仅文字
            strOfCodeAndTxt = [NSString stringWithFormat:@"E021 %@",newStr];
            newStr = strOfCodeAndTxt;
            //code码 和 文字
            break;
        case 59:
            newStr = NSLocalizedString(@"左轮过载", comment: nil);
            strOfCodeAndTxt = [NSString stringWithFormat:@"E006 %@",newStr];
            newStr = strOfCodeAndTxt;
            break;
        case 60:
            newStr = NSLocalizedString(@"右轮过载", comment: nil);
            strOfCodeAndTxt = [NSString stringWithFormat:@"E007 %@",newStr];
            newStr = strOfCodeAndTxt;
            break;
        case 61:
            newStr = NSLocalizedString(@"左边刷过载", comment: nil);
            strOfCodeAndTxt = [NSString stringWithFormat:@"E008 %@",newStr];
            newStr = strOfCodeAndTxt;
            break;
        case 62:
            newStr = NSLocalizedString(@"右边刷过载", comment: nil);
            strOfCodeAndTxt = [NSString stringWithFormat:@"E009 %@",newStr];
            newStr = strOfCodeAndTxt;
            break;
        case 63:
//            newStr = NSLocalizedString(@"停止充电", comment: nil);
            newStr = NSLocalizedString(@"待机中", comment: nil);//1221更换文本与对应状态
            break;
        case 64:
            newStr = NSLocalizedString(@"休眠中", comment: nil);
            break;
        case 65:
            newStr = NSLocalizedString(@"请放置到安全区域", comment: nil);
            strOfCodeAndTxt = [NSString stringWithFormat:@"E001 %@",newStr];
            newStr = strOfCodeAndTxt;
            break;
        case 66:
            newStr = NSLocalizedString(@"机器人空闲时间过长,会造成无效耗电;如果已经设定预约,建议您让机器人回家充电.如果暂时不需要清扫,建议您关闭船型开关.", comment: nil);
            break;
        case 67:
            newStr = NSLocalizedString(@"扫地机发生碰撞", comment: nil);
            break;
        case 68:
            newStr = NSLocalizedString(@"扫地机遇到悬崖", comment: nil);
            break;
        case 69:
            newStr = NSLocalizedString(@"清扫中", comment: nil);
            break;
        case 70:
            newStr = NSLocalizedString(@"清扫中", comment: nil);
            break;
        default:
            break;
    }
    NSLog(@"状态码=====%@",newStr);
    return newStr;
    
}

@end
