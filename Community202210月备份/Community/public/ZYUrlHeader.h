//
//  ZYUrlHeader.h
//  Community
//
//  Created by ZY on 2021/8/23.
//

#ifndef ZYUrlHeader_h
#define ZYUrlHeader_h


// 是否实名
#define ZY_IsSmallShopGoodsOpen ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isSmallShopGoodsOpen"] isEqualToString:@"1"] ? 1 : 0)


// ------------------投诉建议-------------------
// 新增投诉建议
#define kAddComplaintsOpinionUrl @"proprietor/complain/appendComplain"
// 我的建议
#define kMyOpinionUrl @"proprietor/complain/selectComplain"


// ------------------活动报名-------------------
// 活动报名列表
#define kActivityApplyListURL @"proprietor/activity/list"
// 活动报名详情
#define kActivityApplyDetailURL @"proprietor/activity/selectOne"
// 活动报名
#define kNewActivityApplyURL @"proprietor/activity/apply"
// 取消活动报名
#define kCancelActivityApplyURL @"proprietor/activity/cancel"


// ------------------人脸上传-------------------
// 我的人脸
#define kGetUploadFaceUrl @"proprietor/user/getFace"

// 上传人脸
#define kUploadFaceUrl @"proprietor/user/uploadFace"

// 保存我的人脸
#define kSaveUploadFaceUrl @"proprietor/user/saveFace"

// 删除我的人脸
#define kDeleteUploadFaceUrl @"proprietor/user/deleteFaceAvatar"


// ------------------业主投票(新版名:问卷调查)-------------------
// 业主投票列表
#define kOwnersVoteListUrl @"proprietor/vote/list"

// 业主投票详情
#define kOwnersVoteDetailUrl @"proprietor/vote/getVote"

// 投票进度
#define kOwnersVotePlanUrl @"proprietor/vote/getPlan"

// 业主投票
#define kOwnersVoteUrl @"proprietor/vote/userVote"

// 问卷问答题查看更多
#define kOwnersVoteGetMoreUrl @"proprietor/vote/getMore"


// ------------------社区集市-------------------
// 发布商品
#define kAddMarketUrl @"proprietor/market/addMarket"

// 修改商品
#define kUpdateMarketUrl @"proprietor/market/updateMarket"

// 删除商品
#define kDeleteMarketUrl @"proprietor/market/deleteMarket"

// 查询已发布商品
#define kSelectMarketPageUrl @"proprietor/market/selectMarketPage"

// 上传商品图片
#define kUploadMarketImagesUrl @"proprietor/market/uploadMarketImages"

// 删除商品图片
#define kDeleteMarketImageUrl @"proprietor/market/deleteMarketImages"

// 修改商品上下架状态
#define kUpdateStateUrl @"proprietor/market/updateState"

// 查询所有发布的商品
#define kSelectMarketAllPageUrl @"proprietor/market/selectMarketAllPage"

// 商品的详情
#define kSelectOneMarketUrl @"proprietor/market/SelectOneMarket"

// 商品的所有类别
#define kSelectMarketCategoryUrl @"proprietor/marketCategory/selectMarketCategory"

// 编辑发布商品的类别
#define kEditSelectMarketCategoryUrl @"proprietor/marketCategory/selectMarketcategoryList"

// 商品的所有标签
#define kSelectMarketLabelUrl @"proprietor/marketLabel/selectMarketLabel"

// 猜你喜欢
#define kSelectMarketLikePageUrl @"proprietor/market/selectMarketLikePage"


// ------------------社区集市(新)-------------------
// 所有分类
#define kCommunityFairCategoryUrl @"proprietor/marketCategory/selectMarketCategory"

// 所有标签
#define kCommunityFairMarkUrl @"proprietor/marketLabel/selectMarketLabel"

// 发布商品
#define kCommunityFairIssueUrl @"proprietor/market/addMarket"


// ------------------租赁签章-------------------
// 租赁签约详情
#define kRentSignDetailUrl @"lease/house/v2/contractDetail"

// 租客发起签约
#define kTenantInitContractUrl @"lease/house/v2/initContract"

// 签约相关操作(租客取消申请/房东拒绝申请/租客再次申请/房东接受申请)
#define kOperationContractUrl @"lease/house/v2/operationContract"

// 房东查看单个资产的签约列表
#define kLandlordContractListUrl @"lease/house/v2/landlordContractList"

// 租赁合同预填参数查询
#define kQueryContractPreFillInfoUrl @"lease/house/v2/queryContractPreFillInfo"


// ------------------临时缴费-------------------
// 查询临时车辆订单
#define kGetTemporaryOrderUrl @"proprietor/car/getTemporaryOrder"

// 查询临时订单详情
#define kGetTemporaryOrderDetailUrl @"proprietor/car/getTemporaryOrderById"


// ------------------报事报修-------------------
// 报事报修类别
#define kGetRepairTypeCategoryUrl @"proprietor/repairType/getType"

// 添加报事报修
#define kAddRepairUrl @"proprietor/repair/addRepair"

// 工单类型列表
#define kRepairOrderListUrl @"proprietor/repair/query/type"

// 公共区域报事位置列表
#define kRepairAddressListUrl @"proprietor/repair/query/region"

// 指定小区的房屋列表
#define kRepairMyHouseUrl @"proprietor/user/house/myHouse"

// 工单进度
#define kRepairOrderRecordInfoUrl @"proprietor/repair/orderRecordInfo"


// ------------------社区小店-------------------
// 首页
#define kSmallShopHomeUrl @"zhsj/cabinet/store/selectCommunityIdHome"

// 热门推荐
#define kSmallShopHotListUrl @"zhsj/cabinet/storeCommodity/selectHotCommodityList"

// 商品列表
#define kSmallShopCommodityListUrl @"zhsj/cabinet/storeCommodity/selectByCommunityId"

// 商品详情
#define kSmallShopCommodityDetailUrl @"zhsj/cabinet/storeCommodity/selectCommodityDetails"

// 服务列表
#define kSmallShopServeListUrl @"zhsj/cabinet/storeServe/selectByCommunityId"

// 服务详情
#define kSmallShopServeDetailUrl @"zhsj/cabinet/storeServe/selectServeDetails"

// 货柜列表
#define kSmallShopContainerListUrl @"zhsj/cabinet/cabinet/selectPageCabinetByUser"

// 货柜详情
#define kSmallShopContainerDetailUrl @"zhsj/cabinet/cabinet/selectCabinetIDByUser"

// 新增订单
#define kSmallShopAddOrderUrl @"zhsj/cabinet/order/insertOrder"

// 续租｜生成订单
#define kSmallShopBoxReletRentAddOrderUrl @"zhsj/cabinet/orderCabinet/reletCabinetOrder"

// 新增商品到购物车
#define kSmallShopAddShoppingCartUrl @"zhsj/cabinet/car/insertCar"

// 拼团详情
#define kSmallShopSpellGroupDetailUrl @"zhsj/cabinet/spell/selectCommunitySpell"

// 支付
#define kSmallShopPayUrl @"zhsj/cabinet/pay/payOrder"

// 拼团订单
#define kSmallShopSpellGroupOrderUrl @"zhsj/cabinet/spell/joinSpellInsterOrder"

// 小店开通判断
#define kSmallShopIsOpenUrl @"zhsj/cabinet/store/selectByCommunityId"


// ------------------出入记录-------------------
// 可访问的成员
#define kVisitPermitListUrl @"proprietor/houseMember/query/visit/permit"

// 出入记录列表
#define kVisitRecordListUrl @"proprietor/houseMember/people/history"

// 访客权限
#define kVisitJurisdictionUrl @"proprietor/houseMember/modify/visit/permit"

// 单个通知权限
#define kSingleNotiJurisdictionUrl @"proprietor/houseMember/modify/notice/permit"

// 批量通知权限
#define kBatchNotiJurisdictionUrl @"proprietor/houseMember/unbind/people/history"


// ------------------智能停车-------------------
// 我的月卡
#define kParkingMonthCardUrl @"carSystem/car-position/myMonthCardCarPosition"

// 用户所有房屋
#define kParkingAllHouseUrl @"carSystem/house/selectCommunityAllBuildingByUserId"

// 场地分类
#define kParkingStallCategoryUrl @"carSystem/car-site-classification/selectPageSitClassification"

// 停车位置
#define kParkingCarAddressUrl @"carSystem/car-position/selectGroundUpAndDown"

// 关联车辆(地面)
#define kParkingRelevantCarUrl @"carSystem/car/selectAppByUserId"

// 关联车位(地下)
#define kParkingRelevantStallUrl @"carSystem/car-position/selectNoMonthlyRentBySiteClassificationId"

// 月租价格
#define kParkingMonthCardPriceUrl @"carSystem/car-position/selectMoneyByCarPositionId"

// 月租到期时间
#define kAddParkingMonthCardExpireTimeUrl @"carSystem/car-position/selectMoneyTime"

// 续租后到期时间
#define kParkingMonthCardRenewalExpireTimeUrl @"carSystem/car-position/selectMoneyTimeRenew"

// 最大包月数量
#define kParkingMonthCardMaxMonthUrl @"carSystem/car-position/selectMoneyMax"

// 购买月租卡
#define kAddParkingMonthCardUrl @"carSystem/car-position/myPayMonthCardCarPosition"

// 包月续租
#define kParkingMonthCardRenewalUrl @"carSystem/car-position/myPayMonthCardCarPositionContinuous"

// 取消订单
#define kParkingMonthCardCancelOrderUrl @"carSystem/car-position/cancelOrderByOrderNumber"

// 月租卡支付
#define kParkingMonthCardPayUrl @"carSystem/pay/payOrder"


// ------------------物业缴费-------------------
// 物业缴费详情
#define kPropertyPayCostDetailUrl @"proprietor/FinanceOrder/findOne"


// ------------------文件上传公共接口-------------------
// 单个上传
#define kBaseFileUploadUrl @"zhsj/base/api/file/up/load"

// 批量上传
#define kBaseFilesUploadUrl @"zhsj/base/api/file/up/load/batch"

#endif /* ZYUrlHeader_h */
