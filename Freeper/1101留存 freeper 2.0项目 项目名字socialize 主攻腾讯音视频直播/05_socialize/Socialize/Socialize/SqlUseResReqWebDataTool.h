//
//  SqlUseResReqWebDataTool.h
//  Socialize
//
//  Created by 余莹 on 2023/8/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SqlUseResReqWebDataTool : NSObject

singleton_interface(share);


#pragma mark === sql
- (void)haveSqlInfoWithType:(NSInteger)type
              withSqlStrArr:(NSArray *)sqlArr
         withMessageBodyDic:(NSDictionary *)messageBodyDic
    ofwillUseSendWkDicBlock:(BaseDicAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
