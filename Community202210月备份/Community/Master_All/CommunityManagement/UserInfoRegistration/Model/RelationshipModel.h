//
//  RelationshipModel.h
//  Community
//
//  Created by 余莹 on 2020/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RelationshipModel : UIView
@property (nonatomic,strong) NSString *name;//类型名称
@property (nonatomic,assign) NSInteger code;//类型号
+ (NSString *)getRelationShipRelativeNameWithCode:(NSInteger)code;//和业主的亲属关系
@end

NS_ASSUME_NONNULL_END
