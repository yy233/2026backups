//
//  IssueHouseCellBlueSubBtnCellViewModel.m
//  Community
//
//  Created by 余莹 on 2021/1/22.
// 房屋 蓝色圆 常量查询

#import "IssueHouseCellBlueSubBtnCellViewModel.h"

@implementation IssueHouseCellBlueSubBtnCellViewModel
#pragma mark ===1015新的数据num对应表
/**
 
 1    租房押金
 2    房型结构
 3    装修风格
 4    房屋标签
 5    房屋租金
 6    房屋面积
 7    商铺类型
 8    商铺行业
 9    房屋来源
 10    租房类型
 11    租房方式
 12    房源亮点
 13    房屋配置
 14    租房预约日期
 15    租房预约时间
 16    商铺配套设施
 17    商铺客流人群
 18    装修情况
 20    室友性别
 21    出租要求
 22    室友期望
 23    公共设施
 24    房间设施
 25    商铺亮点*/
//---end——————————


//以下旧版本数据
//@"lease/const"//房屋常量查询
/**
 11 : @"租房方式"
 12: @"出租房源类型"    
 13 : @"房屋家具" --公共设施 房间设施
 18: @"装修情况"
 19 : @"房屋亮点"
 20 : @"室友性别"
 21 : @"出租要求"
 22 :@"室友期望"
 //13更改 ———— 是总的 （公共设施 房间设施 公共设施23 房间设施24）*/
/**0615改
 10:@"@"出租房源类型""(原本12)
 11 : @"租房方式"
 12:: @"房屋亮点" （原本19）
 13 : @"房屋家具" --公共设施 房间设施
 18: @"装修情况"
 19 : @"房屋亮点"
 20 : @"室友性别"
 21 : @"出租要求"
 22 :@"室友期望"
 公共设施23 房间设施24）*/
+ (void)getHouseBlueSubCellViewAllArrWithHouseIssueType:(IssueHouse_Type)issHouseType withListArr:(BaseListArrAndSuccessBoolBlock)listBlock{
  
    NSMutableArray *body = [[NSMutableArray alloc]init];
    switch (issHouseType) {
        case IssueHouse_Type_ZhengZu:
            body = [NSMutableArray arrayWithObjects:@(18),@(13),@(21),@(12), nil];
            break;
        case IssueHouse_Type_DanJian:
            body = [NSMutableArray arrayWithObjects:@(18),@(23),@(24),@(12),@(21), nil];
            break;
        case IssueHouse_Type_HeZu:
            body = [NSMutableArray arrayWithObjects:@(18),@(23),@(24),@(20),@(22), nil];
            break;
        default:
            body = [NSMutableArray arrayWithObjects:@(11),@(10),@(13),@(18),@(19),@(20),@(21),@(23),@(24),nil];
            break;
    }
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_Get_Rent_House_Const withBody:body finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block  = listBlock;
        NSMutableArray *arrWillBlock = [[NSMutableArray alloc]init];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *reDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSArray *arr10 = [[reDic allKeys] containsObject:@"10"] ? [NSArray arrayWithArray:reDic[@"10"]] : [[NSArray alloc]init];
                NSArray *arr11 = [[reDic allKeys] containsObject:@"11"] ? [NSArray arrayWithArray:reDic[@"11"]] : [[NSArray alloc]init];
                NSArray *arr12 = [[reDic allKeys] containsObject:@"12"] ? [NSArray arrayWithArray:reDic[@"12"]] : [[NSArray alloc]init];
                NSArray *arr13 = [[reDic allKeys] containsObject:@"13"] ? [NSArray arrayWithArray:reDic[@"13"]] : [[NSArray alloc]init];
                NSArray *arr18 = [[reDic allKeys] containsObject:@"18"] ? [NSArray arrayWithArray:reDic[@"18"]] : [[NSArray alloc]init];
                NSArray *arr19 = [[reDic allKeys] containsObject:@"19"] ? [NSArray arrayWithArray:reDic[@"19"]] : [[NSArray alloc]init];
                NSArray *arr20 = [[reDic allKeys] containsObject:@"20"] ? [NSArray arrayWithArray:reDic[@"20"]] : [[NSArray alloc]init];
                NSArray *arr21 = [[reDic allKeys] containsObject:@"21"] ? [NSArray arrayWithArray:reDic[@"21"]] : [[NSArray alloc]init];
                NSArray *arr22 = [[reDic allKeys] containsObject:@"22"] ? [NSArray arrayWithArray:reDic[@"22"]] : [[NSArray alloc]init];
                NSArray *arr23 = [[reDic allKeys] containsObject:@"23"] ? [NSArray arrayWithArray:reDic[@"23"]] : [[NSArray alloc]init];
                NSArray *arr24 = [[reDic allKeys] containsObject:@"24"] ? [NSArray arrayWithArray:reDic[@"24"]] : [[NSArray alloc]init];
                //
                switch (issHouseType) {
                    case IssueHouse_Type_ZhengZu:
                        arrWillBlock = [[NSMutableArray alloc]initWithObjects:arr18,arr13,arr12,arr21, nil];//19-》12
                        break;
                    case IssueHouse_Type_DanJian:
                        arrWillBlock = [[NSMutableArray alloc]initWithObjects:arr18,arr23,arr24,arr12,arr21, nil];//19-》12
                        break;
                    case IssueHouse_Type_HeZu:
                        arrWillBlock = [[NSMutableArray alloc]initWithObjects:arr18,arr23,arr24,arr22,arr20, nil];
                        break;
                    default:
                        arrWillBlock = [[NSMutableArray alloc]initWithObjects:@[],@[],@[],@[],@[], nil];
                        break;
                }
                //
                block(arrWillBlock,YES);
                
            }else{
                block(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
    
}
//1015换掉旧的用新的标签数据
+ (void)getHouseBlueSubCellViewAllArrWithHouseIssueType:(IssueHouse_Type)issHouseType withNewListArr:(BaseListArrAndSuccessBoolBlock)listBlock{
  
    NSMutableArray *body = [[NSMutableArray alloc]init];
    switch (issHouseType) {
        case IssueHouse_Type_ZhengZu:
            //body = [NSMutableArray arrayWithObjects:@(18),@(13),@(21),@(12), nil];
            body = [NSMutableArray arrayWithObjects:@(12),@(13),@(14),@(18),@(21), nil];
            break;
        case IssueHouse_Type_DanJian:
            //body = [NSMutableArray arrayWithObjects:@(18),@(23),@(24),@(12),@(21), nil];
            body = [NSMutableArray arrayWithObjects:@(14),@(18),@(21),@(23),@(24), nil];
            break;
        case IssueHouse_Type_HeZu:
            body = [NSMutableArray arrayWithObjects:@(18),@(23),@(24),@(20),@(22), nil];
            break;
        case IssueHouse_Type_ShopBuniess://商铺
            body = [NSMutableArray arrayWithObjects:@(7),@(8),@(16),@(17), nil];
            break;
        default:  //8-24
            body = [NSMutableArray arrayWithObjects:@(7),@(8),@(10),@(11),@(12),@(13),@(14),@(16),@(17),@(18),@(19),@(20),@(21),@(23),@(24),nil];
            break;
    }
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:URL_Get_Rent_House_Const withBody:body finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block  = listBlock;
        NSMutableArray *arrWillBlock = [[NSMutableArray alloc]init];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *reDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSArray *arr7 = [[reDic allKeys] containsObject:@"7"] ? [NSArray arrayWithArray:reDic[@"7"]] : [[NSArray alloc]init];
                NSArray *arr8 = [[reDic allKeys] containsObject:@"8"] ? [NSArray arrayWithArray:reDic[@"8"]] : [[NSArray alloc]init];
                NSArray *arr10 = [[reDic allKeys] containsObject:@"10"] ? [NSArray arrayWithArray:reDic[@"10"]] : [[NSArray alloc]init];
                NSArray *arr11 = [[reDic allKeys] containsObject:@"11"] ? [NSArray arrayWithArray:reDic[@"11"]] : [[NSArray alloc]init];
                NSArray *arr12 = [[reDic allKeys] containsObject:@"12"] ? [NSArray arrayWithArray:reDic[@"12"]] : [[NSArray alloc]init];
                NSArray *arr13 = [[reDic allKeys] containsObject:@"13"] ? [NSArray arrayWithArray:reDic[@"13"]] : [[NSArray alloc]init];
                NSArray *arr14 = [[reDic allKeys] containsObject:@"14"] ? [NSArray arrayWithArray:reDic[@"14"]] : [[NSArray alloc]init];
                NSArray *arr16 = [[reDic allKeys] containsObject:@"16"] ? [NSArray arrayWithArray:reDic[@"16"]] : [[NSArray alloc]init];
                NSArray *arr17 = [[reDic allKeys] containsObject:@"17"] ? [NSArray arrayWithArray:reDic[@"17"]] : [[NSArray alloc]init];
                NSArray *arr18 = [[reDic allKeys] containsObject:@"18"] ? [NSArray arrayWithArray:reDic[@"18"]] : [[NSArray alloc]init];
                NSArray *arr19 = [[reDic allKeys] containsObject:@"19"] ? [NSArray arrayWithArray:reDic[@"19"]] : [[NSArray alloc]init];
                NSArray *arr20 = [[reDic allKeys] containsObject:@"20"] ? [NSArray arrayWithArray:reDic[@"20"]] : [[NSArray alloc]init];
                NSArray *arr21 = [[reDic allKeys] containsObject:@"21"] ? [NSArray arrayWithArray:reDic[@"21"]] : [[NSArray alloc]init];
                NSArray *arr22 = [[reDic allKeys] containsObject:@"22"] ? [NSArray arrayWithArray:reDic[@"22"]] : [[NSArray alloc]init];
                NSArray *arr23 = [[reDic allKeys] containsObject:@"23"] ? [NSArray arrayWithArray:reDic[@"23"]] : [[NSArray alloc]init];
                NSArray *arr24 = [[reDic allKeys] containsObject:@"24"] ? [NSArray arrayWithArray:reDic[@"24"]] : [[NSArray alloc]init];
                //
                switch (issHouseType) {
                    case IssueHouse_Type_ZhengZu:
                        //arrWillBlock = [[NSMutableArray alloc]initWithObjects:arr12,arr13,arr14,arr18,arr21, nil];//
                        //18装修
                        arrWillBlock = [[NSMutableArray alloc]initWithObjects:arr18,arr13,arr14,arr12,arr21, nil];//
                    
                       //
//                        18    装修情况
//                        13    房屋配置
//
//                        14    租房预约日期--待增
//
//                        12    房源亮点
//                        21    出租要求
                        
                        /** 匹配新增租赁
                         case Cell_type_BlueBtn_HouseAllType18: //装修得是单选数据
                             DLog(@"装修 arr=%@",indexArr);         18    装修情况
                             [self saveHouseZhuangXiuChooseDataIndex:indexArr];//bluecell选择的数组 num元素
                             break;
                         case Cell_type_BlueBtn_HouseAllType13:
                             DLog(@"家具设施 arr=%@",indexArr);         13    房屋配置
                             [self saveHouseSheShiChooseDataIndex:indexArr];
                             break;
                         case Cell_type_BlueBtn_HouseAllType19:
                             DLog(@"亮点 arr=%@",indexArr);       12    房源亮点
                             [self saveHouseLiangDianChooseDataIndex:indexArr];
                             break;
                         case Cell_type_BlueBtn_HouseAllType21:
                             DLog(@"出租要求 arr=%@",indexArr);    21    出租要求
                             [self saveChuZuYaoQiuChooseDataIndex:indexArr];
                         */
                       
                        break;
                    case IssueHouse_Type_DanJian:
                        arrWillBlock = [[NSMutableArray alloc]initWithObjects:arr18,arr23,arr24,arr14,arr21, nil];

//                        18    装修情况
//                        23    公共设施
//                        24    房间设施
//                        14    租房预约日期--待增
//                        21    出租要求
                        /**
                         case Cell_type_BlueBtn_HouseAllType18:
                             DLog(@"装修 arr=%@",indexArr);
                             [self saveHouseZhuangXiuChooseDataIndex:indexArr];//bluecell选择的数组 num元素
                             break;
                         case Cell_type_BlueBtn_HouseAllType23:
                             DLog(@"家具设施 arr=%@",indexArr);
                             [self saveGoneGongSheShiChooseDataIndex:indexArr];//公共设施
                             break;
                         case Cell_type_BlueBtn_HouseAllType24:
                             DLog(@"房间设施 arr=%@",indexArr);
                             [self saveFangWuSheShiChooseDataIndex:indexArr];
                             break;
                         case Cell_type_BlueBtn_HouseAllType19:
                             DLog(@"亮点 arr=%@",indexArr);
                             [self saveHouseLiangDianChooseDataIndex:indexArr];
                             break;
                         case Cell_type_BlueBtn_HouseAllType21:
                             DLog(@"出租要求 arr=%@",indexArr);
                             [self saveChuZuYaoQiuChooseDataIndex:indexArr];
                             break;
                         default:
                             break;
                         */
                        break;
                    case IssueHouse_Type_HeZu:
                        arrWillBlock = [[NSMutableArray alloc]initWithObjects:arr18,arr23,arr24,arr22,arr20, nil];
                        break;
                    case IssueHouse_Type_ShopBuniess:
                        arrWillBlock = [[NSMutableArray alloc]initWithObjects:arr16,arr17, nil];//arr7,arr8,在第一页就已经有了蓝标不做这个
                         /*:@(7),@(8),@(16),@(17), nil];
                         7    商铺类型
                         8    商铺行业
                         16    商铺配套设施
                         17    商铺客流人群
                         */
                        break;
                    default:
                        arrWillBlock = [[NSMutableArray alloc]initWithObjects:@[],@[],@[],@[],@[], nil];
                        break;
                }
                //
                block(arrWillBlock,YES);
                
            }else{
                block(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
    
}
@end
