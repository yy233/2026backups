//
//  V.h
//  RobotSweeper
//
//  Created by Joey on 2018/4/23.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import <UIKit/UIKit.h>
//0130新增block 用于把DeletbtnRect发送给quV；
typedef void (^deletbtnInfoArrBlock)(NSMutableDictionary *);//key tag :obj rect

@interface V : UIView
@property (nonatomic,strong)NSMutableDictionary *dicOfNowbeginandEnd;
@property (nonatomic,strong)NSMutableArray *allLineArr;
@property (nonatomic,assign)int numOfLine;
@property (nonatomic,assign)int isGlineActionNum;

@property (nonatomic,strong)NSMutableArray *saveAllLineArr;
@property (nonatomic,strong)NSMutableArray *sendxmppArr;

@property (nonatomic,assign)CGFloat mapScale;
@property (nonatomic,assign)BOOL scrollviewismove;
@property (nonatomic,assign)int scrollisOncemove;



@property (nonatomic,assign)BOOL canDraw;
@property (nonatomic,assign)int canDrawNum;//点击了虚拟墙+1，点击了虚拟墙回到地图-1。1则发，非1则不发送line，删除不在这里发送

- (void)changeMapScap:(CGFloat)mapScale;
- (void)changeMapOffsetPoint:(CGPoint)scrollOffsetPoint;
- (void)isWallCanDraw:(BOOL)canDraw;

- (void)getArrAndNumLineOfThisRobot;//数据

- (void)initNewXNQData:(NSMutableArray*)arrOfGetData;//得到的虚拟墙数据转成可显示前需要处理；
@property (nonatomic,assign)int showDeletBtnOftag;//点击事件设置的显示按钮的线 初值--10

@property (nonatomic,strong)NSString *xmppstr ;//发送的字符串在notice中更新

@property (nonatomic,strong)NSArray* arrOfcolorInfo;//colorarrinfo

//timer改后的num
@property (nonatomic,assign)int delaySendInt;

@property (nonatomic,copy)deletbtnInfoArrBlock vbtnInfoBlock;
- (void)deletWithBtnTag:(int)deletBtnTag;//删除btntag
@end
