//
//  IntelligentInquirySearchData.h
//  Community
//
//  Created by 余莹 on 2021/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntelligentInquirySearchData : NSObject

+ (void)getIntelligentInquiryListWithSearchText:(NSString *)getSearchText withBlock:(BaseDicAndSuccessBoolBlock)block;  

@end

NS_ASSUME_NONNULL_END
