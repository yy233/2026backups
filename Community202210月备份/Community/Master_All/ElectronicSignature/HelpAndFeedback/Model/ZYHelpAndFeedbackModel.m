//
//  ZYHelpAndFeedbackModel.m
//  Community
//
//  Created by ZY on 2021/7/19.
//

#import "ZYHelpAndFeedbackModel.h"

@implementation ZYHelpAndFeedbackModel

@end


@implementation ZYHelpAndFeedbackDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{@"list" : [ZYHelpAndFeedbackDataListModel class]};
}

@end


@implementation ZYHelpAndFeedbackDataListModel

@end
