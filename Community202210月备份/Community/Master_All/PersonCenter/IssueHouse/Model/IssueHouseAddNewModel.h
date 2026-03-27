//
//  IssueHouseAddNewModel.h
//  Community
//
//  Created by 余莹 on 2021/2/27.
// 租赁——新增房屋 总model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueHouseAddNewModel : NSObject
//___
/**
 13  houseFurnitureCode []  整租才会用到
 23  commonFacilitiesCode [] 公共设施   合租/单间
 24  roomFacilitiesCode [] 房间设施   合租/单间
 4    houseAdvantageCode []  房屋亮点  整租/单间
 */
@property (nonatomic,strong) NSArray *leaseRequireCode;    //出租要求
@property (nonatomic,strong) NSArray *roommateExpectCode;  //室友期望
//@property (nonatomic,assign) NSInteger roommateSexId;    //室友性别
@property (nonatomic,strong) NSString *roommateSex;        //性别文本
@property (nonatomic,assign) NSInteger decorationTypeId;   //装修情况
@property (nonatomic,strong) NSArray *houseAdvantageCode;  //房屋亮点
@property (nonatomic,strong) NSArray *roomFacilitiesCode;  //房间设施  24  合租/单间
@property (nonatomic,strong) NSArray *commonFacilitiesCode;//公共设施  23  合租/单间
@property (nonatomic,strong) NSArray *houseFurnitureCode;  //房间设施  13  整租才会用到

//___
@property (nonatomic,assign) double houseLon;
@property (nonatomic,assign) double houseLat;
@property (nonatomic,strong) NSString *houseAddress;
@property (nonatomic,strong) NSString *houseUnit;          //房屋出租单位
@property (nonatomic,assign) NSInteger houseCityId;
@property (nonatomic,assign) NSInteger houseCommunityId;
@property (nonatomic,assign) NSInteger houseAreaId;
@property (nonatomic,assign) NSInteger houseId;
@property (nonatomic,assign) NSInteger houseReserveTime;//1015增 日期周末或工作日类型
@property (nonatomic,strong) NSString *houseContact;        //房屋电话号码
@property (nonatomic,strong) NSString *appellation;
@property (nonatomic,strong) NSString *houseTitle;
@property (nonatomic,strong) NSString *houseIntroduce;      //详细描述
@property (nonatomic,assign) NSInteger houseDirectionId;      //房屋朝向 1.东.2.西 3.南 4.北. 5.东南 6.东北 7.西北 8.西南
@property (nonatomic,assign) double houseSquareMeter;       //房屋租赁面积 单位平方米
//@property (nonatomic,assign) NSInteger houseTypeCode;     //户型6位数，如040202就代表 4室2厅2卫
@property (nonatomic,strong) NSString *houseTypeCode;       //户型6位数，如040202就代表 4室2厅2卫
@property (nonatomic,strong) NSString *houseFloor;          //楼层文本 "3层共6层",
@property (nonatomic,strong) NSArray *houseImage;           //全部图片url 的数组
@property (nonatomic,assign) NSInteger houseLeasemodeId;    //房屋出租方式id 1不限(默认) 2整租，4合租----跳转前赋值
@property (nonatomic,assign) NSInteger houseLeasetypeId;    //房屋出租类型ID：1不限(默认) 2普通住宅 4别墅 8公寓
@property (nonatomic,assign) NSInteger houseLeasedepositId;  //房屋押金方式id
@property (nonatomic,assign) double housePrice;

@property (nonatomic,strong) NSString *bedroomType;//卧室类型
 
//修改状态时用的ID
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;
/**
 
 "houseAddress": "和黄御峰(一期)  (南岸 海棠溪)",
 "houseLon":124.23,
 "houseLat":145.64,
 "houseLeasedepositId":1,
 "houseAdvantage": [1,2,4,32768],
 "houseFurniture": [1,2,4,8,16],
 "houseAreaId": 500101,
 "houseCityId": 500100,
 "houseDirection": 2,
 "houseFloor": "16层共32层",
 "houseImage": ["https://pic1.ajkimg.com/display/anjuke/1afe94e09d68a3269665c847fd8ba40c/600x450c.jpg?t=1&srotate=1","https://dss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2287568211,2342036693&fm=26&gp=0.jpg","https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3828163524,132023956&fm=26&gp=0.jpg"],
 "houseIntroduce": "房子在龙荫小区60栋，左靠英业达生活区，右靠广达厂区还有海关红绿灯，上高速路进出口都方便",
 "housePrice": 650,
 "houseProvinceId": 12,
 "houseSquareMeter": 11,
 "houseTitle": "南坪海棠溪 首月免租 和黄御峰 近轻轨站 交通便利 配套齐全",
 "houseContact":15183846980,
 "houseReserveTime":"周一至周五",
 "houseTypeCode": "060102",
 "houseUnit": "月",
 "houseSourceId": 1,
 "houseLeasetypeId":2,
 "houseLeasemodeId":4,
 "houseCommunityId":1,
 "appellation":"王本书",
 "bedroomType":"",
 "houseId":97
}*/
@end

NS_ASSUME_NONNULL_END
