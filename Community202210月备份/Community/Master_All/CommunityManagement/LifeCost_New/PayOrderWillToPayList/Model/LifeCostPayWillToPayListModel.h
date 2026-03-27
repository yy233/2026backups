//
//  LifeCostPayWillToPayListModel.h
//  Community
//
//  Created by 余莹 on 2022/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPayWillToPayListModel : NSObject
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *beginDate;
@property (nonatomic,copy) NSString *billAmount;
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,assign) NSInteger ID;
/**
 
 data =     (
             {
         beginDate = "2012/11/26";
         billAmount = 1;
         id = 141689417323646976;
         idStr = 141689417323646976;
     }
 );
 */
@end

NS_ASSUME_NONNULL_END
