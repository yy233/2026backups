//
//  HouseRentDetailBuniessShopLocationTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/8.
//

#import "HouseRentDetailBuniessShopLocationTableViewCell.h"

@implementation HouseRentDetailBuniessShopLocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(HouseRentDetailVcHouseModel *)model{
    //重写滞空
}
- (void)setBuniessModel:(HouseRentDetailVcBuniessShopModelShopModel *)buniessModel{
    WEAKSELF
    weakSelf.detailL.text = [TextShowWithModelStr textShowWithModelStr:buniessModel.shopAddress];
    _buniessModel = buniessModel;
    
//    self.detailL.text = [TextShowWithModelStr textShowWithModelStr:buniessModel.address];
    double lat = _buniessModel.lat;
    double lon = _buniessModel.lon;
//    //test
//    lat = 37.32;
//    lon =  -122.03;
    
   
    CLLocationCoordinate2D location;
    location.latitude = lat;
    location.longitude = lon;
    MapAnnotation *newAnnotation = [[MapAnnotation alloc] initWithTitle:[TextShowWithModelStr textShowWithModelStr:_buniessModel.title] andCoordinate:location];
    [self.mapView addAnnotation:newAnnotation];
    [self addMapViewEndShowWithCenterLat:lat lon:lon];
}
@end
