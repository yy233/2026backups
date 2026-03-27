//
//  WallView.m
//  地图画图区域试写
//
//  Created by Joey on 2018/11/20.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "WallQuyuView.h"
#import "QuBtn.h"
#import "ToolOfQuYuV.h"
#import "MapDataTool.h"

#define SpecialAreaBegPKey @"SpecialAreaBegPKey"
#define SpecialAreaEndPKey @"SpecialAreaEndPKey"
//   一个专扫区 三个禁扫区

////// 300 310 320-327
#define AllowedBtnTag 300           //允许区 btnView
#define AllowedDeletBtnTag 310           //允许区 删除按钮
#define AllowedZoomBtnTag 320           //允许区 缩放按钮
//0212新增label显示宽高
#define AllowedLabelShowWHTag 330           //允许区 label显示


//#define ForbiddenBtnTag 400         //禁止区 btnView
//#define ForbiddenDeletBtnTag 410    //禁止区 删除按钮
//#define ForbiddenZoomBtnTag 420     //禁止区 缩放按钮 420-427 8个方向

//0212新增label显示宽高
//#define ForbiddenLabelShowWHTag 430           //允许区 label显示

////// 400 410 420-427 430
////// 500 520 520-527 530
////// 600 610 620-627 630
//4 5 6 7 8 9 10 11
//20190325新加到5个禁扫区 暂时不做10 11等高位屏蔽


@interface WallQuyuView()
@property (nonatomic,strong)NSMutableDictionary *specialAreaDic;
@property (nonatomic,strong)NSMutableArray *arrOfNowSpeciaBEPoint;
@property (nonatomic,assign) int nowTypeOfDetailTagMaxNum;//当前操作区 0初始 专扫3(现用在定点数据处) 禁扫 4 5 6
@property (nonatomic,assign) int isAllowOrForbidNum;//0 初始 1 专扫 2 禁止区


@end

@implementation WallQuyuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isAllowOrForbidNum = 0;///0 初始 1 2
         _nowTypeOfDetailTagMaxNum = 0;//初始  3 4 5 6
        _specialAreaDic = [NSMutableDictionary dictionary];
        _arrOfNowSpeciaBEPoint = [NSMutableArray array];
        _allowedDataArr = [NSMutableArray array];
        _forbiddenDataArr = [NSMutableArray array];
        _vdeletBtnRectArr = [NSMutableArray array];
        _vdeletBtnTagArr = [NSMutableArray array];
        [self addges];
        _subBtnIsShow = NO;//初始状态 sub不显示
        
    }
    return self;
}

- (void)addges{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gesOfWallQuTapGes:)];
    [self addGestureRecognizer:tapGes];
}

//倍数
- (void)changeQuVScap:(CGFloat)mapScale{
    NSLog(@"pointxxxxxxxxxchangeMapScap ");
    NSLog(@"mapScale=%f",mapScale);
    if (mapScale!=1) {
        self.transform = CGAffineTransformIdentity;
        self.transform = CGAffineTransformScale(self.transform, mapScale, mapScale);
    }else{
        self.transform = CGAffineTransformIdentity;
    }
    _saveMapScale = mapScale;
    
    if (_allowedDataArr.count>0) {
        
    }
    if (_forbiddenDataArr.count>0) {
//        [self setNeedsDisplay];//主要用于更新label
    }
 
    
}

#pragma mark --删除按钮的显示隐藏
- (void)quyuBtnSubBtnIsShow:(BOOL)isShow{
        _subBtnIsShow = isShow;
    for (UIView *subV in self.subviews) {
        if (isShow) {
            subV.hidden = NO;
        }else{//非虚拟墙编辑状态 隐藏
            if(subV.tag%100>0){
                 subV.hidden = YES;
            
            }else{
                 subV.hidden = NO;
            }
            
        }
       
    }
}
#pragma mark --  定时更新
- (void)updataViewUI{
    [self setNeedsDisplay];
}
#pragma mark -- vline 的deletbtnINFO
- (void)getBtnInfoDic:(NSMutableDictionary*)dicOfDeletInfo{
    _vdeletBtnRectArr = [NSMutableArray arrayWithArray:[dicOfDeletInfo allValues]];
    _vdeletBtnTagArr =  [NSMutableArray arrayWithArray:[dicOfDeletInfo allKeys]];
    NSLog(@"虚拟墙的deletbtnINFO _vdeletBtnRectArr %@ \n _vdeletBtnTagArr %@",_vdeletBtnRectArr,_vdeletBtnTagArr);
}

//        _isAllowOrForbidNum = 2;//禁扫
//        _nowTypeOfDetailTagMaxNum = 4;//禁扫 4 5 6
#pragma mark -- 得到了xmpp当前数据
- (void)getQuyuXmppStr:(NSString*)strOfxmpp{
    /**
     专扫区域：area_allow 数量 左上 右下
     禁扫区域：area_ban 数量    左上 右下 左上 右下 左上 右下
     */
    if (strOfxmpp.length==0) {
        return;
    }
    

//    NSLog(@"得到了xmpp当前数据getQuyuXmppStr %@",strOfxmpp);
    NSMutableArray *arrOfgetXmppData = [NSMutableArray arrayWithArray:[strOfxmpp componentsSeparatedByString:@" "]];
    
 
    CGFloat banboundW = self.bounds.size.width*0.5;
    CGFloat banboundH =self.bounds.size.height*0.5;
//    NSLog(@"坐标转化部分self.boubds %f %f",self.bounds.size.width,self.bounds.size.height);
    //地图原点与center点的差值
    CGPoint pointImgOriginPointAndCenterPoint = [MapDataTool mapImgOriginPointAndCenterPointRelativeCoordinates];
    CGFloat xC = pointImgOriginPointAndCenterPoint.x;
    CGFloat yC = pointImgOriginPointAndCenterPoint.y;
//    CGFloat xQu-xc +0.5bound = x;
//    CGFloat -yQu-yc+0.5bound = y;
  
    //专扫
    if ([arrOfgetXmppData.firstObject isEqualToString:@"area_allow"]||[arrOfgetXmppData.firstObject isEqualToString:@"area_allow"]) {
        [arrOfgetXmppData removeObjectAtIndex:0];//去掉协议头
        [arrOfgetXmppData removeObjectAtIndex:0];//去掉协议第二位 （区域个数位）
        if(arrOfgetXmppData.count<4){
            NSLog(@"area_allow数据错误");
            return;
        }
        if ([arrOfgetXmppData[0] isEqualToString:@"0"]&&[arrOfgetXmppData[1] isEqualToString:@"0"]&&[arrOfgetXmppData[2] isEqualToString:@"0"]&&[arrOfgetXmppData[3] isEqualToString:@"0"]) {//全 0
            _allowedDataArr = [NSMutableArray array];//不添加数据0
        }else{
          _allowedDataArr = [NSMutableArray array];
//         NSMutableDictionary *dicOfThisP = [NSMutableDictionary dictionary];
//            CGPoint bp = CGPointMake([arrOfgetXmppData[0] intValue], [arrOfgetXmppData[1] intValue]);
//            CGPoint ep = CGPointMake([arrOfgetXmppData[3] intValue], [arrOfgetXmppData[4] intValue]);
//            [dicOfThisP setValue:[NSValue valueWithCGPoint:bp] forKey:SpecialAreaBegPKey];
//            [dicOfThisP setValue:[NSValue valueWithCGPoint:ep] forKey:SpecialAreaEndPKey];
            
//         NSString *oneS = [NSString stringWithFormat:@"%f", ([arrOfgetXmppData[0] intValue]-xC+banboundW )];
//         NSString *twoS = [NSString stringWithFormat:@"%f", (-[arrOfgetXmppData[1] intValue]-yC+banboundH)];
//        NSString *thrS = [NSString stringWithFormat:@"%f", ([arrOfgetXmppData[2] intValue]-xC+banboundW)];
//        NSString *fourS = [NSString stringWithFormat:@"%f", (-[arrOfgetXmppData[3] intValue]-yC+banboundH)];
//            NSString *strOfXmppFourAllowedStr = [NSString stringWithFormat:@"%@ %@ %@ %@",arrOfgetXmppData[0],arrOfgetXmppData[1],arrOfgetXmppData[2],arrOfgetXmppData[3]];
            NSString *strOfXmppFourAllowedStr = [arrOfgetXmppData componentsJoinedByString:@" "];
          [_allowedDataArr addObject: [self getScreenPointDicWithXmppStr:strOfXmppFourAllowedStr]];
         [self setNeedsDisplay];
        }
    }
    //禁止扫
    if([arrOfgetXmppData.firstObject isEqualToString:@"area_ban"]||[arrOfgetXmppData.firstObject isEqualToString:@"area_ban"]){
        
        _forbiddenXmppStr = strOfxmpp;
          [arrOfgetXmppData removeObjectAtIndex:0];//去掉协议头
          [arrOfgetXmppData removeObjectAtIndex:0];//去掉协议第二位 （区域个数位）
        if (arrOfgetXmppData.count<12) {
            NSLog(@"area_ban 数据错误");
            return;
        }
        _forbiddenDataArr = [NSMutableArray array];
        for (int i = 0; i<3; i++) {//最多3个禁止区
            if ([arrOfgetXmppData[0+i*4] isEqualToString:@"0"]&&[arrOfgetXmppData[1+i*4] isEqualToString:@"0"]&&[arrOfgetXmppData[2+i*4] isEqualToString:@"0"]&&[arrOfgetXmppData[3+i*4] isEqualToString:@"0"]) {//全 0
                //不添加0数据
            }else{
//                NSString *oneS = [NSString stringWithFormat:@"%f", ([arrOfgetXmppData[0+i*4] intValue]-xC+banboundW)];
//                NSString *twoS = [NSString stringWithFormat:@"%f", (-[arrOfgetXmppData[1+i*4] intValue]-yC+banboundH)];
//                NSString *thrS = [NSString stringWithFormat:@"%f", ([arrOfgetXmppData[2+i*4] intValue]-xC+banboundW)];
//                NSString *fourS = [NSString stringWithFormat:@"%f", (-[arrOfgetXmppData[3+i*4] intValue]-yC+banboundH)];
//                [_forbiddenDataArr addObject: [self getDicOfFourStr:oneS bStr:twoS cStr:thrS dStr:fourS]];
//                NSLog(@"_farr = %@",_forbiddenDataArr);
                //
                NSString *oneS = [NSString stringWithFormat:@"%d", [arrOfgetXmppData[0+i*4] intValue]];
                NSString *twoS = [NSString stringWithFormat:@"%d", [arrOfgetXmppData[1+i*4] intValue]];
                NSString *thrS = [NSString stringWithFormat:@"%d", [arrOfgetXmppData[2+i*4] intValue]];
                NSString *fourS = [NSString stringWithFormat:@"%d", [arrOfgetXmppData[3+i*4] intValue]];
                NSString *strOfThisFour = [NSString stringWithFormat:@"%@ %@ %@ %@",oneS,twoS,thrS,fourS];
               [_forbiddenDataArr addObject:[self getScreenPointDicWithXmppStr:strOfThisFour]] ;
            }
            
        }
    }
   
    [self setNeedsDisplay];

}


#pragma mark -- 新增arr部分
- (void)addNewAllowQu{
    if (_allowedDataArr.count>=1) {
        NSLog(@"专扫区数据已满");
         _isAllowOrForbidNum=0;
        _nowTypeOfDetailTagMaxNum=0;
        _specialAreaDic = [NSMutableDictionary dictionary];
    }else{
        _isAllowOrForbidNum=1;
        _nowTypeOfDetailTagMaxNum=3;//增专扫
        NSMutableDictionary *dicOfSave = [self addNewQuOfinitSpecialNewDic];
        _specialAreaDic = [NSMutableDictionary dictionaryWithDictionary:dicOfSave];
        [_allowedDataArr addObject:dicOfSave];
        
    }
    [self setNeedsDisplay];
}
- (void)addNewForbiddenQu{
    if (_forbiddenDataArr.count>=5) {
        NSLog(@"禁止区数据已满");
        _isAllowOrForbidNum=0;
        _nowTypeOfDetailTagMaxNum=0;
        _specialAreaDic = [NSMutableDictionary dictionary];
       
    }else{
        _isAllowOrForbidNum=2;
        _nowTypeOfDetailTagMaxNum=(int)_forbiddenDataArr.count+4;//0 1 2 3 -tag 4 5 6
         //其他viewBtn 置为非点击状态
 
        //增
        NSMutableDictionary *dicOfSave = [self addNewQuOfinitSpecialNewDic];
        _specialAreaDic = [NSMutableDictionary dictionaryWithDictionary:dicOfSave];
        [_forbiddenDataArr addObject:dicOfSave];//新增
    }
     [self setNeedsDisplay];
}
#pragma mark -- 初始化 新增 dic部分 _nowTypeOfDetailTagMaxNum
- (NSMutableDictionary*)addNewQuOfinitSpecialNewDic{
    //更新数据 drawRc
    CGPoint bp = CGPointMake(self.center.x-_nowTypeOfDetailTagMaxNum*10,self.center.y-_nowTypeOfDetailTagMaxNum*10);
    CGPoint ep = CGPointMake(self.center.x-_nowTypeOfDetailTagMaxNum*10+50,self.center.y-_nowTypeOfDetailTagMaxNum*10+50);//初始宽为50 xy坐标3456隔开偏移位置展示时都要可见
      NSMutableDictionary *rdic = [NSMutableDictionary dictionary];
    [rdic setValue:[NSValue valueWithCGPoint:bp] forKey:SpecialAreaBegPKey];
    [rdic setValue:[NSValue valueWithCGPoint:ep] forKey:SpecialAreaEndPKey];
    return rdic;//返回用于arr
}

#pragma mark --  specialDic ----> 计算 btn Rect
- (CGRect)getRectOfSpecialDic:(NSMutableDictionary *)specialDic{
    CGPoint begP =  [[specialDic objectForKey:SpecialAreaBegPKey] CGPointValue];
    CGPoint endP = [[specialDic objectForKey:SpecialAreaEndPKey] CGPointValue];
    NSLog(@"矩形 x=%f   y=%f    x=%f   y=%f ",begP.x, begP.y, endP.x, endP.y);
    //计算右上点和宽高 = rectangle
    CGRect rectangle = [ToolOfQuYuV rectanglePointAndWHwithBegP:begP endP:endP];
    _specialAreaDic = [NSMutableDictionary dictionaryWithDictionary:specialDic];
    //在计算UI的情况下 做arr dic数据更新
    if (_nowTypeOfDetailTagMaxNum==3) {
        _allowedDataArr = [NSMutableArray arrayWithObject:_specialAreaDic];
    }else if(_nowTypeOfDetailTagMaxNum==4||_nowTypeOfDetailTagMaxNum==5||_nowTypeOfDetailTagMaxNum==6) {
        [_forbiddenDataArr replaceObjectAtIndex:_nowTypeOfDetailTagMaxNum-4 withObject:_specialAreaDic];
    }else{
        //0则不更新
    }
    
//    [self willSendXmppStr];//更新将会使用的xmppStr
    return rectangle;
}

#pragma mark --- xmppstrGetArrdata  4个数据 ->dic 不做计算（仅格式转化）
- (NSMutableDictionary *)getDicOfFourStr:(NSString*)aStr
                                    bStr:(NSString *)bStr
                                    cStr:(NSString *)cStr
                                    dStr:(NSString *)dStr{
    
    
    //更新数据 drawRc
    CGPoint bp = CGPointMake([aStr floatValue], [bStr floatValue]);
    CGPoint ep =  CGPointMake([cStr floatValue], [dStr floatValue]);
    NSMutableDictionary*rdic = [NSMutableDictionary dictionary];
    [rdic setValue:[NSValue valueWithCGPoint:bp] forKey:SpecialAreaBegPKey];
    [rdic setValue:[NSValue valueWithCGPoint:ep] forKey:SpecialAreaEndPKey];
    return rdic;
}

#pragma mark -- rect->dic
- (NSMutableDictionary *)getDicOfRect:(CGRect)theBtnViewRect{
    
    //更新数据 drawRc
    CGPoint bp = CGPointMake(theBtnViewRect.origin.x, theBtnViewRect.origin.y);
    CGPoint ep = CGPointMake(theBtnViewRect.origin.x+theBtnViewRect.size.width,theBtnViewRect.origin.y+ theBtnViewRect.size.height);
    NSMutableDictionary*rdic = [NSMutableDictionary dictionary];
    [rdic setValue:[NSValue valueWithCGPoint:bp] forKey:SpecialAreaBegPKey];
    [rdic setValue:[NSValue valueWithCGPoint:ep] forKey:SpecialAreaEndPKey];
    return rdic;
}
#pragma mark --drawRect drawRect drawRect drawRect drawRect drawRect
- (void)drawRect:(CGRect)rect {
    //dic 当前tagmax非0 dic有值
    if (_nowTypeOfDetailTagMaxNum>0) {
        [self dicAndTagSetNowWithTag:_nowTypeOfDetailTagMaxNum*100 isSetNowDicOrNotSet:NO];
    }
   
    //Arr数据的图
    if (_forbiddenDataArr.count>0) {
        [self deletOfBtnTagFirstNum:999];// 删去原有的
        for (int i=0; i<_forbiddenDataArr.count; i++) {
            CGRect rectangle  = [self getRectOfSpecialDic:_forbiddenDataArr[i]];
            [self deletOfBtnTagFirstNum:i+4];//删除3 4 5 6  // 删去原有的
            [self getBtnJx:rectangle tagOfMax:i+4];//456
             NSLog(@"drawRect tagOfMax %d ",i+4);
        }
    }else{
         [self deletOfBtnTagFirstNum:4];//删除3 4 5 6  // 删去原有的
         [self deletOfBtnTagFirstNum:5];//删除3 4 5 6  // 删去原有的
         [self deletOfBtnTagFirstNum:6];//删除3 4 5 6  // 删去原有的
    }
    //Arr数据的图
    if (_allowedDataArr.count>0) {
        CGRect rectangle  = [self getRectOfSpecialDic:_allowedDataArr.firstObject];
         [self deletOfBtnTagFirstNum:3];//删除3 4 5 6  // 删去原有的
         [self getBtnJx:rectangle tagOfMax:3];//3 新增
         NSLog(@"drawRect tagOfMax 3 ");
    }else{
        [self deletOfBtnTagFirstNum:3];//删除3
    }
    //层级
    if (_nowTypeOfDetailTagMaxNum!=0) {
        [self setFirstBringViewOfTag:_nowTypeOfDetailTagMaxNum];
    }else{
        [self setFirstBringViewOfTag:0];//0
    }
   
    [self willSendXmppStr];//用处理str
    
}
#pragma mark -- 层级
- (void)setFirstBringViewOfTag:(int)tag{
    //最上层
    for (UIView *subview in self.subviews) {
        if (subview.tag/100 == tag) {//当前的BtnView控件+zoom+delet
            [subview bringSubviewToFront:self];
            NSLog(@"bringSubviewToFront最上层tag %d ",tag);
        }
    }
}


#pragma mark --getBtnJx 在drawRect时调用 新增View
- (void)getBtnJx:(CGRect)rectangle tagOfMax:(NSInteger)t{
    //将矩形btn添加或huanfram
  
    NSInteger btnTag = t*100;
    NSLog(@"getBtnJx 在drawRect时调用 新增View  btnTag=%ld  t=%f",(long)btnTag,t);
    [self newQuBtnWithRect:rectangle isChangeNewFramBool:NO tagNum:btnTag];
    [self newDeletBtnWithQuRect:rectangle isChangeNewFramBool:NO deletBtnTagMax:t];
    [self newZoomBtnWithQuRect:rectangle isChangeNewFramBool:NO tagZoomMax:t];
    [self newShowLabelWithQuRect:rectangle isChangeNewFramBool:NO showLabelTagMax:t];
    
}
#pragma mark -_________- 新增or更换Fram
#pragma mark -----newOrFram
- (void)newQuBtnWithRect:(CGRect)rectangle isChangeNewFramBool:(BOOL)isNewFram tagNum:(NSInteger)btnTag{
    if (!isNewFram) {
        QuBtn *btnOfQu = [QuBtn buttonWithType:UIButtonTypeCustom];
        btnOfQu.frame = rectangle;
        [btnOfQu addTarget:self action:@selector(btnOfQuAction:) forControlEvents:UIControlEventTouchUpInside];
        btnOfQu.layer.borderWidth = 1;
       
        btnOfQu.tag = btnTag;
        if(btnTag/100==3){
            btnOfQu.layer.borderColor = [UIColor blueColor].CGColor;
        }else{
             btnOfQu.layer.borderColor = [UIColor redColor].CGColor;
        }
        NSLog(@"btnTag=%ld",(long)btnTag);
        if (_nowTypeOfDetailTagMaxNum == btnTag/100) {
             btnOfQu.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.1];
             btnOfQu.selected=NO;
        }else{
             btnOfQu.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.1];
             btnOfQu.selected=YES;
        }
        
        //区域本btnV的拖拽手势
        UIPanGestureRecognizer* panOfbtnQuView = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureOfbtnQuViewAction:)];
        [btnOfQu addGestureRecognizer:panOfbtnQuView];
        NSLog(@"NewOrF n tag btnOfQu tag=%ld",btnOfQu.tag);
 
        [self addSubview:btnOfQu];
    }else{
        //更新UI 不删除 只更新该fram
        for (UIView *subbview in self.subviews) {//400 300 500 600
            
            if(subbview.tag == btnTag){//只做该区的fram变化
               
                QuBtn* btnOfQu = (QuBtn *)subbview;
                btnOfQu.frame = rectangle;
                btnOfQu.tag = btnTag;
                [btnOfQu setNeedsDisplay];////栅格线模糊的情况
             NSLog(@"NewOrF f tag btnOfQu tag=%ld",btnOfQu.tag);
            }
          
            
        }
        
    }
    
}

#pragma mark --  // 附加的显示宽高的label
- (void)newShowLabelWithQuRect:(CGRect)rectangle isChangeNewFramBool:(BOOL)isNewFram showLabelTagMax:(NSInteger)showLabelTagMax{
    UILabel *labelOfShwoWH;
    if (!isNewFram) {//新的label 所有的都要做 drawRc才调用NO
        UILabel *labelOfShwoWH = [[UILabel alloc]init];
        if (rectangle.size.width<50) {
            labelOfShwoWH.frame = CGRectMake(rectangle.origin.x, rectangle.origin.y+rectangle.size.height, rectangle.size.width*2, 10);//
        }else{
            labelOfShwoWH.frame = CGRectMake(rectangle.origin.x, rectangle.origin.y+rectangle.size.height, rectangle.size.width, 10);//
        }
        if(showLabelTagMax==3){
            labelOfShwoWH.textColor = [UIColor blueColor];
        }else{
            labelOfShwoWH.textColor = [UIColor redColor];
        }
       
        labelOfShwoWH.backgroundColor = [UIColor clearColor];
        if (showLabelTagMax==3) {//专扫
            labelOfShwoWH.tag = AllowedLabelShowWHTag;
        }else if(showLabelTagMax==4||showLabelTagMax==5||showLabelTagMax==6){//尽扫
            labelOfShwoWH.tag = (showLabelTagMax*100+30);//430|530|630
        }
         labelOfShwoWH.font = [UIFont systemFontOfSize:6];
         labelOfShwoWH.text = [self upWHWihtQuBtnRect:rectangle];
        [self addSubview:labelOfShwoWH];
    }else{ //更新UI 不删除 只更新该fram
        for (UIView *subbview in self.subviews) {//410 310 510 610
            
            if(subbview.tag/100 ==_nowTypeOfDetailTagMaxNum){//只做该区的fram变化
                NSInteger subT = (int)subbview.tag-_nowTypeOfDetailTagMaxNum*100;
                if (subT == 30 ){
                    labelOfShwoWH = (UILabel *)subbview;
                    if (rectangle.size.width<50) {
                         labelOfShwoWH.frame = CGRectMake(rectangle.origin.x, rectangle.origin.y+rectangle.size.height, rectangle.size.width*2, 10);//
                    }else{
                         labelOfShwoWH.frame = CGRectMake(rectangle.origin.x, rectangle.origin.y+rectangle.size.height, rectangle.size.width, 10);//
                    }
                   
                    if (showLabelTagMax==3) {//专扫
                        labelOfShwoWH.tag = AllowedLabelShowWHTag;
                    }else if(showLabelTagMax==4||showLabelTagMax==5||showLabelTagMax==6){//尽扫
                        labelOfShwoWH.tag = (showLabelTagMax*100+30);//430|530|630
                    }
                    
                    labelOfShwoWH.text = [self upWHWihtQuBtnRect:rectangle];
                }
            }
        }
    }
    
}

//比例尺数据lable文本更新
- (NSString *)upWHWihtQuBtnRect:(CGRect)rect{
    //25像素的值 = 100厘米 -》1像素对应的厘米数
//    CGFloat oneBili = (1.0/_saveMapScale)*100/50;
//    NSLog(@"oneBili%f w %f  h %f   _saveMapScale %f",oneBili,rect.size.width,rect.size.height,_saveMapScale);
//    NSString *wStr = [NSString stringWithFormat:@"%f",  _saveMapScale*rect.size.width*oneBili];
//    NSString *hStr = [NSString stringWithFormat:@"%f",  _saveMapScale*rect.size.height*oneBili];
//    NSString *strOfLabel = [NSString stringWithFormat:@"%dcm*%dcm",[wStr intValue], [hStr intValue]];
   
     NSString *wStr = [NSString stringWithFormat:@"%f", (rect.size.width/25)*100];//25像素的值 = 100厘米
     NSString *hStr = [NSString stringWithFormat:@"%f", (rect.size.height/25)*100];
     NSString *strOfLabel = [NSString stringWithFormat:@"%dcm*%dcm",[wStr intValue], [hStr intValue]];
    return strOfLabel;
}
#pragma mark --//newOrFram 附加的删除按钮
- (void)newDeletBtnWithQuRect:(CGRect)rectangle isChangeNewFramBool:(BOOL)isNewFram deletBtnTagMax:(NSInteger)tagOfDeletMax{
    UIButton *btnOfFDelet;
    if (!isNewFram) {//新的删除按钮 所有的都要做 drawRc才调用NO
        UIButton *btnOfFDelet = [UIButton buttonWithType:UIButtonTypeCustom];
       btnOfFDelet.frame = CGRectMake(rectangle.origin.x+(rectangle.size.width)/2-5, rectangle.origin.y -10 , 10, 10);//20->10
        
//        btnOfFDelet.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
        if (tagOfDeletMax==3) {//专扫
            btnOfFDelet.tag = AllowedDeletBtnTag;
            btnOfFDelet.hidden=YES;
            return;//20190327删除按钮不显示（专扫和虚拟墙情况下）
        }else if(tagOfDeletMax==4||tagOfDeletMax==5||tagOfDeletMax==6){//尽扫
            btnOfFDelet.tag = (tagOfDeletMax*100+10);
        }
        if(_subBtnIsShow){
             btnOfFDelet.hidden=NO;
        }else{
             btnOfFDelet.hidden=YES;
        }
       
//        if (_nowTypeOfDetailTagMaxNum == tagOfDeletMax) {
//            btnOfFDelet.hidden=NO;//当前的view删除按钮隐藏
//        }else{
//            btnOfFDelet.hidden=YES;
//        }
//        btnOfFDelet.layer.cornerRadius = 10;
        [btnOfFDelet addTarget:self action:@selector(btnofFDeletAction:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"new n tag btnOfFDelet %ld tagOfDeletMax=%d",btnOfFDelet.tag,tagOfDeletMax);
        [btnOfFDelet setImage:[UIImage imageNamed:@"map_xuniqiang_shanchu"] forState:UIControlStateNormal];
        [self addSubview:btnOfFDelet];
        
    }else{
      //更新UI 不删除 只更新该fram
        for (UIView *subbview in self.subviews) {//410 310 510 610
           
            if(subbview.tag/100 ==_nowTypeOfDetailTagMaxNum){//只做该区的fram变化
                NSInteger subT = (int)subbview.tag-_nowTypeOfDetailTagMaxNum*100;
                if (subT == 10 ){
                    btnOfFDelet = (UIButton *)subbview;
                    btnOfFDelet.frame = CGRectMake(rectangle.origin.x+(rectangle.size.width)/2-5, rectangle.origin.y -10 , 10, 10);
                    if (tagOfDeletMax==3) {//专扫
                        btnOfFDelet.tag = AllowedDeletBtnTag;
                          btnOfFDelet.hidden=YES;//20190327删除按钮不显示
                          return;
                        NSLog(@"new f tag btnOfFDelet %d",btnOfFDelet.tag);
                    }else if(tagOfDeletMax==4||tagOfDeletMax==5||tagOfDeletMax==6){//尽扫
                         btnOfFDelet.tag = (tagOfDeletMax*100+10);
                        NSLog(@"new f tag btnOfFDelet %d",btnOfFDelet.tag);
                    }
//                     btnOfFDelet.hidden=NO;
                    if(_subBtnIsShow){
                        btnOfFDelet.hidden=NO;
                    }else{
                        btnOfFDelet.hidden=YES;
                    }
                }
            }
        }
      
    }
 
    
}

#pragma mark --  //newOrFram 缩放按钮
- (void)newZoomBtnWithQuRect:(CGRect)rectangle isChangeNewFramBool:(BOOL)isNewFram tagZoomMax:(NSInteger)thisZoomBtnTagMax{
    if (!isNewFram) {
        for (int i=0; i<8; i++) {
            UIButton *btnOfFZoom = [UIButton buttonWithType:UIButtonTypeCustom];
//            btnOfFZoom.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.8];
            if (thisZoomBtnTagMax==3) {//专扫
                btnOfFZoom.tag = AllowedZoomBtnTag+i;
                return;//20190327专扫不做处理
            }else if(thisZoomBtnTagMax==4||thisZoomBtnTagMax==5||thisZoomBtnTagMax==6){//尽扫
                 btnOfFZoom.tag = thisZoomBtnTagMax*100+20+i;
            }
            if (_nowTypeOfDetailTagMaxNum == thisZoomBtnTagMax) {
                if(_subBtnIsShow){
                    btnOfFZoom.hidden=NO;
                }else{
                    btnOfFZoom.hidden=YES;
                }
//                btnOfFZoom.hidden=NO;
            }else{
//                btnOfFZoom.hidden=YES;
            }
            //右下脚拖拽手势
            UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureActionOfZoom:)];
            [btnOfFZoom addGestureRecognizer:pan];
           
            ////
            btnOfFZoom =  [self bianJiaoZoomViewNewFramWithQuViewRect:rectangle tagMinInde:i btn:btnOfFZoom];
           ///
            if (_isAllowOrForbidNum==1) {//专扫
                btnOfFZoom.tag = AllowedZoomBtnTag+i;
                return;//20190327专扫不做处理
            }else if(_isAllowOrForbidNum==2){//尽扫
                //                btnOfFZoom.tag = (_nowTypeOfDetailTagMaxNum*100+20)+i;
                btnOfFZoom.tag = thisZoomBtnTagMax*100+20+i;
            }
             NSLog(@"new n tag btnOfFZoom %ld  thisZoomBtnTagMax =%d",btnOfFZoom.tag,thisZoomBtnTagMax);
            [self addSubview:btnOfFZoom];//添加
        }

    }else{
        //更新UI 不删除 只更新该fram
        for (UIView *subbview in self.subviews) {//410 310 510 610
            
            if(subbview.tag/100 ==_nowTypeOfDetailTagMaxNum){//只做该区的fram变化
                int subT = (int)subbview.tag-_nowTypeOfDetailTagMaxNum*100;
                if (subT >=20&&subT<30 ){
                    NSLog(@"new f tag btnOfFZoom %d",(subT-20));
                    UIButton *zoombtn =(UIButton *)subbview;
                    
                    [self bianJiaoZoomViewNewFramWithQuViewRect:rectangle tagMinInde:(subT-20) btn:zoombtn];
 
                }
            }
        }
        
    }
}
//更换zommbtnFram
- (UIButton *)bianJiaoZoomViewNewFramWithQuViewRect:(CGRect)rectangle tagMinInde:(int)i btn:(UIButton *)btnOfFZoom{
    
    NSLog(@"更换zommbtnFram %d",i);
    CGFloat zoomBianKuan = 1;
    if (rectangle.size.height>40&&rectangle.size.width>40) {
//        zoomBianKuan = 20;
        zoomBianKuan = 10;
    }else if(rectangle.size.height>20&&rectangle.size.width>20){
//        zoomBianKuan = 10;
        zoomBianKuan = 7;
    }else if(rectangle.size.height>10&&rectangle.size.width>10){
        zoomBianKuan = 5;
    }else{
        zoomBianKuan = 3;
    }
    CGFloat zoomBianKuanHorizontal = zoomBianKuan;//水平方向的最大值
    CGFloat zoomBianKuanVertical = zoomBianKuan;//垂直方向
    if (rectangle.size.height>40) {
        zoomBianKuanVertical = rectangle.size.height*0.5;
    }
    if (rectangle.size.width>40) {
        zoomBianKuanHorizontal = rectangle.size.width*0.5;
    }
    NSLog(@"zoo %f rectangle %f %f  %f %f ",zoomBianKuan,rectangle.origin.x,rectangle.origin.y,rectangle.size.width,rectangle.size.height);
    
    switch (i) {//先做4个边
        case  0://left
            
            btnOfFZoom.frame = CGRectMake(rectangle.origin.x, rectangle.origin.y+(rectangle.size.height)*0.5-zoomBianKuan*0.5-zoomBianKuanVertical*0.5, zoomBianKuan, zoomBianKuanVertical);
            
            break;
        case  1://bottom
            
            btnOfFZoom.frame = CGRectMake(rectangle.origin.x+(rectangle.size.width)*0.5-zoomBianKuan*0.5-zoomBianKuanHorizontal*0.5, rectangle.origin.y+rectangle.size.height-zoomBianKuan, zoomBianKuanHorizontal, zoomBianKuan);
//            btnOfFZoom.backgroundColor = [UIColor cyanColor];
            break;
        case  2://right
           
            btnOfFZoom.frame = CGRectMake((rectangle.origin.x+rectangle.size.width)-zoomBianKuan, rectangle.origin.y+(rectangle.size.height)*0.5-zoomBianKuan*0.5-zoomBianKuanVertical*0.5, zoomBianKuan, zoomBianKuanVertical);
            break;
        case  3://top
           
            btnOfFZoom.frame = CGRectMake(rectangle.origin.x+(rectangle.size.width)*0.5-zoomBianKuan*0.5-zoomBianKuanHorizontal*0.5, rectangle.origin.y,zoomBianKuanHorizontal , zoomBianKuan);
//            btnOfFZoom.backgroundColor = [UIColor yellowColor];
            break;
        case  4://4个角
            //左上
            btnOfFZoom.frame = CGRectMake(rectangle.origin.x, rectangle.origin.y, zoomBianKuan, zoomBianKuan);
            break;
        case  5://左下
            btnOfFZoom.frame = CGRectMake(rectangle.origin.x, rectangle.origin.y+rectangle.size.height-zoomBianKuan, zoomBianKuan, zoomBianKuan);
            break;
        case  6://右上
            btnOfFZoom.frame = CGRectMake(rectangle.origin.x+rectangle.size.width-zoomBianKuan, rectangle.origin.y, zoomBianKuan, zoomBianKuan);
            break;
        case  7://右下
            btnOfFZoom.frame = CGRectMake(rectangle.origin.x+rectangle.size.width-zoomBianKuan, rectangle.origin.y+rectangle.size.height-zoomBianKuan, zoomBianKuan, zoomBianKuan);
            break;
            
        default:
            break;
    }
    
    return btnOfFZoom;
}
#pragma mark -- 区域本btn的拖拽手势
//拖动整个的view
- (void)panGestureOfbtnQuViewAction:(UIPanGestureRecognizer *)rec{
   
//去掉----------------所有的区域都能拖     用recMaxTag来定
    if (_forbiddenDataArr.count&&_allowedDataArr==0) {//当前可操作数据为空 则 不做图片更新操作
        return;
    }
    if(!_subBtnIsShow){//非虚拟墙绘画状态
         NSLog(@"_subBtnIsShow1 %d",_subBtnIsShow);
        return;
    }else{
        NSLog(@"_subBtnIsShow2 %d",_subBtnIsShow);
    }
    
    
    _nowTypeOfDetailTagMaxNum =  rec.view.tag/100;
    if (_nowTypeOfDetailTagMaxNum==3) {
        return;//20190327专扫不做处理
    }
    [self setFirstBringViewOfTag:_nowTypeOfDetailTagMaxNum];//层级
     [self dicAndTagSetNowWithTag: rec.view.tag isSetNowDicOrNotSet:YES];//更换dic和其他数据
    //
    CGPoint point = [rec translationInView:self];
    rec.view.center = CGPointMake(rec.view.center.x + point.x, rec.view.center.y + point.y);
    [rec setTranslation:CGPointMake(0, 0) inView:self];
    //更新数据 drawRc
    CGPoint bp = CGPointMake(rec.view.frame.origin.x, rec.view.frame.origin.y);
    CGPoint ep = CGPointMake(rec.view.frame.origin.x+rec.view.frame.size.width,rec.view.frame.origin.y+ rec.view.frame.size.height);
    [_specialAreaDic setValue:[NSValue valueWithCGPoint:bp] forKey:SpecialAreaBegPKey];
    [_specialAreaDic setValue:[NSValue valueWithCGPoint:ep] forKey:SpecialAreaEndPKey];
    if (rec.state==UIGestureRecognizerStateEnded) {
        //更新数据 drawRc
        [self setNeedsDisplay];
    }
    if (rec.state==UIGestureRecognizerStateChanged) {
        //以下只更新子btnF
        CGRect newR = [self getRectOfSpecialDic:_specialAreaDic];
        [self newZoomBtnWithQuRect:newR isChangeNewFramBool:YES tagZoomMax:rec.view.tag/100];
        [self newDeletBtnWithQuRect:newR isChangeNewFramBool:YES deletBtnTagMax:rec.view.tag/100];
        [self newShowLabelWithQuRect:newR isChangeNewFramBool:YES showLabelTagMax:rec.view.tag/100];
    }
//        //以下只更新子btnF
//        CGRect newR = [self getRectOfSpecialDic:_specialAreaDic];
//        [self newZoomBtnWithQuRect:newR isChangeNewFramBool:YES tagZoomMax:rec.view.tag/100];
//        [self newDeletBtnWithQuRect:newR isChangeNewFramBool:YES deletBtnTagMax:rec.view.tag/100];
    
}

#pragma mark -- 缩放按钮的 拖动手势 能够缩放qubtn
//拖拽
- (void)panGestureActionOfZoom:(UIPanGestureRecognizer *)rec{

    if (_forbiddenDataArr.count&&_allowedDataArr==0) {//当前可操作数据为空 则 不做图片更新操作
        return;
    }
    if(!_subBtnIsShow){//非虚拟墙绘画状态
        NSLog(@"_subBtnIsShow3 %d",_subBtnIsShow);
        return;
    }else{
        NSLog(@"_subBtnIsShow4 %d",_subBtnIsShow);
    }
    _nowTypeOfDetailTagMaxNum =  rec.view.tag/100;
    if (_nowTypeOfDetailTagMaxNum==3) {
        return;//20190327专扫不做处理
    }
    [self setFirstBringViewOfTag:_nowTypeOfDetailTagMaxNum];//层级
     [self dicAndTagSetNowWithTag: rec.view.tag isSetNowDicOrNotSet:YES];
    //
    NSInteger tagOfView = rec.view.tag;
    int tagOfFangxiangNum =  0;//判断是整体拖动还是部分btn的缩放
    CGRect oldRectOfBtnQuV = [self getRectOfSpecialDic:_specialAreaDic];
    CGFloat willX = oldRectOfBtnQuV.origin.x;
    CGFloat willY = oldRectOfBtnQuV.origin.y;
    CGFloat willW = oldRectOfBtnQuV.size.width;
    CGFloat willH = oldRectOfBtnQuV.size.height;
    

    CGPoint point = [rec translationInView:self];
    NSLog(@"zoom缩放按钮的拖动手势panGes  point %f,%f",point.x,point.y);
    rec.view.center = CGPointMake(rec.view.center.x + point.x, rec.view.center.y + point.y);
    [rec setTranslation:CGPointMake(0, 0) inView:self];
   
    
    if (tagOfView%100>=20&& tagOfView%100<30){// 520+ 420+
          tagOfFangxiangNum =  rec.view.tag%100-20;//0-7 方向
        NSLog(@"zoom缩放按钮的拖动手势panGes  tagOfFangxiangNum= %d |  |  x %f y %f w %f h %f",tagOfFangxiangNum,willX,willY,willW,willH);
        switch (tagOfFangxiangNum) {//按钮的tag和按钮的ges
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
        }
        ////数据过小 且往更小的数据 则不做缩放
        if (willW<30&&willW<oldRectOfBtnQuV.size.width) {
            return;
        }
        if (willH<30&&willH<oldRectOfBtnQuV.size.height) {
            return;
        }
        
        CGPoint bp = CGPointMake(willX, willY);
        CGPoint ep = CGPointMake(willX+willW, willY+willH);;
        [_specialAreaDic setValue:[NSValue valueWithCGPoint:bp] forKey:SpecialAreaBegPKey];
        [_specialAreaDic setValue:[NSValue valueWithCGPoint:ep] forKey:SpecialAreaEndPKey];
        if (rec.state==UIGestureRecognizerStateEnded){
            [self setNeedsDisplay];//刷DrawRect
        }else if(rec.state==UIGestureRecognizerStateChanged){//更新UI
            CGRect newR = [self getRectOfSpecialDic:_specialAreaDic];
            [self newQuBtnWithRect:newR isChangeNewFramBool:YES tagNum:_nowTypeOfDetailTagMaxNum*100];
            [self newZoomBtnWithQuRect:newR isChangeNewFramBool:YES tagZoomMax:rec.view.tag/100];
            [self newDeletBtnWithQuRect:newR isChangeNewFramBool:YES deletBtnTagMax:rec.view.tag/100];
            [self newShowLabelWithQuRect:newR isChangeNewFramBool:YES showLabelTagMax:rec.view.tag/100];
        }
       
    }else{
    }
    
}

#pragma mark -- 禁止区域 删除按钮
- (void)btnofFDeletAction:(UIButton *)sender{
    
    //删除数据后删除view 只处理数据
   
    NSInteger t = sender.tag/100 ;//例如百位数据410 ／100 = 4 则所有开头4的都删除
   [self deletOfBtnTagFirstNum:t];//删除3 4 5 6  // 删去原有的
      NSLog(@"删除btnaction tag=%d",t);//删除数据 用新数据更新UI
    if (t==3) {
        [_allowedDataArr removeAllObjects];
    }else if (t==4||t==5||t==6){
        NSLog(@"btnofFDeletAction %ld",(long)t);
        [_forbiddenDataArr removeObjectAtIndex:(t-4)];//
    }
    [_specialAreaDic removeAllObjects];
    _isAllowOrForbidNum = 0;
    _nowTypeOfDetailTagMaxNum = 0;
    [self deletOfBtnTagFirstNum:999];//删除所有区域 之后重新画
    [self setNeedsDisplay];//更新数据刷新界面
    //等待更新后发送
//    [self forbiddenQuXmppStrSend];//发送禁止区
    [self willSendXmppStr];
    [self forbiddenQuXmppStrSend];//发送禁止区
    [self performSelector:@selector(perSendDeletOfNewInfoStr) withObject:self afterDelay:1.0];
    
}
- (void)perSendDeletOfNewInfoStr{
     [self forbiddenQuXmppStrSend];//发送禁止区
}
/////删该区域的几个view
- (void)deletOfBtnTagFirstNum:(NSInteger)t{
    
    for (UIView *subbview in self.subviews) {
        NSInteger subT = subbview.tag/100;
        if (subT == t ){
            NSLog(@"delet subbview.tag = %ld",(long)subbview.tag);
            [subbview removeFromSuperview];
        }
        if (t==999) {//全删 之后好更新
             [subbview removeFromSuperview];
        }
    }
}
#pragma mark --区域btn按钮 点击事件 区域的透明度变化 附加按钮的显示隐藏
- (void)btnOfQuAction:(QuBtn*)sender{
    
     NSInteger sTOne = sender.tag/100;// 300 400 500 600
     NSInteger  sTLast = sender.tag%100;//余数存在的为小btn 0余数 10 20-27
    _nowTypeOfDetailTagMaxNum = sTOne;
     [self setFirstBringViewOfTag:_nowTypeOfDetailTagMaxNum];//层级//层级
    [self dicAndTagSetNowWithTag:sender.tag isSetNowDicOrNotSet:YES];
   
}
#pragma mark -- 设置当前的数据Now状态部分 当前所响应的 3 4 5 6
- (void)dicAndTagSetNowWithTag:(NSInteger)tagOfQu isSetNowDicOrNotSet:(BOOL)isSetNow{
    
    if (!isSetNow) {//非响应状态
        _isAllowOrForbidNum = 0;
        _nowTypeOfDetailTagMaxNum = 0;
        _specialAreaDic = [NSMutableDictionary dictionary];
    }else{
        switch (tagOfQu/100) {
            case 3://专扫区1区
                _isAllowOrForbidNum = 1;
                _nowTypeOfDetailTagMaxNum = 3;
                _specialAreaDic = _allowedDataArr.firstObject;
                break;
            case 4://禁扫区1区
                _isAllowOrForbidNum = 2;
                _nowTypeOfDetailTagMaxNum = 4;
                _specialAreaDic = _forbiddenDataArr.firstObject;
                break;
            case 5://禁扫区2区
                _isAllowOrForbidNum = 2;
                _nowTypeOfDetailTagMaxNum = 5;
                _specialAreaDic = [NSMutableDictionary dictionaryWithDictionary:_forbiddenDataArr[1]];
                break;
            case 6://禁扫区3区
                _isAllowOrForbidNum = 2;
                _nowTypeOfDetailTagMaxNum = 6;
                _specialAreaDic = [NSMutableDictionary dictionaryWithDictionary:_forbiddenDataArr[2]];
                break;
            default:
                break;
        }
    }
   
   
}

//转型
- (NSValue* )getValueOfwithEvent:(UIEvent *)event{
    CGPoint rP = CGPointMake(0, 0);
    
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    rP = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
//    NSLog(@"111 px=%f   py=%f",rP.x,rP.y);
    NSValue *value = [NSValue valueWithCGPoint:rP];
    rP = [value CGPointValue];
//    NSLog(@"222 px=%f   py=%f",rP.x,rP.y);
    return value;
}
///////
- (CGPoint )getPointOfwithEvent:(UIEvent *)event{
    CGPoint rP = CGPointMake(0, 0);
    
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    rP = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    NSLog(@"px=%f   py=%f",rP.x,rP.y);
    return rP;
}

- (void)willSendXmppStr{
    /**
    专扫区域：area_allow 数量 左上 右下
    禁扫区域：area_ban 数量    左上 右下 左上 右下 左上 右下
     */
    //数据转出xmpp型
    //当前专扫 禁止扫
    
    NSString*strOfAllowDataStr = @"";
    if (_allowedDataArr.count<=0) {
       strOfAllowDataStr = @"area_allow 0 0 0 0 0";//不存在则空数据
    }else{
       strOfAllowDataStr =  [NSString stringWithFormat:@"area_allow 1 %@",[self strOfQuyuDic:_allowedDataArr.firstObject]];
    }
    
    NSString *strOfForbiddenDataStr = @"";
    if (_forbiddenDataArr.count<=0) {
        strOfForbiddenDataStr = @"area_ban 0 0 0 0 0 0 0 0 0 0 0 0 0";//不存在则空数据
    }else{
        int numi =_forbiddenDataArr.count;
//        strOfForbiddenDataStr =  [NSString stringWithFormat:@"area_ban %d",numi];
        strOfForbiddenDataStr =  @"area_ban 3";
        if (_forbiddenDataArr.count==3) {
            //有效数据
            NSString*strOfOneFStr = @"";
            for (int i = 0; i<_forbiddenDataArr.count; i++) {
                strOfOneFStr = [self strOfQuyuDic:_forbiddenDataArr[i]];
                strOfForbiddenDataStr = [NSString stringWithFormat:@"%@ %@",strOfForbiddenDataStr,strOfOneFStr];
            }
        }else if (_forbiddenDataArr.count==2) { //补0
            //有效数据
            NSString*strOfOneFStr = @"";
            for (int i = 0; i<_forbiddenDataArr.count; i++) {
                strOfOneFStr = [self strOfQuyuDic:_forbiddenDataArr[i]];
                strOfForbiddenDataStr = [NSString stringWithFormat:@"%@ %@",strOfForbiddenDataStr,strOfOneFStr];
            }
            strOfForbiddenDataStr = [NSString stringWithFormat:@"%@ 0 0 0 0",strOfForbiddenDataStr];
        }else if (_forbiddenDataArr.count==1){
            NSString*strOfOneFStr = @"";
            for (int i = 0; i<_forbiddenDataArr.count; i++) {
                strOfOneFStr = [self strOfQuyuDic:_forbiddenDataArr[i]];
                strOfForbiddenDataStr = [NSString stringWithFormat:@"%@ %@",strOfForbiddenDataStr,strOfOneFStr];
            }
            strOfForbiddenDataStr = [NSString stringWithFormat:@"%@ 0 0 0 0 0 0 0 0",strOfForbiddenDataStr];//
        }else if(_forbiddenDataArr.count==0){
             strOfForbiddenDataStr = [NSString stringWithFormat:@"%@ 0 0 0 0 0 0 0 0 0 0 0 0",strOfForbiddenDataStr];//
        }
      
    }
    _allowedXmppStr = strOfAllowDataStr;
    _forbiddenXmppStr = strOfForbiddenDataStr;
//    NSLog(@"xmppwiillsend \n allStr=%@ \n  fstr= %@",strOfAllowDataStr,strOfForbiddenDataStr);
//    NSLog(@"allowedDataArr%@ \n forbiddenDataArr%@",_allowedDataArr,_forbiddenDataArr);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"xiniqiangNotificationSendFQuInfoStr" object:_forbiddenXmppStr];//0131新增 禁止区
}
#pragma mark -- 从屏幕坐标 转到 xmpp坐标的str （dic->str xyxy）
//dic-> 左上右下的str
- (NSString *)strOfQuyuDic:(NSMutableDictionary *)dicOfThisP{
    NSString *rStrBpEp = @"";
    CGPoint begP =  [[dicOfThisP objectForKey:SpecialAreaBegPKey] CGPointValue];
    CGPoint endP = [[dicOfThisP objectForKey:SpecialAreaEndPKey] CGPointValue];
    CGPoint xmppBegP = [self getXmppPointWithScreenPoint:begP];
    CGPoint xmppEndP = [self getXmppPointWithScreenPoint:endP];
    
    rStrBpEp = [NSString stringWithFormat:@"%d %d %d %d",(int)xmppBegP.x,(int)xmppBegP.y,(int)xmppEndP.x,(int)xmppEndP.y];//左上 右下//有效数据willxmpp  左上 右下
    NSLog(@"rStrBpEp = %@",rStrBpEp);
    return rStrBpEp;
}

#pragma mark -- //从屏幕坐标 转到 xmpp坐标的str
- (CGPoint )getXmppPointWithScreenPoint:(CGPoint)p{
    //坐标转化部分
    //以self.center为基
    CGPoint rp = p;
    CGFloat rx = rp.x-self.bounds.size.width*0.5;
    CGFloat ry = rp.y-self.bounds.size.height*0.5;
//    NSLog(@"坐标转化部分self.boubds %f %f",self.bounds.size.width,self.bounds.size.height);
    //地图原点与center点的差值
    CGPoint pointImgOriginPointAndCenterPoint = [MapDataTool mapImgOriginPointAndCenterPointRelativeCoordinates];
    CGFloat xC = pointImgOriginPointAndCenterPoint.x;
    CGFloat yC = pointImgOriginPointAndCenterPoint.y;
    int xQu = (int)(rx + xC);
    int yQu = (int)(-ry + yC);
    
    rp = CGPointMake(xQu, yQu);
//    NSLog(@"坐标转化部分getXmppPointWithScreenPoint dicp %d %d  xmppp %d %d",(int)(p.x),(int)(p.y),(int)(rp.x),(int)rp.y);
//    NSLog(@"坐标转化ing 从屏幕p转到xmppP 数据  = %f %f --->screenP %f %f",p.x,p.y,rp.x,rp.y);
    return rp;
}


#pragma mark --从xmpp p 转到屏幕p数据 (str xyxy 4位 2个点->dic)
- (NSMutableDictionary *)getScreenPointDicWithXmppStr:(NSString *)xmppStr{
    NSLog(@"(str xyxy 4位 2个点->dic)xmppStr %@",xmppStr);
    NSArray *xmppArr = [xmppStr componentsSeparatedByString:@" "];
    NSString *oneS = [NSString stringWithFormat:@"%d", [xmppArr[0] intValue]];
    NSString *twoS = [NSString stringWithFormat:@"%d", [xmppArr[1] intValue]];
    NSString *thrS = [NSString stringWithFormat:@"%d", [xmppArr[2] intValue]];
    NSString *fourS = [NSString stringWithFormat:@"%d",[xmppArr[3] intValue]];
    NSMutableDictionary *xmppPointDic =[NSMutableDictionary dictionaryWithDictionary:[self getDicOfFourStr:oneS bStr:twoS cStr:thrS dStr:fourS]];
    CGPoint xmppBegP =  [[xmppPointDic objectForKey:SpecialAreaBegPKey] CGPointValue];
    CGPoint xmppEndP =  [[xmppPointDic objectForKey:SpecialAreaEndPKey] CGPointValue];
    //转（计算）
    CGPoint screenBegP = [self getScreenPWithXmppP:xmppBegP];
    CGPoint screenEndP = [self getScreenPWithXmppP:xmppEndP];
    
    //得到屏幕点换成dic返回
    
    NSString *soneS = [NSString stringWithFormat:@"%d", (int)screenBegP.x ];
    NSString *stwoS = [NSString stringWithFormat:@"%d", (int)screenBegP.y ];
    NSString *sthrS = [NSString stringWithFormat:@"%d", (int)screenEndP.x ];
    NSString *sfourS = [NSString stringWithFormat:@"%d", (int)screenEndP.y ];
    NSMutableDictionary *screenPointDic =[NSMutableDictionary dictionaryWithDictionary:[self getDicOfFourStr:soneS bStr:stwoS cStr:sthrS dStr:sfourS]];
    
    return  screenPointDic;
}

#pragma mark -- //从xmpp p 转到屏幕p数据
- (CGPoint)getScreenPWithXmppP:(CGPoint)xmppP{
    
    CGPoint screenP = CGPointMake(0, 0);
 
    CGPoint pointImgOriginPointAndCenterPoint = [MapDataTool mapImgOriginPointAndCenterPointRelativeCoordinates];
    CGFloat xC = pointImgOriginPointAndCenterPoint.x;
    CGFloat yC = pointImgOriginPointAndCenterPoint.y;
    int x =  (int)(xmppP.x+self.bounds.size.width*0.5-xC);
    int y =  (int)(-xmppP.y+self.bounds.size.height*0.5+yC);
    screenP = CGPointMake(x, y);
    NSLog(@"坐标转化ing 从xmpp p 转到屏幕p数据 xmppP = %f %f --->screenP %f %f",xmppP.x,xmppP.y,screenP.x,screenP.y);
    return screenP;
}

#pragma mark -- sendxmpp
- (void)forbiddenQuXmppStrSend{
    NSLog(@"发送禁止区xmppstr：%@",_forbiddenXmppStr);
   
    NSString *noticeStr = [NSString stringWithFormat:@"%@ Notification",_forbiddenXmppStr];
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage: _forbiddenXmppStr];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"xiniqiangNotificationSendFQuInfoStr" object:noticeStr];//0131新增 禁止区
}
- (void)allowedQuXmppStrSend{
    [[XmppManager shareXmppManager]sendMessageToRobotWithMessage: _allowedXmppStr];
}


#pragma mark -- 使line层响应的方法  _vofxuniqingLineView 20190315虚拟墙线现在不作响应了，只保留禁扫区
#pragma mark -- 区域的viewtouch传给V(虚拟墙线的一层)
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [_vofxuniqingLineView touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [_vofxuniqingLineView touchesMoved:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [_vofxuniqingLineView touchesCancelled:touches withEvent:event];

}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [_vofxuniqingLineView touchesEnded:touches withEvent:event];
}

#pragma mark --是否点击的是 deletBtn区域的判断
- (void)gesOfWallQuTapGes:(UITapGestureRecognizer*)tapges{
   CGPoint tapPoint = [tapges locationInView:self];
    for (int i = 0; i<_vdeletBtnRectArr.count; i++) {//_vdeletBtnRectArr
        NSValue *bValue= _vdeletBtnRectArr[i];
        CGRect vDeltrBtnRect = [bValue CGRectValue];
        if (CGRectContainsPoint(vDeltrBtnRect, tapPoint)){//_vdeletBtnTagArr
            NSLog(@"是否点击的是 deletBtn区域的判断 是 tag=%d",[_vdeletBtnTagArr[i] intValue]);
//            [_vofxuniqingLineView deletWithBtnTag:[_vdeletBtnTagArr[i] intValue]];//传入删除指令
            return;
        }
    }
}
@end
