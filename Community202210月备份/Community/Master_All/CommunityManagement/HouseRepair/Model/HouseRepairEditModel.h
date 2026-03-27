//
//  HouseRepairEditModel.h
//  Community
//
//  Created by 余莹 on 2020/12/26.
//   编辑界面 将要上传的 数据 model在topView和bottomView里做数据时使用

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRepairEditModel : HouseRepairDetailModel
//@property (nonatomic,strong) NSString *name;
//@property (nonatomic,strong) NSString *phone;
//@property (nonatomic,strong) NSString *address;
//@property (nonatomic,strong) NSString *type;
//@property (nonatomic,strong) NSString *problem;
//@property (nonatomic,assign) NSInteger commuintyId;
//@property (nonatomic,strong) NSString *repairImg;
//以上都有

//选择地址 通知拿到的 model
@property (nonatomic,strong) CityChooseModel *cityModel;
@property (nonatomic,strong) CommunityModel *communityModel;
@property (nonatomic,strong) BuildingModel *buildModel;
@property (nonatomic,strong) UnitModel *unitModel;
@property (nonatomic,strong) FloorModel*floorModel;
@property (nonatomic,strong) AddressModel *addressModel;
//报修类别 个人 公共
@property (nonatomic,assign) NSInteger repairType; // 报修类别  0个人报修   1公共报修


/*
 {
   "name": "李大娘",
   "phone": "987564321",
   "problem": "测试堵了",
   "communityId":1,
   "repairImg": "123.png,456.png,789.png",
   "address": "地门小区5栋2单元3-2",
   "type":89
 }*/
@end

NS_ASSUME_NONNULL_END
