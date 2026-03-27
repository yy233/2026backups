//
//  V.m
//  RobotSweeper
//
//  Created by Joey on 2018/4/23.
//  Copyright © 2018年 美超刘. All rights reserved.
//
#define BeginPoint @"BeginPoint"
#define EndPoint   @"EndPoint"
#import "V.h"

@implementation V
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
        self.numOfLine = 0;
        
        self.showDeletBtnOftag = 10;
        
        self.allLineArr = [NSMutableArray array];
         _canDraw = NO;
        _xmppstr = @"0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";//初始化
        UIColor* maincolor = [DataManager shareDataManager].colorOfMainType;
        _arrOfcolorInfo = [NSArray arrayWithArray:[ToolOfBasic getRGBAArrByUIColor:maincolor]];
        [self getArrAndNumLineOfThisRobot];
       
//        [self changecenterOfBackgroundView];
//        [self changeMapScap];
        
       
        
        
    }
    return self;
}

//取
#pragma mark -- 取
- (void)getArrAndNumLineOfThisRobot{
    
    NSString *jidStr = [ShareUser sharedUserInfo].userMode.nowRobotJid;
     
    self.allLineArr = [NSMutableArray array];//不再使用存到本地的数据了。初始化时之间全0；
    //没有这个robot的虚拟墙数据
    if (self.allLineArr.count==0) {
        self.allLineArr = [NSMutableArray array];
        for (int i = 0; i < 7; i ++) {//7对be 7条线
            NSArray* begPArr = @[@"0",@"0"];
            NSArray* endPArr = @[@"0",@"0"];
            NSDictionary *dicBandE = [NSDictionary dictionaryWithObjectsAndKeys:begPArr,BeginPoint,endPArr,EndPoint, nil];
            [self.allLineArr addObject:dicBandE];
        }
        _numOfLine = 0;
        self.saveAllLineArr = [NSMutableArray array];
        self.saveAllLineArr = [NSMutableArray arrayWithArray:self.allLineArr];
        self.sendxmppArr = [NSMutableArray array];
        self.sendxmppArr = [NSMutableArray arrayWithArray:self.allLineArr];
    }
    
    NSLog(@"    all  %@",self.allLineArr);
//    [self setNeedsDisplay];//1218
    [self xuNiQiangViewNeedDisplay];
    
}

//- (void)setAllLineArr:(NSMutableArray *)allLineArr{//会崩
//    if (allLineArr==nil||allLineArr.count==0) {
//
//        for (int i = 0; i < 7; i ++) {//7对be 7条线
//            NSArray* begPArr = @[@"0",@"0"];
//            NSArray* endPArr = @[@"0",@"0"];
//            NSDictionary *dicBandE = [NSDictionary dictionaryWithObjectsAndKeys:begPArr,BeginPoint,endPArr,EndPoint, nil];
//            [allLineArr addObject:dicBandE];
//        }
//        self.allLineArr = allLineArr;
//    }
//      self.allLineArr = allLineArr;
//}
- (void)changeCenter{
    
}
//倍数
- (void)changeMapScap:(CGFloat)mapScale{
     NSLog(@"pointxxxxxxxxxchangeMapScap ");
    NSLog(@"mapScale=%f",mapScale);
    if (mapScale!=1) {
        self.transform = CGAffineTransformIdentity;
        self.transform = CGAffineTransformScale(self.transform, mapScale, mapScale);
    }else{
        self.transform = CGAffineTransformIdentity;
    }
    
}
#pragma mark -- 

- (void)isWallCanDraw:(BOOL)walliscanDraw{
    _canDraw = walliscanDraw;
    NSLog(@"虚拟墙可编辑与不可编辑的切换");
    if (_canDraw) {
        _canDrawNum = 1;
        //切换到非编辑模式时保持要显示
        [self notice];
        
    }else{
        _showDeletBtnOftag = 10;//切换到非编辑模式时也要不显示
        if (_canDrawNum == 1) {
            //仅在切换状态时 计算后发送line数据。其他时不发数据只计算
            [self notice];
            [self sendXmppStr:_xmppstr];
        }
        _canDrawNum = 0;//初始化时的排除计量num
    }
  
    
}


#pragma mark -- 得到的虚拟墙数据初始化或者更新

- (void)initNewXNQData:(NSMutableArray*)arrOfGetData{//4*7=28个元素
    
    //center偏
    //img中心与00点坐标差
    CGFloat w = [DataManager shareDataManager].mapRightEnd - [DataManager shareDataManager].mapLeftEnd;
    CGFloat h = [DataManager shareDataManager].mapTopEnd - [DataManager shareDataManager].mapBottomEnd;
    int xC = [DataManager shareDataManager].mapRightEnd - w*0.5;
//    int yC = [DataManager shareDataManager].mapTopEnd - h*0.5;
    int yC = -[DataManager shareDataManager].mapBottomEnd - h*0.5;
    //缩放scmap
//    CGFloat scale = _mapScale;
//    //平移offsetx y
//    CGFloat offsetx = 0;
//    CGFloat offsety = 0;
    //处理数据
    
    
    //去除0
    int k = 0;
    
    if (arrOfGetData.count<=28) {
        //记下i
        for (int i = 0 ; i<7 ; i++) {//存在0000连着的即存在空余指标，不足7条线时
            
            if ([arrOfGetData[i*4+0] isEqualToString:@"0"] && [arrOfGetData[i*4+1] isEqualToString:@"0"] && [arrOfGetData[i*4+2] isEqualToString:@"0"] && [arrOfGetData[i*4+3] isEqualToString:@"0"]) {
            
                k = i*4+0;
                 break;//6条线=24
            }else{
                if (i == 6) {//需要这个判断，之前的防越界
                    k = 28;
                }else if(i == 7){//不存在这个数字 4*7+4>28
                }else{
                }
            }
            
        }
        //删除i
        NSMutableArray *arrOfGetNoZone = [NSMutableArray array];
        if (k!=0) {
            for (int j = 0; j < k; j++) {
                [arrOfGetNoZone addObject:arrOfGetData[j]];
            }
            arrOfGetData = [NSMutableArray arrayWithArray:arrOfGetNoZone];
            
        }else{//全0
            self.allLineArr = [NSMutableArray array];
            for (int i = 0; i < 7; i ++) {//7对be 7条线
                NSArray* begPArr = @[@"0",@"0"];
                NSArray* endPArr = @[@"0",@"0"];
                NSDictionary *dicBandE = [NSDictionary dictionaryWithObjectsAndKeys:begPArr,BeginPoint,endPArr,EndPoint, nil];
                [self.allLineArr addObject:dicBandE];
              
            }
            _numOfLine = 0;
//            [self setNeedsDisplay];//1218
             [self xuNiQiangViewNeedDisplay];

            return;
        }
      
        
        
    }else{//非28个有效数据则返回
        NSLog(@"respond_line 数据非28位数据=%@",arrOfGetData);
        return;
    }
    
    //处理有效数据
    NSMutableArray *arrOfnewWithDeal = [NSMutableArray array];
    for (int i = 0; i < arrOfGetData.count; i++) {
        CGFloat numOfdata = [[NSString stringWithFormat:@"%@",arrOfGetData[i]] floatValue];
        if (i%2==0) {//x
     
            numOfdata = numOfdata+self.bounds.size.width*0.5-xC;
        }else{//y
            numOfdata = -numOfdata+self.bounds.size.height*0.5-yC;//取负
        }
        [arrOfnewWithDeal insertObject:[NSString stringWithFormat:@"%f",numOfdata] atIndex:i];
    }

    
    /*                 endY:(int)endY{
     
     //self中心点和00点 原本是从00赋值farm会在缩放时变动 用bounds
     NSLog(@"newPoint framewh    %f %f",self.bounds.size.width,self.bounds.size.height);
     int xBegin = begX-self.bounds.size.width*0.5;
     int yBegin = begY-self.bounds.size.height*0.5;
     int xEnd = endX-self.bounds.size.width*0.5;
     int yEnd = endY-self.bounds.size.height*0.5;
     
     
     
     /
     
     int xB = xBegin + xC;
     int yB = yBegin + yC;
     
     
     int xE = xEnd + xC;
     int yE = yEnd + yC;
     
     
     //取负
     yB  = -yB;
     yE  = -yE;
*/
    
    //数据格式处理生成点
    NSMutableArray *arrOfNew = [NSMutableArray array];
    for (int i = 0; i < arrOfGetData.count/4; i++) {
        
        NSDictionary *dicBE = [NSMutableDictionary dictionary];
        NSArray *begParr = [NSArray arrayWithObjects:arrOfnewWithDeal[i*4+0],arrOfnewWithDeal[i*4+1], nil];
        NSArray *endParr = [NSArray arrayWithObjects:arrOfnewWithDeal[i*4+2],arrOfnewWithDeal[i*4+3], nil];
        [dicBE setValue:begParr forKey:BeginPoint];
        [dicBE setValue:endParr forKey:EndPoint];
        
        [arrOfNew addObject:dicBE];

    }
    //非有效数据的点0000
    if (arrOfNew.count<7) {
        _numOfLine = arrOfNew.count;
        int k = 7-arrOfNew.count;
        for (int i = 0; i < k; i++) {
            NSDictionary *dicBE = [NSMutableDictionary dictionary];
            NSArray *begParr = [NSArray arrayWithObjects:@"0",@"0", nil];
            NSArray *endParr = [NSArray arrayWithObjects:@"0",@"0", nil];
            [dicBE setValue:begParr forKey:BeginPoint];
            [dicBE setValue:endParr forKey:EndPoint];
            
            [arrOfNew addObject:dicBE];
        }
    }else{
        _numOfLine = 7;
    }
    self.allLineArr = arrOfNew;
//    [self setNeedsDisplay];//1218
     [self xuNiQiangViewNeedDisplay];
    
 
     
}

#pragma mark -- 画图
- (void)drawRect:(CGRect)rect {
    NSLog(@"_showDeletBtnOftag=%d",_showDeletBtnOftag);
    if (self.allLineArr.count!=7) {
        NSLog(@"allLineArr非7个元素时=%lu %@",(unsigned long)self.allLineArr.count,self.allLineArr );
        return;
    }
    int numOfFor = _numOfLine;
    if(_numOfLine>7){
        numOfFor = 7;
    }
//    for (int i = 0; i < _numOfLine; i++) {//在绘画时会出现_numofline=8的情况 使用for要用定值mun
     for (int i = 0; i < numOfFor; i++) {//0107
        NSDictionary *dicBE = self.allLineArr[i];
        NSArray *begParr = [dicBE objectForKey:BeginPoint];
        CGPoint begPoint = CGPointMake([begParr.firstObject floatValue] , [begParr.lastObject floatValue]);
        
        NSArray *endParr = [dicBE objectForKey:EndPoint];
        CGPoint endPoint = CGPointMake([endParr.firstObject floatValue] , [endParr.lastObject floatValue]);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, 1);  //线宽
        CGContextSetAllowsAntialiasing(context, true);//抗锯齿
         /**
          CGContextSetAllowsAntialiasing 是 Core Graphics 框架中的一个函数，用于‌设置图形上下文是否允许抗锯齿‌。但需要注意的是，‌仅设置该函数为 true 并不足以启用抗锯齿‌，还需配合 CGContextSetShouldAntialias 使用。
          */
        CGContextSetRGBStrokeColor(context, 255.0 / 255.0, 1.0 / 255.0, 1.0 / 255.0, 1.0);  //线的颜色
        
        //删除
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.frame= CGRectMake(0,0, 15, 15);
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = TAG_BTN_B+i;
//        [button setTitle:[NSString stringWithFormat:@"删%d",i]  forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"map_xuniqiang_shanchu"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
         
         CGPoint btnCenterP = CGPointMake([endParr.firstObject floatValue]-15, [endParr.lastObject floatValue]);
         float ExBxLine = [endParr.firstObject floatValue] - [begParr.firstObject floatValue];
         if (ExBxLine>-15 && ExBxLine<15 ) {//在【-15，15】内 btn不偏移
               btnCenterP = CGPointMake([endParr.firstObject floatValue], [endParr.lastObject floatValue]);
         }else{
             if (ExBxLine >0) {//左滑右 的绘画方式 则btn向左靠-
                 btnCenterP = CGPointMake([endParr.firstObject floatValue]-15, [endParr.lastObject floatValue]);
             }else{//+
                 btnCenterP = CGPointMake([endParr.firstObject floatValue]+15, [endParr.lastObject floatValue]);
             }
         }
        
         
         button.center = btnCenterP;
        
        
        if (self.subviews.count==0) {
            [self addSubview:button];//未有子视图的时候
           
            
        }else{
            //有子视图的时候
            
            BOOL haveB = NO; //是否有当前tag值所对应btn
           //有
            for (UIView *btn in self.subviews) {
                if (btn.tag==TAG_BTN_B+i) {
                    haveB = YES;//有deletB
                    btn.center = btnCenterP;
                    if (_canDraw) {//可绘画
                       btn.hidden = NO;
                    }else{//不可绘画 状态 0124 根据当前btn状态来显示
                        if (btn.hidden==YES) {
                             btn.hidden = YES;
                        }else{
                            btn.hidden = NO;
                        }
                        
                       
                    }
                    
                    
                }
                
 
            }
            //没有
            if (!haveB) {
                [self addSubview:button];
            }
        }
        
      
        if (i==_showDeletBtnOftag) {
            if (_arrOfcolorInfo.count<4) {
                 CGContextSetRGBStrokeColor(context, 178 / 255.0, 48 /255.0, 96 /255.0, 1.0);
            }else{
                  CGContextSetRGBStrokeColor(context, [_arrOfcolorInfo[0] floatValue], [_arrOfcolorInfo[1] floatValue],[_arrOfcolorInfo[2] floatValue],[_arrOfcolorInfo[3] floatValue]);
            }
          
        } else {
             CGContextSetRGBStrokeColor(context, 190 / 255.0, 190 /255.0, 190 /255.0, 1.0);
        }
 
        CGContextBeginPath(context);
        
        CGContextMoveToPoint(context, begPoint.x, begPoint.y);  //起点坐标
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);   //终点坐标
        
        CGContextStrokePath(context);
        
    }
    
    NSLog(@"draw线OK后处理btn");
    
    if (!_canDraw) {
        //        _showDeletBtnOftag = 10;//非画线状态下 使之不显示删除按钮的语句
        //点击事件的显示deleteBtn
         //key tag :obj rect
        NSMutableDictionary *dicOfdeletBtnInfo= [NSMutableDictionary dictionary];
        for (UIView *btn in self.subviews) {
            if (btn.tag == _showDeletBtnOftag+TAG_BTN_B) {
                if (btn.hidden == YES) {
                    btn.hidden = YES;
                }else{
                    btn.hidden = NO;
                }
              
            }else{
                 btn.hidden = YES;
            }
            if (btn.hidden ==NO) {//显示的btn才用于点击
                //0130 btn的 坐标 给到顶层
                CGRect deletBtnRect = btn.frame;
                [dicOfdeletBtnInfo setValue:[NSValue valueWithCGRect:deletBtnRect] forKey:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
            }
            
        }
        //
        if(self.vbtnInfoBlock != nil){
            NSLog(@"更新vbtnInfoBlock数据1");
            self.vbtnInfoBlock(dicOfdeletBtnInfo);
        }
        
    }else{
        //点击事件的显示deleteBtn
        //key tag :obj rect
        NSMutableDictionary *dicOfdeletBtnInfo= [NSMutableDictionary dictionary];
        for (UIView *btn in self.subviews) {
            if (btn.tag == _showDeletBtnOftag+TAG_BTN_B) {
                btn.hidden = NO;
            }else{
                btn.hidden = YES;
            }
            if (btn.hidden==NO) {
                //0130 btn的 坐标 给到顶层
             
                CGRect deletBtnRect = btn.frame;
                [dicOfdeletBtnInfo setValue:[NSValue valueWithCGRect:deletBtnRect] forKey:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
            }
            
        }
        //
        if(self.vbtnInfoBlock != nil){
             NSLog(@"更新vbtnInfoBlock数据2");
            self.vbtnInfoBlock(dicOfdeletBtnInfo);
        }
    }
    
}

#pragma mark -- okBtn
- (void)okbtnClick:(UIButton *)sender{
//    int i = sender.tag-TAG_BTN_C;
//    NSLog(@"点击了ok %d", i);
//    
//    for (UIView *btn in self.subviews) {
//        if (btn.tag-TAG_BTN_B == i) {
//            btn.hidden = YES;
//        }
//        if (btn.tag-TAG_BTN_C == i) {
//            btn.hidden = YES;
//        }
//    }
//    [self notice];
}
#pragma mark -- deletBtn删除线
- (void)btnClick:(UIButton *)sender{
    [self deletWithBtnTag:sender.tag];
}
//减去了TAG_BTN_B的剩余tag 0130也在wallQu使用
- (void)deletWithBtnTag:(int)deletBtnTag{
    int i = deletBtnTag-TAG_BTN_B;
    NSLog(@"点击了删除%d", i);
    //num-1
    //arr删
    //btn tag=i删 且 tag>i的都要-1；
    
    _numOfLine-=1;//
    NSLog(@"删除 第tag=%d条线 删后numOfLine共有线=%d",i,_numOfLine);
    NSArray* begPArr = @[@"0",@"0"];
    NSArray* endPArr = @[@"0",@"0"];
    NSDictionary *dicBandE = [NSDictionary dictionaryWithObjectsAndKeys:begPArr,BeginPoint,endPArr,EndPoint, nil];
    //
    
    [self.allLineArr removeObjectAtIndex:i];//arr
    [self.allLineArr addObject:dicBandE];//替换 tag之后刷新更换
    [self notice];//数据处理
    
    for (UIButton *btn in self.subviews) {//btn
        //删=
        if (btn.tag==TAG_BTN_B+i) {
            [btn removeFromSuperview];
        }
        
        //tag-1
        if(btn.tag>TAG_BTN_B+i){
            btn.tag-=1;
            [btn setTitle:[NSString stringWithFormat:@"删%ld",btn.tag-TAG_BTN_B]  forState:UIControlStateNormal];
        }
        
    }
    //    [self setNeedsDisplay];//刷新1218
    [self xuNiQiangViewNeedDisplay];
    for (UIButton *btn in self.subviews) {//btn
        btn.hidden = YES;
    }
    _showDeletBtnOftag = 10;
    
    [self notice];//计算新线
    [self sendXmppStr:_xmppstr];//发送新线
    
    
    
}
#pragma mark -- delet线直接发line信息
- (void)deletOneLine:(NSDictionary *)dicOfLine{
//    NSArray* begPArr =  [dicOfLine objectForKey:BeginPoint];
//    NSArray* endPArr = [dicOfLine objectForKey:EndPoint];
// 
//    
//    NSArray* newbegPArr =  [newDic objectForKey:BeginPoint];
//    NSArray* newendPArr = [newDic objectForKey:EndPoint];
//    
//    NSString *strOfDeletLine = [NSString stringWithFormat:@"line 0 %d %d %d %d",[newbegPArr.firstObject  intValue],[newbegPArr.lastObject  intValue],[newendPArr.firstObject  intValue],[newendPArr.lastObject  intValue]];
    //xmpp delet one Line
    //        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:strOfDeletLine];
    
}


#pragma mark -- touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSLog(@"————————————touchesBegan");
    _isGlineActionNum = 0;
    
    _numOfLine+=1;
    NSLog(@"这是第%d条线 numOfLine=%d touchesBegan",_numOfLine,_numOfLine);
//    if (_numOfLine>7) {//暂时7条
//        return;
//    }
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    
    int x = point.x;
    int y = point.y;
    NSLog(@"touchesBegan (x, y) is (%d, %d)", x, y);
    
    NSLog(@"%f , %f",self.center.x,self.center.y);
    NSArray *begP = @[[NSString stringWithFormat:@"%d",x],[NSString stringWithFormat:@"%d",y]];
    //重置线
    _dicOfNowbeginandEnd = [NSMutableDictionary dictionary];
    [_dicOfNowbeginandEnd setObject:begP forKey:BeginPoint];
    if (_numOfLine>7) {//暂时7条
        return;
    }
    
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    if (!_canDraw) {
        return;
    }
    NSLog(@"————————————touchesMoved");
    _isGlineActionNum += 1;
    NSLog(@"这是第%d条线 numOfLine=%d touchesMoved",_numOfLine,_numOfLine);
    if (_numOfLine>7) {//暂时7条
        return;
    }
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    
    int x = point.x;
    int y = point.y;
    
    
    
    //    NSLog(@"touchesMoved (x, y) is (%d, %d)", x, y);
    NSArray *movP = @[[NSString stringWithFormat:@"%d",x],[NSString stringWithFormat:@"%d",y]];
    
    [_dicOfNowbeginandEnd setObject:movP forKey:EndPoint];
    
    
    //存
    [self.allLineArr replaceObjectAtIndex:_numOfLine-1 withObject:_dicOfNowbeginandEnd];
    
    if (_canDraw) {
        // 重绘
        _showDeletBtnOftag = _numOfLine-1;//当前移动的这条线的btn可显示
        //        [self setNeedsDisplay];//1218
        [self xuNiQiangViewNeedDisplay];
    }
    
    
}


//endOrCancelTouch只执行其中一个
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"endOrCancelTouch———————touchesCancelled");
    [self endOrCancelTouch];
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"endOrCancelTouch—————————touchesEnded");
    [self endOrCancelTouch];
}

- (void)endOrCancelTouch{
    
    NSLog(@"endOrCancelTouch==be point%@",_dicOfNowbeginandEnd);
      NSLog(@"这是第%d条线 numOfLine=%d endOrCancelTouch",_numOfLine,_numOfLine);
    //区分动作 点击|移动==》区分是否在划线
    //移动过的线段长度<某值不加此线
    if (_isGlineActionNum>0) {
        NSArray *begArr = [_dicOfNowbeginandEnd objectForKey:BeginPoint];
        NSArray *endArr = [_dicOfNowbeginandEnd objectForKey:EndPoint];
        CGFloat lineDistance = [ToolOfBasic getLineDustanceApToBpWithPa:CGPointMake([begArr.firstObject floatValue], [begArr.lastObject floatValue]) pb:CGPointMake([endArr.firstObject floatValue], [endArr.lastObject floatValue])];
        NSLog(@"移动过的线段 lineDistance = %f",lineDistance);
        
        if (lineDistance<20.0) {
            NSLog(@"GMoveNum %d",_isGlineActionNum);
            NSLog(@"lineDistance<10  =%f",lineDistance);
            _isGlineActionNum = 0;
            
        }else{
            NSLog(@"GMoveNum %d",_isGlineActionNum);
            NSLog(@"lineDistance==%f",lineDistance);
            
        }
    }
    
    
    //点击操作linenum=8不用减arr 放到后面减
    if (_isGlineActionNum>0) {
        NSLog(@"画线操作");
        if (_canDraw) {
//            [self setNeedsDisplay];;//刷新1218
             [self xuNiQiangViewNeedDisplay];
            [self notice];
        }else{
            //非可画线时的画线操作应该置空
            NSArray *movP = @[@"0",@"0"];
            [_dicOfNowbeginandEnd setObject:movP forKey:BeginPoint];
            [_dicOfNowbeginandEnd setObject:movP forKey:EndPoint];
            //删btn
            for (UIView *btn in self.subviews) {
                if (btn.tag == _numOfLine-1+TAG_BTN_B) {
                    [btn removeFromSuperview];
                }
                
            }
            //存00
            [self.allLineArr replaceObjectAtIndex:_numOfLine-1 withObject:_dicOfNowbeginandEnd];
//            [self setNeedsDisplay];;//刷新
             [self xuNiQiangViewNeedDisplay];//1218
            [self notice];
           
            
        }
        
        
    }else{
        NSLog(@"点击操作");
        if (_canDraw) {
            
        }else{
            //删btn
            for (UIView *btn in self.subviews) {
                if (btn.tag == _numOfLine-1+TAG_BTN_B) {
                    [btn removeFromSuperview];
                }
            }
        }
       
        
         NSDictionary *dicOfThisBandE = [NSDictionary dictionaryWithDictionary:_dicOfNowbeginandEnd];//留下当前点击事件的点

        if (0<_numOfLine&&_numOfLine<=7) {//1-7条的点击事件不刷新UI num=8不做替换操作
            //deletArr
            NSArray *movP = @[@"0",@"0"];
            [_dicOfNowbeginandEnd setObject:movP forKey:BeginPoint];
            [_dicOfNowbeginandEnd setObject:movP forKey:EndPoint];
            //存00
            [self.allLineArr replaceObjectAtIndex:_numOfLine-1 withObject:_dicOfNowbeginandEnd];
            NSLog(@"元素%@，_allArr = %@",self.allLineArr[_numOfLine-1],self.allLineArr);
            
            _numOfLine-=1;
//            [self setNeedsDisplay];;//刷新1218
             [self xuNiQiangViewNeedDisplay];
            [self notice];//数据处理
    
        }
         [self topActionWithDic:dicOfThisBandE];//点击事件显示隐藏按钮
        
    }
    //_numOfLine 计数linenum=8-1
    if (_numOfLine>7) {//暂时7条
        _numOfLine-=1;
        return;
    }
    
}
#pragma mark -- topAction
- (void)topActionWithDic:(NSDictionary*)dic{
    //点到线的距离计算
    //存起来比较
    
    NSMutableArray *getLineArr = [NSMutableArray array];
    NSArray *lineOfTapArr = [dic objectForKey:BeginPoint];
    for (int i = 0; i<self.allLineArr.count; i++) {
        
        NSArray *begArr = [self.allLineArr[i] objectForKey:BeginPoint];
        NSArray *endArr = [self.allLineArr[i] objectForKey:EndPoint];
        
        if ([begArr.firstObject intValue]==0&&[begArr.lastObject intValue]==0&&[endArr.firstObject intValue]==0&&[endArr.lastObject intValue]==0) {
            break;
        }
        CGPoint begP = CGPointMake([begArr.firstObject floatValue], [begArr.lastObject floatValue]);
        CGPoint endP = CGPointMake([endArr.firstObject floatValue], [endArr.lastObject floatValue]);
        CGPoint tapP = CGPointMake([lineOfTapArr.firstObject floatValue], [lineOfTapArr.lastObject floatValue]);
        NSLog(@"%f %f , %f %f , %f %f",begP.x,begP.y,endP.x,endP.y,tapP.x,tapP.y);
//        CGFloat lineee = [ToolOfBasic pedalWithBeginPoint:begP endPoint:endP tapPoint:tapP];//1229点到直线换成以下
        CGFloat lineee = [ToolOfBasic calDisWithBeginPointX:begP.x BeginPointY:begP.y EndPointX:endP.x EndPointY:endP.y tapPointX:tapP.x tapPointY:tapP.y];//1229点到线段
        NSLog(@"lineeee 得到线长 =%f",lineee);
//        NSLog(@"nowDis = %f",[ToolOfBasic calDisWithBeginPointX:begP.x BeginPointY:begP.y EndPointX:endP.x EndPointY:endP.y tapPointX:tapP.x tapPointY:tapP.y]);//
        if (lineee<0) {
            lineee = -lineee;//全至为正数好用于比较
//             NSLog(@"lineeee正  =%f",lineee);
        }
        [getLineArr addObject:[NSString stringWithFormat:@"%f",lineee]];
//         NSLog(@"getLineArr正  =%@",getLineArr);

    }//这是一个大循环结束
   
    NSMutableArray *willPaixu = [NSMutableArray arrayWithArray:getLineArr];
    NSMutableArray *getLineArrOfPaiXu = [NSMutableArray arrayWithArray:[ToolOfBasic bubbleAscendingOrderSortWithArray:willPaixu]];
//     NSLog(@"getLineArrOfPaiXu正  =%@",getLineArrOfPaiXu);
//     NSLog(@"getLineArr正  =%@",getLineArr);
//     NSLog(@"willPaixu正  =%@",willPaixu);
    CGFloat lineee = [getLineArrOfPaiXu.firstObject floatValue];//无论正负都是最小的一个
      /*指定线 排大小取最小的值判断>-30<30就取下标否则10*/
    if (lineee<=10) {//变小点不容易点击
        if (!_canDraw) {
            return;// 非虚拟墙状态 0220改为不出现删除按钮
        }
        NSInteger i = [getLineArr indexOfObject:[NSString stringWithFormat:@"%f",lineee]];//下标
        
        for (UIView *btn in self.subviews) {
            if (btn.tag==i+TAG_BTN_B) {//显示删除按钮
                btn.hidden = NO;
                NSLog(@"显示删除按钮%ld",(long)i);
                _showDeletBtnOftag = i;
                break;
            }
        }

    }else{
        for (UIView *btn in self.subviews) {
            btn.hidden = YES;
            _showDeletBtnOftag = 10;
    
        }
    }
    
//    [self setNeedsDisplay];//点击所在的线才显示其余更新隐藏 1218
     [self xuNiQiangViewNeedDisplay];
  
    
     
  

}

#pragma mark -- notice
- (void)notice{
    NSLog(@"notice方法");
    
    //1本地 存的数据 不存了这东西时时更新
   // [self dataManagerSaveOfThisRobotWall];
    //2xmpp
    _xmppstr = [self suanXmppWillUseData];
    /**1.画xy
     x-0.5w+xc取正
     y-0.5h+yc取负
     2.得到的相反即可xy
     +x+0.5w-xc
     -y+0.5h-yc
                                           
     */
    //3xmppSend
     //[self sendXmppStr:_xmppstr]
}


#pragma mark -- 存当前的图像坐标数据
- (void)dataManagerSaveOfThisRobotWall{
    //save {jid+虚拟arr,jid+arr}//得到确认信息后存
    self.saveAllLineArr = [NSMutableArray array];
    self.saveAllLineArr = [NSMutableArray arrayWithArray:self.allLineArr];
    NSString *jidStr = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    
    NSMutableDictionary *newDic = [@{jidStr:_saveAllLineArr} mutableCopy];
    NSMutableArray *wallArrSource = [NSMutableArray arrayWithArray:[DataManager shareDataManager].wallArrDataSource];//全部robot的wall数据
    
    for (int i = 0; i <wallArrSource.count; i++) {//去旧
        NSDictionary *dict = wallArrSource[i];
        if([[dict allKeys] containsObject:jidStr]){//存在当前jid的wall数据
            [wallArrSource removeObjectAtIndex:i];
            
        }
    }
    [wallArrSource addObject:newDic];//加新
    [DataManager shareDataManager].wallArrDataSource = [NSArray arrayWithArray:wallArrSource];
    NSLog(@"wallArrDataSource=%@",[DataManager shareDataManager].wallArrDataSource);
    
    //数据持久化
    
    [self dataDefaultsSave:[NSArray arrayWithArray:wallArrSource]];
}
- (void)dataDefaultsSave:(NSArray*)arr{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:arr forKey:K_XUNIQIANG];
}

#pragma mark -- 算xmpp将要传的数据
- (NSString *)suanXmppWillUseData{
    
    
    //0初值xmpp
    NSString *strOfXmppData = @"";
    self.sendxmppArr = [NSMutableArray array];
    self.sendxmppArr = [NSMutableArray arrayWithArray: self.allLineArr];
    [self sendXmppArrSuan];//xmpparr计算后替换更新
    
    strOfXmppData = [self sendxmppArrpBecomeStr];//拼接成串
    NSLog(@"str =%@",strOfXmppData);
    
    
    return strOfXmppData;
}


#pragma mark -- 移动
- (void)sendXmppArrSuan{
    
    for (int i = 0; i <7; i++) {
        NSArray* beginParr = [self.allLineArr[i] objectForKey:BeginPoint];
        NSArray* endParr = [self.allLineArr[i] objectForKey:EndPoint];
        int begX = [beginParr.firstObject intValue];
        int begY = [beginParr.lastObject intValue];
        
        int endX = [endParr.firstObject intValue];
        int endY = [endParr.lastObject intValue];
        if (begX==0&&begY==0&&endX==0&&endY==0) {
            //0000不更新坐标xmpparr
            break;
        }else{//非空 更新坐标xmpparr
            [self suanWithbegX:begX begY:begY endX:endX endY:endY i:i];
        }
    }
    
}

#pragma mark -- 计算arr

#pragma mark -- suan
- (void)suanWithbegX:(int)begX
                begY:(int)begY
                endX:(int)endX
                endY:(int)endY
                   i:(int)i{
    
    NSDictionary *dic = [self newPointMoveOrNotMoveDicWithbegX:begX begY:begY endX:endX endY:endY];//ismove
    [self.sendxmppArr replaceObjectAtIndex:i withObject:dic];
    
    
}

//移动的dic
//未移动时的dic
- (NSDictionary *)newPointMoveOrNotMoveDicWithbegX:(int)begX
                                              begY:(int)begY
                                              endX:(int)endX
                                              endY:(int)endY{
    
    //self中心点和00点 原本是从00赋值farm会在缩放时变动 用bounds
    NSLog(@"newPoint framewh    %f %f",self.bounds.size.width,self.bounds.size.height);
    int xBegin = begX-self.bounds.size.width*0.5;
    int yBegin = begY-self.bounds.size.height*0.5;
    int xEnd = endX-self.bounds.size.width*0.5;
    int yEnd = endY-self.bounds.size.height*0.5;
    
    
    
    //img中心与00点坐标差
    CGFloat w = [DataManager shareDataManager].mapRightEnd - [DataManager shareDataManager].mapLeftEnd;
    CGFloat h = [DataManager shareDataManager].mapTopEnd - [DataManager shareDataManager].mapBottomEnd;
    int xC = [DataManager shareDataManager].mapRightEnd - w*0.5;
//    int yC = [DataManager shareDataManager].mapTopEnd - h*0.5;
    int yC = -[DataManager shareDataManager].mapBottomEnd - h*0.5;
    
    int xB = xBegin + xC;
    int yB = yBegin + yC;
    
    
    int xE = xEnd + xC;
    int yE = yEnd + yC;
    
    
    //取负
    yB  = -yB;
    yE  = -yE;
    NSLog(@"arr->xmpparr  ==坐标===point  x%d y%d , x%d y%d ",begX,begY,endX,endY);
    NSLog(@"arr->xmpparr  ===== xb%d yb%d xe%d ye%d",xBegin,yBegin,xEnd,yEnd);

    NSLog(@"arr->xmpparr  ===坐标ok== xb%d yb%d ,xe%d ye%d ",xB,yB,xE,yE);
    
    NSArray *bArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",xB] ,[NSString stringWithFormat:@"%d",yB],nil];
    NSArray *eArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",xE] ,[NSString stringWithFormat:@"%d",yE],nil];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:bArr,BeginPoint,eArr,EndPoint, nil];
    return dic;
    
}


#pragma mark -- 拼接str

- (NSString *)sendxmppArrpBecomeStr{
    
    NSString *xmppStr = @"";
    
    for (int i = 0; i <7; i++) {
        NSArray* beginParr = [self.sendxmppArr[i] objectForKey:BeginPoint];
        NSArray* endParr = [self.sendxmppArr[i] objectForKey:EndPoint];
        int begX = [beginParr.firstObject intValue];
        int begY = [beginParr.lastObject intValue];
        
        int endX = [endParr.firstObject intValue];
        int endY = [endParr.lastObject intValue];
        
        //        if (begX==0&&begY==0&&endX==0&&endY==0) {
        //
        //
        //            xmppStr = [NSString stringWithFormat:@"%@ 0 %d %d %d %d",xmppStr,begX ,begY,endX,endY];//拼接0000
        //                break;//00数据 无线
        //        }else{//非空 计算坐标
        //            xmppStr = [NSString stringWithFormat:@"%@ %d %d %d %d",xmppStr,begX ,begY,endX,endY];
        //        }
        if (xmppStr.length==0){//第一个循环时无xmppstr数据 不拼接“”+空格
            xmppStr = [NSString stringWithFormat:@"%d %d %d %d",begX ,begY,endX,endY];
        }else{
            xmppStr = [NSString stringWithFormat:@"%@ %d %d %d %d",xmppStr,begX ,begY,endX,endY];
        }
        
    }
    return xmppStr;
    
}
- (void)sendXmppStr:(NSString *)str{
    if (_xmppstr.length==0) {
       _xmppstr = @"0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0";
    }
    
    str = [NSString stringWithFormat:@"line %@",str];
    
    NSLog(@"xmpp将要传的数据 %@ 长度%lu",str,(unsigned long)str.length);
    
     [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:str];
     [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:str];
    
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_map"];
//    [self delaySend:str];//这个会造成发送后数据从扫地机中回来的情况
    //增与删都要走这个方法
    //删除--通知map的虚拟墙num=5;
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"xiniqiangNotificationSendAllLine" object:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"xiniqiangNotificationSendAllLine" object:str];//1229新增 line串
}

- (void)delaySend:(NSString *)strOfwall{
   _delaySendInt = 0;
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(sendStrOfWallAndRequestMapMethod:) userInfo:strOfwall repeats:YES];
    /**
     __block int i = 0;
    [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"strOfwall   发送虚拟墙后的延时%d",i);
        i+=1;
        if (i==3) {
            [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_map"];
            [timer invalidate];
             timer = nil;
        }else{
            [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:strOfwall];
            
        }
    }];
     */
}
- (void)sendStrOfWallAndRequestMapMethod:(NSTimer *)timer{
    NSLog(@"strOfwall   发送虚拟墙后的延时%d",_delaySendInt);
    _delaySendInt+=1;
    if (_delaySendInt==3) {
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_map"];
        [timer invalidate];
        timer = nil;
    }else{
        NSString* strOfwall = [NSString stringWithFormat:@"%@",timer.userInfo];
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:strOfwall];
        
    }
}


#pragma mark -- 1218虚拟墙数据可以画，可以发送，但是ui没有显示（本机没有显示，其他机子有显示，关掉扫地机后开启，则可以画了） 预测也许是其他原因／是没调用draw方法（虽然没有主线程卡顿感 主线程不做setneeddisplay可能性小 ） 1219回到列表主页后闪退，然后点开app后能够划线，有可能是主线程占比过多等线程问题 2019补充line发送存储的数据多了个空格引起的数据格式不更新UI
- (void)xuNiQiangViewNeedDisplay{//在主线程调用 setNeedsDisplay
    [self performSelector:@selector(setUiDarw) withObject:nil afterDelay:0.1];
}
- (void)setUiDarw{
    [self setNeedsDisplay];
}


#pragma mark -- --------------区域View使用层级 区别于V.m
@end
