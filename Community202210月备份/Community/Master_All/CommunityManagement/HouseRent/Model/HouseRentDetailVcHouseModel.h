//
//  HouseRentDetailVcHouseShopModel.h
//  Community
//
//  Created by 余莹 on 2021/1/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentDetailVcHouseModel : HouseRentListVcHouseCellModel

@property (nonatomic,strong) NSString *houseLeaseDeposit;
@property (nonatomic,strong) NSString *houseDirection;
@property (nonatomic,strong) NSString *houseIntroduce;
@property (nonatomic,strong) NSString *houseFloor;//楼层数是文本格式
@property (nonatomic,strong) NSString *houseContact;
//@property (nonatomic,strong) NSMutableArray *leaseRequireMap; //出租要求
@property (nonatomic,strong) NSMutableDictionary *leaseRequireMap; //出租要求
//设施
@property (nonatomic,strong) NSMutableDictionary *commonFacilitiesCode;//公共
@property (nonatomic,strong) NSMutableDictionary *roomFacilitiesCode;//房间

//
- (CGFloat)getHouseCellTitleHeight;
- (CGFloat)getHouseTitleCellAllHeight;
- (CGFloat)getHouseIntroduceHeight;
- (CGFloat)getHouseIntroduceListViewHeight;
- (CGFloat)getHouseIntroduceHeightAllHeight;
//1016
- (CGFloat)getLeaseRequireMapHeightAllHeight; //出租要求 
- (CGFloat)getNotZhengZuIntroduceHeightAllHeight; //房屋介绍
//房屋介绍 非整租
- (CGFloat)getNotZhengZuIntroduceHeightOneTagsHeight;
- (CGFloat)getNotZhengZuIntroduceHeightTwoTagsHeight;
- (CGFloat)getNotZhengZuIntroduceHeightAllHeight;
/**
 data =     {
     favorite = 0;
     houseAdvantage =         {
         "临街门面" = 2;
         "商业街" = 4;
         "地铁近" = 8;
         "面议" = 1;
     };
     houseAdvantageId = 15;
     houseContact = 15914158051;
     houseDirection = "西北";
     houseFloor = 21;
     houseFurniture =         (
         "冰箱"
     );
     houseFurnitureId = 1;
     houseImage =         (
         "http://222.178.212.29:9000/house-lease-img/4e32e40272caa70e506fcc469563cdf3c39046e29fd76ce402570060b28a4beb",
         "http://222.178.212.29:9000/house-lease-img/4e32e40272caa70e506fcc469563cdf3c39046e29fd76ce402570060b28a4beb",
         "http://222.178.212.29:9000/house-lease-img/36ee8d157c5b56f7bd806c2e87ecfd80ae0c94539c5118edbd1d1cc035e34259"
     );
     houseImageId = 2536298493644800;
     houseIntroduce = "华润中央公园 精装龤室 小区环境优美 适合居家自住";
     houseLat = "145.64";
     houseLeaseDeposit = "压一付一";
     houseLeaseMode = "整租";
     houseLeasedepositId = 1;
     houseLeasemodeId = 2;
     houseLon = "123.23";
     housePrice = 125;
     houseReserveTime = "随时看房";
     houseSquareMeter = 1232;
     houseTitle = "帆云小区 便宜出租 便宜出租!";
     houseType = "一室一厅一卫";
     houseTypeId = 1;
     houseUnit = "年";
     id = 2536298372009984;
 };*/
@end

NS_ASSUME_NONNULL_END
