//
//  RotueViewZhuanSaoDataDeal.m
//  RobotSweeper
//
//  Created by 余莹 on 2019/3/5.
//  Copyright © 2019 余莹. All rights reserved.
//

#import "RotueViewZhuanSaoDataDeal.h"
//专扫区的初始位置 == 扫地机 pox 的位置。（在专扫模式时付之）
//定点模式下的 专扫区的数据处理 处理后的坐标str 时时更新给虚拟墙， 类似于得到专扫区的协议时的数据更新
static   NSString *strOfAreaAllowOfBeginGesSaVe;//beginGes时存下的协议str


@implementation RotueViewZhuanSaoDataDeal
#pragma mark:_____初始化专扫UI
//这里使用 pox 坐标
+(NSString *)newZhuanSaoShow{
    CGFloat robotX = DataManager.shareDataManager.posX;
    CGFloat robotY = DataManager.shareDataManager.posY;

    int okX = robotX;
    int okY = robotY;
    NSString *strOfAreaZhuanSao = [NSString stringWithFormat:@"area_allow 1 %d %d %d %d",(okX-20),(okY-20),(okX+20),(okY+20)];//2点
//NSString *strOfAreaZhuanSao = [NSString stringWithFormat:@"area_allow 1 %d %d %d %d",(okX-50),(okY-50),(okX+50),(okY+50)];//2点 一个大点的图  测试使用
    return strOfAreaZhuanSao;
}

#pragma mark:_____计算开始手势的坐标，以得出当前的拖动、非拖动、缩放、缩放方向等状态
+(int)thisOneIsStatuRequesWithAreaAllowStr:(NSString *)strOfAreaAllow
                                     pointOfWallV:(CGPoint)pointOfWallV
                                  pointOfWallSubV:(CGPoint)pointOfWallSubV
                                      pointOfOneP:(CGPoint)pOne
                                      pointOfTwoP:(CGPoint)pTwo
                                     saveMapScale:(CGFloat)mapScale{
    
   strOfAreaAllowOfBeginGesSaVe = strOfAreaAllow;
    int statuOfThisOneGes = 10;

    NSLog(@"thisOneIsStatuRequesWithAreaAllowStr  %@, %@, %@, %@, %@",strOfAreaAllow,NSStringFromCGPoint(pointOfWallV),NSStringFromCGPoint(pointOfWallSubV),NSStringFromCGPoint(pOne),NSStringFromCGPoint(pTwo));
    //    NSArray *arrofallowStr = [strOfAreaAllow componentsSeparatedByString:@" "];
    //    if (arrofallowStr.count!=6) {
    //        return 10;//10 为不响应的方位
    //    }
    //    CGFloat x1 = [[NSString stringWithFormat:@"%@", arrofallowStr[2]] floatValue];
    //    CGFloat x2 = [[NSString stringWithFormat:@"%@", arrofallowStr[3]] floatValue];
    //    CGFloat y1 = [[NSString stringWithFormat:@"%@", arrofallowStr[4]] floatValue];
    //    CGFloat y2 = [[NSString stringWithFormat:@"%@", arrofallowStr[5]] floatValue];
    //    CGFloat w = (x1-x2)>0 ? (x1-x2):(x2-x1);
    //    CGFloat h = (y1-y2)>0 ? (y1-y2):(y2-y1);
    NSString *WandH = [self getWAndHOfStr:strOfAreaAllow];
    NSArray *arrOfwh = [WandH componentsSeparatedByString:@" "];
    if (arrOfwh.count != 2) {
        return statuOfThisOneGes;
    }
    CGFloat w = [arrOfwh.firstObject floatValue];
    CGFloat h = [arrOfwh.lastObject floatValue];
    CGFloat pSubvX = pointOfWallSubV.x;
    CGFloat pSubvY = pointOfWallSubV.y;
    
    if (pSubvX>0&&pSubvY>0) {//该点不在左上
        if (pSubvX<w && pSubvY<h) {//该点不在右下 在禁止区内部
            //计算出具体方位 （此int 类似虚拟墙的禁止区int）
          
          statuOfThisOneGes = [self getPanOrZoomDataWithW:w h:h pX:pSubvX pY:pSubvY];
//            int a = [self getPanOrZoomDataWithW:w h:h pX:pSubvX pY:pSubvY];
//            NSLog(@"_____________________________当前方位数据值= %d  wh=%@ pxpy=%@",a,WandH,NSStringFromCGPoint(pointOfWallSubV));
        }
    }
//     NSLog(@"_____________________________当前方位数据值=基础数值  wh=%@ pxpy=%@ ",WandH,NSStringFromCGPoint(pointOfWallSubV));
    return statuOfThisOneGes;
}
#pragma mark:____//用协议str的值计算当前的宽高
//用协议str的值计算当前的宽高
+ (NSString *)getWAndHOfStr:(NSString *)areaAllowStr{
    NSArray *arrofallowStr = [areaAllowStr componentsSeparatedByString:@" "];
    if (arrofallowStr.count!=6) {
        return nil;//10 为不响应的方位
    }
    CGFloat x1 = [[NSString stringWithFormat:@"%@", arrofallowStr[2]] floatValue];
    CGFloat y1 = [[NSString stringWithFormat:@"%@", arrofallowStr[3]] floatValue];
    CGFloat x2 = [[NSString stringWithFormat:@"%@", arrofallowStr[4]] floatValue];
    CGFloat y2 = [[NSString stringWithFormat:@"%@", arrofallowStr[5]] floatValue];
    CGFloat w = (x1-x2)>0 ? (x1-x2):(x2-x1);
    CGFloat h = (y1-y2)>0 ? (y1-y2):(y2-y1);
    NSString *strReturn = [NSString stringWithFormat:@"%f %f",w,h];
    return strReturn;
}
////计算出具体方位 （此int 类似虚拟墙的禁止区int）
+ (int)getPanOrZoomDataWithW:(CGFloat)w
                            h:(CGFloat)h
                           pX:(CGFloat)pX
                           pY:(CGFloat)pY{

    CGFloat x = pX/w;
    CGFloat y = pY/h;
    int willReturnStatus = 10;
    
    if (0<x && x<0.2) {//偏左
        if(0<y&&y<0.2){//便上
            willReturnStatus =4;//左上
        }else if (y<0.8){//偏中
            willReturnStatus = 0;//left
        }else{//偏下
            willReturnStatus =5;//左下
        }
        
    }else if(x<0.8){//偏中
        if(0<y&&y<0.2){//便上
            willReturnStatus = 3;// top
        }else if (y<0.8){//中
            willReturnStatus = 9;//center偏中心只返回拖动的int标志
        }else{//偏下
            willReturnStatus = 1;//bottom
        }
    }else{//偏右
        if(0<y&&y<0.2){//便上
            willReturnStatus =6;//右上
        }else if (y<0.8){//偏中
            willReturnStatus = 2;//right
        }else{//偏下
            willReturnStatus =7;//右下
        }
    }
    
    return willReturnStatus;
    
}

/**
 %f",tagOfFangxiangNum,willX,willY,willW,willH);
 switch (tagOfFangxiangNum) {
 case 0://left
 willX = rec.view.frame.origin.x;
 willW = willW-point.x;
 break;
 
 case  1://bottom
 willH = willH+point.y;
 break;
 
 case  2://right
 willW = willW+point.x;
 break;
 
 case  3://top
 willY = rec.view.frame.origin.y;
 willH = willH-point.y;
 break;
 
 case  4://左上
 willX = rec.view.frame.origin.x;
 willY = rec.view.frame.origin.y;
 willW = willW-point.x;
 willH = willH-point.y;
 break;
 
 case  5://左下
 willX = rec.view.frame.origin.x;
 willW = willW-point.x;
 willH = willH+point.y;
 break;
 case  6://右上
 willY = rec.view.frame.origin.y;
 willW = willW+point.x;
 willH = willH-point.y;
 break;
 case  7://右下
 willW = willW+point.x;
 willH = willH+point.y;
 break;
 default:
 //                 [self allThisRecViewPanWithGes:rec];
 break;
 }*/

#pragma mark:____ 计算在拖动手势时候的新数据

//算出新的area_allow str 的左上右下两新点 返回扫地机的协议数据
+(NSString *)getRouteViewZhuanSaoStrWithAreaAllowStr:(NSString *)strOfAreaAllow
                                         intOfStatus:(int)intOfStatus
                                         pointOfOneP:(CGPoint)pOne
                                         pointOfTwoP:(CGPoint)pTwo
                                        saveMapScale:(CGFloat)mapScale{
  
    
//    NSString *newStrOfAreaZhuanSaoQu = strOfAreaAllow;
    NSString *newStrOfAreaZhuanSaoQu = strOfAreaAllowOfBeginGesSaVe;//使用gesbegin时的数据
    //处理倍数关系
    CGPoint point  = CGPointMake(pOne.x/mapScale, pOne.y/mapScale) ;

    //
    NSString *WandH = [self getWAndHOfStr:newStrOfAreaZhuanSaoQu];
    NSArray *arrOfwh = [WandH componentsSeparatedByString:@" "];
    if (arrOfwh.count != 2) {
        return @"";
    }
    CGFloat w = [arrOfwh.firstObject floatValue];
    CGFloat h = [arrOfwh.lastObject floatValue];
    //
    NSArray *arrofallowStr = [newStrOfAreaZhuanSaoQu componentsSeparatedByString:@" "];
    if (arrofallowStr.count!=6) {
        return @"";
    }
    CGFloat x1 = [[NSString stringWithFormat:@"%@", arrofallowStr[2]] floatValue];
    CGFloat y1 = [[NSString stringWithFormat:@"%@", arrofallowStr[3]] floatValue];
    //
    CGFloat willX = x1;
    CGFloat willY = y1;
    CGFloat willW = w;
    CGFloat willH = h;
    
    NSLog(@"拖动手势时候的新数据strOfAreaAllow=%@ ___ pOne=%@ point=%@ mapscale=%f",strOfAreaAllow,NSStringFromCGPoint(pOne),NSStringFromCGPoint(point),mapScale);
     NSLog(@"拖动手势时候的新数据其他数据 x y w h ____%f %f %f %f",willX,willY,w,h);
    
    switch (intOfStatus) {//(此处是手势第一次在那个位置发出，类似于虚拟墙禁止区的zoom按钮的tag)
        case 0://left
            willX = willX+point.x;
            willW = willW-point.x;
            break;
            
        case  1://bottom
            willY = willY-point.y;
            willH = willH+point.y;
            break;
            
        case  2://right
            willW = willW+point.x;
            break;
            
        case  3://top
              willH = willH-point.y;
            break;
            
        case  4://左上
            willX = willX+point.x;
            willW = willW-point.x;
            willH = willH-point.y;
            break;

        case  5://左下
            willX = willX+point.x;
            willW = willW-point.x;
            willY = willY-point.y;
            willH = willH+point.y;
            break;
        case  6://右上
            willW = willW+point.x;
            willH = willH-point.y;
            break;
        case  7://右下
            willW = willW+point.x;
            willY = willY-point.y;
            willH = willH+point.y;
            break;
        case  9://拖动
            willX = willX+point.x;
            willY = willY-point.y;
            break;
        default:
            
            break;
    }
 
    ////数据过小 且往更小的数据缩做动作 则不做缩放
    if (willW<30&&willW<w) {
        return strOfAreaAllow;//发送原数据
    }
    if (willH<30&&willH<h) {
        return strOfAreaAllow;
    }

    CGPoint bp = CGPointMake(willX, willY);
    CGPoint ep = CGPointMake(willX+willW, willY+willH);
   
    newStrOfAreaZhuanSaoQu = [NSString stringWithFormat:@"area_allow 1 %0.0f %0.0f %0.0f %0.0f",bp.x,bp.y,ep.x,ep.y];
    
    NSLog(@"拖动手势时候的新数据intOfStatus %d",intOfStatus);
    NSLog(@"拖动手势时候的新数据OK其他数据结果为 %@",newStrOfAreaZhuanSaoQu);
    return newStrOfAreaZhuanSaoQu;
}


@end
