//
//  ZYLifeCostUrlHeader.h
//  Community
//
//  Created by ZY on 2022/1/5.
//

#ifndef ZYLifeCostUrlHeader_h
#define ZYLifeCostUrlHeader_h


// ------------------户号管理-------------------
// 户号列表
#define kLifeCostHouseholdListUrl @"api/v1/proprietor/livingExpensesGroup/v2/accountList"

// 添加分组
#define kLifeCostAddGroupUrl @"api/v1/proprietor/livingExpensesGroup/v2/addGroup"

// 修改分组
#define kLifeCostUpdateGroupUrl @"api/v1/proprietor/livingExpensesGroup/v2/updateGroup"

// 删除分组
#define kLifeCostDeleteGroupUrl @"api/v1/proprietor/livingExpensesGroup/v2/deleteGroup"

// 分组列表
#define kLifeCostGetGroupListUrl @"api/v1/proprietor/livingExpensesGroup/v2/groupList"

// 附近小区
#define kLifeCostNearCommunityUrl @"api/v1/proprietor/community/v2/nearbyCommunity"

// 绑定户号
#define kLifeCostAddHouseholdUrl @"api/v1/proprietor/livingExpensesAccount/v2/addAccount"

// 修改户号
#define kLifeCostModifyHouseholdUrl @"api/v1/proprietor/livingExpensesAccount/v2/modifyAccount"

// 删除户号
#define kLifeCostDeleteHouseholdUrl @"api/v1/proprietor/livingExpensesAccount/v2/deleteAccount"


// ------------------其它接口-------------------
// 查询城市
#define kLifeCostCityUrl @"api/v1/payment/cebBank/v2/queryCity"

#endif /* ZYLifeCostUrlHeader_h */
