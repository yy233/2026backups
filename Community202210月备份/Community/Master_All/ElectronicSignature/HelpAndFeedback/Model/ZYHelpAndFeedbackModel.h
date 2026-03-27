//
//  ZYHelpAndFeedbackModel.h
//  Community
//
//  Created by ZY on 2021/7/19.
//

#import <Foundation/Foundation.h>

@class ZYHelpAndFeedbackDataModel, ZYHelpAndFeedbackDataListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYHelpAndFeedbackModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, assign) BOOL success;

@property (nonatomic, assign) BOOL fail;

@property (nonatomic, strong) ZYHelpAndFeedbackDataModel *data;

@end


@interface ZYHelpAndFeedbackDataModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger pages;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<ZYHelpAndFeedbackDataListModel *> *list;

@end


@interface ZYHelpAndFeedbackDataListModel : NSObject

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *createTime;

// 是否选中
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
