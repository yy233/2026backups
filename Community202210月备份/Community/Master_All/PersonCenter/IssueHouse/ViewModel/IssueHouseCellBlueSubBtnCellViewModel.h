//
//  IssueHouseCellBlueSubBtnCellViewModel.h
//  Community
//
//  Created by 余莹 on 2021/1/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface IssueHouseCellBlueSubBtnCellViewModel : NSObject
//+ (void)getHouseBlueSubCellViewAllArrWithHouseIssueType:(IssueHouse_Type)issHouseType withListArr:(BaseListArrAndSuccessBoolBlock)listBlock;
//1015换掉旧的用新的标签数据
+ (void)getHouseBlueSubCellViewAllArrWithHouseIssueType:(IssueHouse_Type)issHouseType withNewListArr:(BaseListArrAndSuccessBoolBlock)listBlock;
@end

NS_ASSUME_NONNULL_END
