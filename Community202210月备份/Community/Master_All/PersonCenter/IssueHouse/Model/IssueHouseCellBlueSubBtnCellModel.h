//
//  IssueHouseCellBlueSubBtnCellModel.h
//  Community
//
//  Created by 余莹 on 2021/1/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//typedef enum : NSUInteger {
////    HouseCellBlueSubBtnCell_type_,
////    HouseCellBlueSubBtnCell_type_,
////    HouseCellBlueSubBtnCell_type_,
//} HouseCellBlueSubBtnCell_type;

//@"lease/const"//房屋常量查询
/**
 11 : @"租房方式"
 12: @"出租房源类型"
 13 : @"房屋家具"
 18: @"装修情况"
 19 : @"房屋亮点"
 20 : @"室友性别"
 21 : @"出租要求"
 22 :@"室友期望"
 //13更改 ———— 是总的 （公共设施 房间设施 公共设施23 房间设施24） */
@interface IssueHouseCellBlueSubBtnCellModel : NSObject

@property (nonatomic,strong) NSString *annotation;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger houseConstCode;
@property (nonatomic,assign) NSInteger houseConstType;
@property (nonatomic,strong) NSString *houseConstName;

@end

NS_ASSUME_NONNULL_END
