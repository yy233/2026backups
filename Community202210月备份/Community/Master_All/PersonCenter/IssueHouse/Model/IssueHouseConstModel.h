//
//  IssueHouseConstModel.h
//  Community
//
//  Created by 余莹 on 2021/2/27.
// 常量通用model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssueHouseConstModel : NSObject // 是常量model 和IssueHouseCellBlueSubBtnCellModel 都一样
@property (nonatomic,strong) NSString *annotation;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger houseConstCode;
@property (nonatomic,assign) NSInteger houseConstType;
@property (nonatomic,strong) NSString *houseConstName;
/**   {
     annotation = "\U79df\U623f\U7c7b\U578b";
     houseConstCode = 4;
     houseConstName = "\U522b\U5885";
     houseConstType = 10;
     id = 67;
 },*/
@end

NS_ASSUME_NONNULL_END
