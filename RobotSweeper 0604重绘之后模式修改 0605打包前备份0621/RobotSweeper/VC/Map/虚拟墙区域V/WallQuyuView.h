//
//  WallView.h
//  地图画图区域试写
//
//  Created by Joey on 2018/11/20.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V.h"
@interface WallQuyuView : UIView

@property (nonatomic,strong) NSMutableArray *allowedDataArr;//存储所有专扫区
@property (nonatomic,strong) NSMutableArray *forbiddenDataArr;//存储所有禁扫区
@property (nonatomic,strong) V *vofxuniqingLineView;//虚拟墙线的那一个v 用于传touch响应
//添加新qu
- (void)changeQuVScap:(CGFloat)mapScale;
@property (nonatomic,assign) CGFloat saveMapScale;//保存的地图缩放倍数用于更新label
- (void)addNewAllowQu;
- (void)addNewForbiddenQu;
//删除按钮
@property (nonatomic,assign) BOOL subBtnIsShow;//是否显示删除按钮
- (void)quyuBtnSubBtnIsShow:(BOOL)isShow;//是否显示删除按钮
//xmppStr时时存储更新
@property (nonatomic,strong) NSString *allowedXmppStr;//存储所有专扫区
@property (nonatomic,strong) NSString *forbiddenXmppStr;//存储所有禁扫区
#pragma 用于timer定时更新或新数据后更新
- (void)updataViewUI;
#pragma mark -- 得到了xmpp当前数据
- (void)getQuyuXmppStr:(NSString*)strOfxmpp;
#pragma mark -- 发送xmpp数据
- (void)forbiddenQuXmppStrSend;

#pragma mark --  虚拟墙线所在v上btn的info key tag: obj rect
- (void)getBtnInfoDic:(NSMutableDictionary*)dicOfDeletInfo;
@property (nonatomic,strong)NSMutableArray *vdeletBtnRectArr;
@property (nonatomic,strong)NSMutableArray *vdeletBtnTagArr;

@end
