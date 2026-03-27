//
//  HouseRepairMainListViewModel.h
//  Community
//
//  Created by 余莹 on 2022/3/4.
//

#import <Foundation/Foundation.h>
#import "HouseRePairHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyRepairMainListViewModel : BaseDataViewModel
@property (nonatomic,assign) MyRepair_PageList_Show_Type saveNowListTypeWithDealData;

- (void)getDataListOnePageWithType:(MyRepair_PageList_Show_Type)dataType;

@end

NS_ASSUME_NONNULL_END
