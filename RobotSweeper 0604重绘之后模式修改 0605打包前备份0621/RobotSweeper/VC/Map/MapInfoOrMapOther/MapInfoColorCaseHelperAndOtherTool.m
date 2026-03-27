//
//  MapInfoColorCaseHelperAndOtherTool.m
//  RobotSweeper
//
//  Created by 余莹 on 2019/4/26.
//  Copyright © 2019 余莹. All rights reserved.
//地图各个颜色|地图成像拼接图等|区域打扫各个颜色|

#import "MapInfoColorCaseHelperAndOtherTool.h"

@implementation MapInfoColorCaseHelperAndOtherTool
//地图开辟颜色空间
+ (void)useDataPMallocWithData:(NSData *)data
               charPointMalloc:(unsigned char*)mallocPoint{
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);//内存拷贝
    if (DataManager.shareDataManager.colorShowOrNotShowOfCleanFourFourMode == YES) {
        
        
        ///20190228新增4*4颜色判断显示不现实 12-14显隐
        for (int i = 0; i<len; i++) {
            //        NSLog(@"i=%d,data=%d",i,byteData[i]);
            
            switch (byteData[i]) {
                case 0://未探索
                    
                    mallocPoint[4*i]   = 245;//R
                    mallocPoint[4*i+1] = 245;//G
                    mallocPoint[4*i+2] = 245;//B
                    mallocPoint[4*i+3] = 255;//A
                    break;
                case 1://已探索
                    
                    mallocPoint[4*i]   = 245;//R
                    mallocPoint[4*i+1] = 245;//G
                    mallocPoint[4*i+2] = 245;//B
                    mallocPoint[4*i+3] = 255;//A
                    //                mallocPoint[4*i]   = 207;//R
                    //                mallocPoint[4*i+1] = 250;//G
                    //                mallocPoint[4*i+2] = 190;//B
                    //                mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 2:// 机身覆盖区
                    
                    mallocPoint[4*i]   = 255;//R
                    mallocPoint[4*i+1] = 255;//G
                    mallocPoint[4*i+2] = 255;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 3://已清扫区 @
                    //                mallocPoint[4*i]   = 255;//R
                    //                mallocPoint[4*i+1] = 255;//G
                    //                mallocPoint[4*i+2] = 255;//B
                    //                mallocPoint[4*i+3] = 255;//A
                    mallocPoint[4*i]   = 254;//R
                    mallocPoint[4*i+1] = 254;//G
                    mallocPoint[4*i+2] = 254;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 4://墙
                    mallocPoint[4*i]   = 31;//R
                    mallocPoint[4*i+1] = 31;//G
                    mallocPoint[4*i+2] = 31;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 5://碰撞点
                    
                    mallocPoint[4*i]   = 31;//R
                    mallocPoint[4*i+1] = 31;//G
                    mallocPoint[4*i+2] = 31;//B
                    mallocPoint[4*i+3] = 255;//A
                    break;
                case 6://手绘虚拟墙点
                    
                    //          mallocPoint[4*i]   = 85;//R
                    //            mallocPoint[4*i+1] = 85;//G
                    //              mallocPoint[4*i+2] = 85;//B
                    //                mallocPoint[4*i+3] = 255;//A
                    
                    mallocPoint[4*i]   = 245;//R
                    mallocPoint[4*i+1] = 245;//G
                    mallocPoint[4*i+2] = 245;//B
                    mallocPoint[4*i+3] = 255;//A
                    break;
                case 7:
                    
                    mallocPoint[4*i]   = 119;//R
                    mallocPoint[4*i+1] = 119;//G
                    mallocPoint[4*i+2] = 119;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 8:
                    
                    //                mallocPoint[4*i]   = 245;//R
                    //                mallocPoint[4*i+1] = 245;//G
                    //                mallocPoint[4*i+2] = 245;//B
                    //                mallocPoint[4*i+3] = 255;//A
                    mallocPoint[4*i]   = 255;//R
                    mallocPoint[4*i+1] = 255;//G
                    mallocPoint[4*i+2] = 255;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 9://轨迹点
                    mallocPoint[4*i]   = 255;//R
                    mallocPoint[4*i+1] = 255;//G
                    mallocPoint[4*i+2] = 255;//B
                    mallocPoint[4*i+3] = 255;//A
                    //                            mallocPoint[4*i]   = 103;//R
                    //                            mallocPoint[4*i+1] = 53;//G
                    //                            mallocPoint[4*i+2] = 184;//B
                    //                            mallocPoint[4*i+3] = 255;//A//20190305颜色深了点更换
                    //                            mallocPoint[4*i]   = 153;//R
                    //                            mallocPoint[4*i+1] = 161;//G
                    //                            mallocPoint[4*i+2] = 231;//B
                    //                            mallocPoint[4*i+3] = 255;//A
                    break;
                    
                    
                    //1224新增4*4模式用到的颜色
                case 10:
                    mallocPoint[4*i]   = 255;//R
                    mallocPoint[4*i+1] = 0;//G
                    mallocPoint[4*i+2] = 0;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 11:
                    mallocPoint[4*i]   = 127;//R
                    mallocPoint[4*i+1] = 255;//G
                    mallocPoint[4*i+2] = 0;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                    
                    //20190228用后门开关控制显示与不显示 由于for数据大，不在for内部判断,写两个for，在for外判断
                case 12://紫色
                    mallocPoint[4*i]   = 255;//R
                    mallocPoint[4*i+1] = 0;//G
                    mallocPoint[4*i+2] = 255;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 13://黄色
                    mallocPoint[4*i]   = 255;//R
                    mallocPoint[4*i+1] = 255;//G
                    mallocPoint[4*i+2] = 0;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 14://浅绿色
                    mallocPoint[4*i]   = 152;//R
                    mallocPoint[4*i+1] = 251;//G
                    mallocPoint[4*i+2] = 152;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                default:
                    mallocPoint[4*i]   = 245;//R
                    mallocPoint[4*i+1] = 245;//G
                    mallocPoint[4*i+2] = 245;//B
                    mallocPoint[4*i+3] = 255;//A
                    break;
            }
        }
        //A！=0 否则容易出现错位重叠
        //    NSLog(@"内存写之前的data长度=%lu--b=",(unsigned long)data.length);
        
    }else{
        
        ///20190228新增4*4颜色判断显示不现实 12-14显隐
        for (int i = 0; i<len; i++) {
            //        NSLog(@"i=%d,data=%d",i,byteData[i]);
            
            switch (byteData[i]) {
                case 0://未探索
                    
                    mallocPoint[4*i]   = 245;//R
                    mallocPoint[4*i+1] = 245;//G
                    mallocPoint[4*i+2] = 245;//B
                    mallocPoint[4*i+3] = 255;//A
                    break;
                case 1://已探索
                    
                    mallocPoint[4*i]   = 245;//R
                    mallocPoint[4*i+1] = 245;//G
                    mallocPoint[4*i+2] = 245;//B
                    mallocPoint[4*i+3] = 255;//A
                    //                mallocPoint[4*i]   = 207;//R
                    //                mallocPoint[4*i+1] = 250;//G
                    //                mallocPoint[4*i+2] = 190;//B
                    //                mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 2:// 机身覆盖区
                    
                    mallocPoint[4*i]   = 255;//R
                    mallocPoint[4*i+1] = 255;//G
                    mallocPoint[4*i+2] = 255;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 3://已清扫区 @
                    //                mallocPoint[4*i]   = 255;//R
                    //                mallocPoint[4*i+1] = 255;//G
                    //                mallocPoint[4*i+2] = 255;//B
                    //                mallocPoint[4*i+3] = 255;//A
                    mallocPoint[4*i]   = 254;//R
                    mallocPoint[4*i+1] = 254;//G
                    mallocPoint[4*i+2] = 254;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 4://墙
                    mallocPoint[4*i]   = 31;//R
                    mallocPoint[4*i+1] = 31;//G
                    mallocPoint[4*i+2] = 31;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 5://碰撞点
                    
                    mallocPoint[4*i]   = 31;//R
                    mallocPoint[4*i+1] = 31;//G
                    mallocPoint[4*i+2] = 31;//B
                    mallocPoint[4*i+3] = 255;//A
                    break;
                case 6://手绘虚拟墙点
                    
                    //          mallocPoint[4*i]   = 85;//R
                    //            mallocPoint[4*i+1] = 85;//G
                    //              mallocPoint[4*i+2] = 85;//B
                    //                mallocPoint[4*i+3] = 255;//A
                    
                    mallocPoint[4*i]   = 245;//R
                    mallocPoint[4*i+1] = 245;//G
                    mallocPoint[4*i+2] = 245;//B
                    mallocPoint[4*i+3] = 255;//A
                    break;
                case 7:
                    
                    mallocPoint[4*i]   = 119;//R
                    mallocPoint[4*i+1] = 119;//G
                    mallocPoint[4*i+2] = 119;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 8:
                    
                    //                mallocPoint[4*i]   = 245;//R
                    //                mallocPoint[4*i+1] = 245;//G
                    //                mallocPoint[4*i+2] = 245;//B
                    //                mallocPoint[4*i+3] = 255;//A
                    mallocPoint[4*i]   = 255;//R
                    mallocPoint[4*i+1] = 255;//G
                    mallocPoint[4*i+2] = 255;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                    break;
                case 9://轨迹点
                    mallocPoint[4*i]   = 255;//R
                    mallocPoint[4*i+1] = 255;//G
                    mallocPoint[4*i+2] = 255;//B
                    mallocPoint[4*i+3] = 255;//A
                    //                    mallocPoint[4*i]   = 103;//R
                    //                    mallocPoint[4*i+1] = 53;//G
                    //                    mallocPoint[4*i+2] = 184;//B
                    //                    mallocPoint[4*i+3] = 255;//A 20190305更换成浅紫色
//                    mallocPoint[4*i]   = 153;//R
//                    mallocPoint[4*i+1] = 161;//G
//                    mallocPoint[4*i+2] = 231;//B
//                    mallocPoint[4*i+3] = 255;//A
                    break;
                    
                    
                    //10 11 也要屏蔽
                    //                    //1224新增4*4模式用到的颜色
                    //                case 10://红色正在清扫的4*4区域
                    //                    mallocPoint[4*i]   = 255;//R
                    //                    mallocPoint[4*i+1] = 0;//G
                    //                    mallocPoint[4*i+2] = 0;//B
                    //                    mallocPoint[4*i+3] = 255;//A
                    //
                    //                    break;
                    //                case 11: //绿色已完成的4*4区域
                    //                    mallocPoint[4*i]   = 127;//R
                    //                    mallocPoint[4*i+1] = 255;//G
                    //                    mallocPoint[4*i+2] = 0;//B
                    //                    mallocPoint[4*i+3] = 255;//A
                    //                    break;
                    
                    //20190228用后门开关控制显示与不显示12-14去掉 由于for数据大，不在for内部判断,写两个for，在for外判断
                    
                default:
                    mallocPoint[4*i]   = 245;//R
                    mallocPoint[4*i+1] = 245;//G
                    mallocPoint[4*i+2] = 245;//B
                    mallocPoint[4*i+3] = 255;//A
                    break;
            }
        }
        
    }
}


//地图转化成img
+ (UIImage *)getImgWithRect:(CGRect)rect
              charPointRgba:(unsigned char*)rgba{
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //位图上下文构建
    CGContextRef bitmapContext = CGBitmapContextCreate(
                                                       rgba,
                                                       rect.size.width,
                                                       rect.size.height,
                                                       8, // bitsPerComponent每个颜色分量的位数（通常8）
                                                       4*rect.size.width, // bytesPerRow每行字节数，需对齐（stride）
                                                       colorSpace,//颜色空间引用
                                                       kCGImageAlphaPremultipliedLast);//包含alpha通道信息和字节序标志
    
    /**
     CGBitmapContextCreate( ,
     ,,8, bytesPerRow,
     colorSpace, uint32_t bitmapInfo)
     */
    
    CGContextSetLineCap(bitmapContext, kCGLineCapRound);
    CGContextSetAllowsAntialiasing(bitmapContext, true);
    CGContextSetShouldAntialias(bitmapContext, true);
    //    CGContextSetRenderingIntent(bitmapContext, kCGRenderingIntentPerceptual);
    
    
    ///--
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    UIImage *newUIImage = [UIImage imageWithCGImage:cgImage];
    CFRelease(colorSpace);//手动释放内存
    CGContextRelease(bitmapContext);
    free(rgba);
    //y轴镜像
    UIImage *newImgOk = [ToolOfBasic getYMirrorFlipWithImg:newUIImage];
    //    NSLog(@"y轴镜像");
    return newImgOk;
    
   
}

#pragma mark -----------------------------------------区域数据使用的开辟颜色空间--------
+ (NSMutableArray*)twoUseDataPMallocWithData:(NSData *)data
                             charPointMalloc:(unsigned char*)mallocPoint
                            arrOfChangeColor:(NSMutableArray*)arrOfChangeColor
                                           w:(int)w{
    
    NSMutableArray *arr = [NSMutableArray array];///成图的arr
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);//内存拷贝
    //处理arr
    for (int i = 0; i<len; i++) {
        
        switch (byteData[i]) {
            case 0://未探索
                
                [arr addObject:@"0"];
                break;
            case 1://已探索
                [arr addObject:@"1"];
                break;
            case 2:
                [arr addObject:@"2"];
                break;
            case 3:
                [arr addObject:@"3"];
                break;
            case 4:
                [arr addObject:@"4"];
                break;
            case 5://碰撞点
                [arr addObject:@"5"];
                break;
            case 6:
                [arr addObject:@"6"];
                break;
            case 7:
                [arr addObject:@"7"];
                break;
            case 8:
                [arr addObject:@"8"];
                break;
            case 9:
                [arr addObject:@"9"];
                break;
            default:
                [arr addObject:@"x"];
                break;
        }
        
    }
    
    //假数据 高221 宽250 3个区域的
    //    [arr removeAllObjects];
    //    for(int i = 0 ;i < 220*250+250;i++){
    //        if (i<50*250) {
    //            [arr addObject:@"0"];
    //        }else if (i<100*250){
    //             [arr addObject:@"1"];
    //        }else if (i<130*250+80){
    //            if (i%250>80) {
    //               [arr addObject:@"3"];
    //            }else{
    //               [arr addObject:@"2"];
    //            }
    //
    //        }else if (i<160*250+60){
    //             [arr addObject:@"3"];
    //        }else{
    //            [arr addObject:@"0"];
    //        }
    //    }
    //缝隙
     
  
    for (int i = w; i < arr.count-1-w; i++) {//不做第一排和最后一排
        //横向arr前后两个元素不同且不为0
        if (![arr[i] isEqual: arr[i+1]] && ![arr[i] isEqualToString:@"0"] && ![arr[i+1] isEqualToString:@"0"]) {
            [arr replaceObjectAtIndex:i withObject:@"0"];
            [arr replaceObjectAtIndex:i+1 withObject:@"0"];
        }
        
        //纵向arr对应img的上下像素元素不同且不为0 i+对应宽度和i-对应宽度
        if (![arr[i] isEqual: arr[i-w]] && ![arr[i] isEqualToString:@"0"] && ![arr[i-w] isEqualToString:@"0"]) {
            [arr replaceObjectAtIndex:i withObject:@"0"];
            [arr replaceObjectAtIndex:i-w withObject:@"0"];
        }
        if (![arr[i] isEqual: arr[i+w]] && ![arr[i] isEqualToString:@"0"] && ![arr[i+w] isEqualToString:@"0"]) {
            [arr replaceObjectAtIndex:i withObject:@"0"];
            [arr replaceObjectAtIndex:i+w withObject:@"0"];
        }
        
    }
    
    //处理img 区域数据的颜色部分
    /**
     
     */
    
    
    for (int i = 0; i < arr.count; i++) {//img
        
        switch ([arr[i] intValue]) {
            case 0://未探索
                
                mallocPoint[4*i]   = 0;//R
                mallocPoint[4*i+1] = 0;//G
                mallocPoint[4*i+2] = 0;//B
                mallocPoint[4*i+3] = 0;//A
                
                break;
            case 1://已探索
                if ([arrOfChangeColor[0]isEqualToString:@"1"]) {
                    //                        mallocPoint[4*i]   = 135;//R
                    //                        mallocPoint[4*i+1] = 57;//G
                    //                        mallocPoint[4*i+2] = 120;//B
                    //                        mallocPoint[4*i+3] = 255;//A
                    //淡黄色
                    mallocPoint[4*i]   = 255;//R
                    mallocPoint[4*i+1] = 253;//G
                    mallocPoint[4*i+2] = 161;//B
                    mallocPoint[4*i+3] = 255;//A
                }else{
                    mallocPoint[4*i]   = 125;//R
                    mallocPoint[4*i+1] = 125;//G
                    mallocPoint[4*i+2] = 125;//B
                    mallocPoint[4*i+3] = 255;//A
                }
                
                break;
            case 2:
                if ([arrOfChangeColor[1]isEqualToString:@"1"]) {
                    //                        mallocPoint[4*i]   = 70;//R
                    //                        mallocPoint[4*i+1] = 188;//G
                    //                        mallocPoint[4*i+2] = 62;//B
                    //                        mallocPoint[4*i+3] = 255;//A
                    //浅紫色
                    mallocPoint[4*i]   = 173;//R
                    mallocPoint[4*i+1] = 162;//G
                    mallocPoint[4*i+2] = 207;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                }else{
                    mallocPoint[4*i]   = 125;//R
                    mallocPoint[4*i+1] = 125;//G
                    mallocPoint[4*i+2] = 125;//B
                    mallocPoint[4*i+3] = 255;//A
                }
                
                
                break;
            case 3:
                if ([arrOfChangeColor[2]isEqualToString:@"1"]) {
                    //                        mallocPoint[4*i]   = 121;//R
                    //                        mallocPoint[4*i+1] = 134;//G
                    //                        mallocPoint[4*i+2] = 198;//B
                    //                        mallocPoint[4*i+3] = 255;//A
                    //浅粉色
                    mallocPoint[4*i]   = 237;//R
                    mallocPoint[4*i+1] = 156;//G
                    mallocPoint[4*i+2] = 174;//B
                    mallocPoint[4*i+3] = 255;//A
                }else{
                    mallocPoint[4*i]   = 125;//R
                    mallocPoint[4*i+1] = 125;//G
                    mallocPoint[4*i+2] = 125;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                }
                
                break;
            case 4:
                
                if ([arrOfChangeColor[3]isEqualToString:@"1"]) {
                    //                        mallocPoint[4*i]   = 222;//R
                    //                        mallocPoint[4*i+1] = 99;//G
                    //                        mallocPoint[4*i+2] = 55;//B
                    //                        mallocPoint[4*i+3] = 255;//A
                    //浅绿色
                    mallocPoint[4*i]   = 210;//R
                    mallocPoint[4*i+1] = 232;//G
                    mallocPoint[4*i+2] = 161;//B
                    mallocPoint[4*i+3] = 255;//A
                }else{
                    mallocPoint[4*i]   = 125;//R
                    mallocPoint[4*i+1] = 125;//G
                    mallocPoint[4*i+2] = 125;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                }
                
                
                break;
            case 5:
                
                if ([arrOfChangeColor[4]isEqualToString:@"1"]) {
                    //                        mallocPoint[4*i]   = 255;//R
                    //                        mallocPoint[4*i+1] = 40;//G
                    //                        mallocPoint[4*i+2] = 0;//B
                    //                        mallocPoint[4*i+3] = 255;//A
                    //亮绿色
                    mallocPoint[4*i]   = 138;//R
                    mallocPoint[4*i+1] = 198;//G
                    mallocPoint[4*i+2] = 109;//B
                    mallocPoint[4*i+3] = 255;//A
                }else{
                    mallocPoint[4*i]   = 125;//R
                    mallocPoint[4*i+1] = 125;//G
                    mallocPoint[4*i+2] = 125;//B
                    mallocPoint[4*i+3] = 255;//A
                    
                }
                
                
                break;
            case 6:
                if ([arrOfChangeColor[5]isEqualToString:@"1"]) {
                    //                        mallocPoint[4*i]   = 85;//R
                    //                        mallocPoint[4*i+1] = 85;//G
                    //                        mallocPoint[4*i+2] = 85;//B
                    //                        mallocPoint[4*i+3] = 255;//A
                    //灰蓝色深
                    mallocPoint[4*i]   = 71;//R
                    mallocPoint[4*i+1] = 130;//G
                    mallocPoint[4*i+2] = 193;//B
                    mallocPoint[4*i+3] = 255;//A
                }else{
                    mallocPoint[4*i]   = 125;//R
                    mallocPoint[4*i+1] = 125;//G
                    mallocPoint[4*i+2] = 125;//B
                    mallocPoint[4*i+3] = 255;//A
                }
                
                
                break;
            case 7:
                if ([arrOfChangeColor[6]isEqualToString:@"1"]) {
                    //                        mallocPoint[4*i]   = 119;//R
                    //                        mallocPoint[4*i+1] = 119;//G
                    //                        mallocPoint[4*i+2] = 119;//B
                    //                        mallocPoint[4*i+3] = 255;//A
                    //灰蓝色浅
                    mallocPoint[4*i]   = 133;//R
                    mallocPoint[4*i+1] = 198;//G
                    mallocPoint[4*i+2] = 214;//B
                    mallocPoint[4*i+3] = 255;//A
                }else{
                    mallocPoint[4*i]   = 125;//R
                    mallocPoint[4*i+1] = 125;//G
                    mallocPoint[4*i+2] = 125;//B
                    mallocPoint[4*i+3] = 255;//A
                }
                
                
                break;
                //7个区域划分+0=背景色
            case 8:
                mallocPoint[4*i]   = 127;//R
                mallocPoint[4*i+1] = 127;//G
                mallocPoint[4*i+2] = 127;//B
                mallocPoint[4*i+3] = 255;//A
                
                break;
            case 9:
                mallocPoint[4*i]   = 127;//R
                mallocPoint[4*i+1] = 127;//G
                mallocPoint[4*i+2] = 127;//B
                mallocPoint[4*i+3] = 255;//A
                
                break;
            default:
                mallocPoint[4*i]   = 127;//R
                mallocPoint[4*i+1] = 127;//G
                mallocPoint[4*i+2] = 127;//B
                mallocPoint[4*i+3] = 255;//A
                
                break;
        }
    }
    
    
    return arr;
    
}

#pragma mark -------------------- 冒泡升序排序 最大的放最后一个位置
+ (NSMutableArray *)bubbleAscendingOrderSortWithArray:(NSMutableArray *)ascendingArr
{
    //     NSLog(@"冒泡升序排序前：%@", ascendingArr);
    for (int i = 0; i < ascendingArr.count; i++) {
        for (int j = 0; j < ascendingArr.count - 1 - i;j++) {
            if ([ascendingArr[j+1]intValue] < [ascendingArr[j] intValue]) {
                int temp = [ascendingArr[j] intValue];
                ascendingArr[j] = ascendingArr[j + 1];
                ascendingArr[j + 1] = [NSNumber numberWithInt:temp];
            }
        }
    }
    //    NSLog(@"冒泡升序排序后结果：%@", ascendingArr);
    
    return ascendingArr;
}


#pragma mark ----------------------------------------- --------
//用已知画布大小画图
+ (UIImage *)combineTwoImgWithX:(int)mapImgX
                              y:(int)mapImgY
                              w:(int)w
                              h:(int)h
                       NewImage:(UIImage*)newImage
                        newPosx:(int)newPosx
                        newPosy:(int)newPosy
                           newW:(int)newW
                           newH:(int)newH
                    beforeImage:(UIImage*)beforeImage
                     beforePosx:(int)beforePosx
                     beforePosy:(int)beforePosy
                        beforeW:(int)beforeW
                        beforeH:(int)beforeH{
    //    NSLog(@"拼图--BigImage=----x=%d--y=%d,w=%d,h=%d",mapImgX,mapImgY,w,h);
    //    NSLog(@"拼图--newImage=%@----newPosx=%d--newPosy=%d",newImage,newPosx,newPosy);
    //    NSLog(@"拼图--beforeImage=%@----beforePosx=%d--beforePosy=%d",beforeImage,beforePosx,beforePosy);
    //    NSLog(@"拼图-- w=%d h=%d w=%d h=%d ----- ",beforeW,beforeH,newW,newH);
    //    NSLog(@"拼图");
    CGSize bigSize = CGSizeMake(w, h);
    UIGraphicsBeginImageContext(bigSize);
    
    
    //before
    //    CGFloat beforeWidth = beforeImage.size.width;
    //    CGFloat beforeHeight = beforeImage.size.height;
    //画before
    CGRect BeforeRect = CGRectMake(beforePosx,beforePosy,beforeW, beforeH);
    [beforeImage drawInRect:BeforeRect];
    
    
    //画newImg
    //new
    //    CGFloat newWidth = newImage.size.width;
    //    CGFloat newHeight = newImage.size.height;
    CGRect newRect = CGRectMake(newPosx,newPosy,newW, newH);
    
    [newImage drawInRect:newRect];
    
    UIImage* endImage  = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    NSData *d = UIImagePNGRepresentation(endImage);
    //    NSLog(@" ----img %@",endImage);
    //    NSLog(@" ----imgdata %@",d);
    return endImage;
    
}

@end
