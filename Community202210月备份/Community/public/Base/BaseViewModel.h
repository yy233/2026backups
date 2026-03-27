//
//  BaseViewModel.h
//  Community
//
//  Created by 余莹 on 2020/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BaseListArrBlock)(NSArray *);
typedef void(^BaseListArrAndSuccessBoolBlock)(NSArray *,BOOL);
typedef void(^BaseDicBlock)(NSDictionary *);
typedef void(^BaseDicAndSuccessBoolBlock)(NSDictionary *,BOOL);
@interface BaseViewModel : NSObject
/**
 
 BaseListArrBlock block = list;
 if (isNotNil(responsObject)) {
     if (Y_IS_Success) {
         block(Y_ResponsObject_dataArr);
     }else{
         block(@[]);
     }
 }else{
     block(@[]);
 }
 
 BaseListArrAndSuccessBoolBlock block = listBlock;
 if (isNotNil(responsObject)) {
     if (Y_IS_Success) {
         block(Y_ResponsObject_dataArr,YES);
     }else{
         block(@[],NO);
         Y_SVP_SHOW_ERR_MESSAGE
     }
 }else{
     block(@[],NO);
     Y_SVP_SHOW_ERR_DESCRIPTION
 }
}];
 
 BaseDicAndSuccessBoolBlock block = dicBlock;
 if (isNotNil(responsObject)) {
     if (Y_IS_Success) {
         NSDictionary *dic = Y_ResponsObject_dataDic;
         block(dic,YES);
     }else{
         block(@{},NO);
         Y_SVP_SHOW_ERR_MESSAGE
     }
 }else{
     block(@{},NO);
     Y_SVP_SHOW_ERR_DESCRIPTION
 }
}];
 */
@end

NS_ASSUME_NONNULL_END
