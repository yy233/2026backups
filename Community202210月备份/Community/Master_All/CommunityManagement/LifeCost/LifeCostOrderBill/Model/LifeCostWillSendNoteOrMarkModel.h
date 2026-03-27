//
//  LifeCostWillSendNoteOrMarkModel.h
//  Community
//
//  Created by 余莹 on 2021/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostWillSendNoteOrMarkModel : NSObject

@property (nonatomic,strong) NSString *tally; //标签
@property (nonatomic,strong) NSString *remark;    //备注
@property (nonatomic,strong) NSString *remarkImg; //备注图的url
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger billClassification;

@end

NS_ASSUME_NONNULL_END
