//
//  IntelligentInquirySearchModel.h
//  Community
//
//  Created by 余莹 on 2021/12/14.
//

#import <Foundation/Foundation.h>
#import "MedicalStoresBaseModel.h"
#import "MedicalServiceBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IntelligentInquirySearchModel : NSObject

@property (nonatomic,strong) NSMutableArray *goodsList;
@property (nonatomic,strong) NSMutableArray *shopList;

@end

NS_ASSUME_NONNULL_END
