//
//  ZYContractKnowledgeListModel.h
//  Community
//
//  Created by ZY on 2021/5/17.
//

#import <Foundation/Foundation.h>

@class ZYContractKnowledgeListDataModel, ZYContractKnowledgeListDataListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYContractKnowledgeListModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, assign) BOOL success;

@property (nonatomic, assign) BOOL fail;

@property (nonatomic, strong) ZYContractKnowledgeListDataModel *data;

@end


@interface ZYContractKnowledgeListDataModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger pages;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<ZYContractKnowledgeListDataListModel *> *list;

@end


@interface ZYContractKnowledgeListDataListModel : NSObject

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger likeNumber;

@property (nonatomic, assign) NSInteger commentNumber;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *createTime;

@end

NS_ASSUME_NONNULL_END
