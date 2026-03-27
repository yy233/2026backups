//
//  HouseRentDetailVcBuniessShopModel.h
//  Community
//
//  Created by 余莹 on 2021/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentDetailVcBuniessShopModelShopModel : NSObject
//@property (nonatomic,strong) shop
//@property (nonatomic,strong) user
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) BOOL deleted;
@property (nonatomic,strong) NSString *shopAddress;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *defrayType;
@property (nonatomic,strong) NSString *monthMoneyString;
@property (nonatomic,strong) NSString *transferMoneyString;
@property (nonatomic,strong) NSString *summarize;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *year;
@property (nonatomic,strong) NSArray *imgPath;
@property (nonatomic,strong) NSArray *tags;
//
@property (nonatomic,assign) NSInteger communityId;
//@property (nonatomic,assign) NSInteger floor;
@property (nonatomic,assign) NSInteger floorCount;
@property (nonatomic,assign) NSInteger houseId;
//@property (nonatomic,assign) NSInteger furnishingStyle;
//@property (nonatomic,assign) NSInteger lift;
//@property (nonatomic,assign) NSInteger orientation;//.朝向
//@property (nonatomic,assign) NSInteger ownership;//类型
//@property (nonatomic,assign) NSInteger purpose;
@property (nonatomic,strong) NSString *furnishingStyle;
@property (nonatomic,strong) NSString *lift;
@property (nonatomic,strong) NSString *orientation;//.朝向
@property (nonatomic,strong) NSString *ownership;//类型
@property (nonatomic,strong) NSString *purpose;

@property (nonatomic,assign) double shopAcreage;//面积
@property (nonatomic,assign) NSInteger source;
//
@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lon;
@property (nonatomic,assign) double monthMoney;
@property (nonatomic,assign) double transaferMoney;//转让费 弃用

//2021增
@property (nonatomic,strong) NSString *shopTypeString;//类型
@property (nonatomic,strong) NSString *shopBusinessString; // 所属行业
@property (nonatomic,strong) NSString *floor;//楼层总文本
@property (nonatomic,strong) NSString *statusString;//状态
@property (nonatomic,assign) double shopWidth;// 宽度
@property (nonatomic,assign) double shopDepth;// 进深
@property (nonatomic,assign) double shopHeight;//层高
@property (nonatomic,assign) NSInteger freeLease;// 免租期
@property (nonatomic,assign) NSInteger startLease;// 起租期

// 签约id
@property (nonatomic, copy) NSString *contractId;


- (CGFloat)getBuniessCellTitleHeight;
- (CGFloat)getBuniessTitleCellAllHeight;
- (CGFloat)getBuniessCellIntroduceHeight;
- (CGFloat)getBuniessIntroduceCellAllHeight;

/** 2021改了数据
 {
     "code": 0,
     "message": null,
     "data": {
         "shop": {
             "uid": "d09bb8bac4fe442f8826a8c329c9cf2a",
             "cityId": 500000,
             "areaId": 500103,
             "communityId": 1,
             "title": "这是标题信息",   // 标题
             "summarize": "这是概述信息",  // 房源介绍
             "monthMoney": 44990.00,
             "defrayType": "押1付99",   // 押付方式
             "transferMoney": 14800.00,
             "shopWidth": 10.0,   // 宽度
             "shopDepth": 20.0,   // 进深
             "shopHeight": 30.0,   // 层高
             "imgPath": [  // 店铺图片
                 "1.png",
                 "2.png",
                 "3.png"
             ],
             "lon": 105.729482,   // 经度
             "lat": 29.592132,   // 纬度
             "sourceString": "业主",  // 来源
             "monthMoneyString": "4.50万",      // 月租金
             "transferMoneyString": "1.48万",    // 转让费
             "tags": [        // 标签
                 "学生人群",
                 "办公人群",
                 "客梯",
                 "中央空调",
                 "停车位",
                 "货梯"
             ],
             "mobile": "18580865040",
             "freeLease": 1,  // 免租期
             "startLease": 3,  // 起租期
             "statusString": "空置中", //
             "nickname": "我叫张三",
             "shopPeopleStrings": [
                 "学生人群",
                 "办公人群"
             ],
             "shopFacilityStrings": [
                 "客梯",
                 "中央空调",
                 "停车位",
                 "货梯"
             ],
             "shopBusinessString": "商业街店铺",  // 所属行业
             "shopTypeString": "商业街店铺"  // 所属类型
         },
         "user": {
             "id": 822,
             "deleted": 0,
             "createTime": "2020-12-04 13:56:55",
             "updateTime": "2020-12-29 10:50:46",
             "uid": "d09bb8bac4fe442f8826a8c329c9cf2a",
             "householderId": 0,
             "avatarUrl": "https://dss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=393696030,2511566262&fm=26&gp=0.jpg", // 头像
             "mobile": "18580865040", // 电话
             "sex": 1,
             "realName": "我叫张三", // 称呼
             "idCard": "513029198610053056",
             "isRealAuth": 0,
             "detailAddress": "北京海淀区星光广场79号"
         }
     }
 }
 };*/
@end

NS_ASSUME_NONNULL_END
