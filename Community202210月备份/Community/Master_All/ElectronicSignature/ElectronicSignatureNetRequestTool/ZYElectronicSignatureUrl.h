//
//  ZYElectronicSignatureUrl.h
//  Community
//
//  Created by ZY on 2021/4/9.
//

#ifndef ZYElectronicSignatureUrl_h
#define ZYElectronicSignatureUrl_h

// 签章基础接口
#define kElectronicSignatureBaseUrl    BASE_URL_OnlyAsOfPort

// 签章图片基础接口(旧)
//#define kElectronicSignatureImageBaseUrl @"http://222.178.212.29:9000/"
// 签章图片基础接口(全路径)
#define kElectronicSignatureImageBaseUrl @""

#define  ZY_BASEURL(_URL)  [NSString stringWithFormat:@"%@%@", kElectronicSignatureBaseUrl, _URL]

// 是否实名
#define ZY_IsRealName ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isRealNameElectronicSignature"] isEqualToString:@"1"] ? 1 : 0)


// -------------------实名认证相关接口-------------------
// 是否实名认证接口(新)
#define kIsRealNameAuthenticationUrl @"zh-sign/contract-server/user/isRealName"


// -------------------合同模板相关接口-------------------
// 合同模板类型接口
#define kContractTemplatesTypeUrl @"zh-sign/contract-server/tDictionaryItemsService/templateDetails"

// 合同模板接口
#define kContractTemplatesUrl @"zh-sign/template-server/template/pageByType"

// 合同模板详情接口
#define kContractTemplateDetailUrl @"zh-sign/template-server/template/getTemplateByUuid"

// 新增合同模板参数接口
#define kTemplateSaveUrl @"zh-sign/template-server/template/saveUserTemp"

// 修改合同模板参数接口
#define kUpdateTempParamUrl @"zh-sign/template-server/templateParams/updateTempParams"

// 另存为个人模板（新）
#define kSavePersonalTemplateUrl @"zh-sign/template-server/personal/template/savePersonalTemplate"

// 批量修改个人模板参数（保存修改）（新）
#define kUpdatePersonalTemplateParamsUrl @"zh-sign/template-server/personal/template/updatePersonalTemplateParams"

// 查询个人模板详情
#define kGetPersonalTemplateUrl @"zh-sign/template-server/personal/template/getPersonalTemplate"

// 分页条件查询个人模板
#define kPersonalTemplatePageUrl @"zh-sign/template-server/personal/template/page"

// 存储模板草稿接口
#define kSaveTemplateDraftUrl @"zh-sign/template-server/template/draft/save"

// 草稿模板详情接口
#define kDraftTemplateDetailUrl @"zh-sign/template-server/template/draft/getTemplateDraft"


// ------------------印章相关接口-------------------
// 所有印章接口
#define kAllSealUrl @"zh-sign/seal-server/seal/select/list"

// 设为默认印章接口
#define kDefaultSealUrl @"zh-sign/seal-server/seal/update/default"

// 默认印章接口
#define kSelectDefaultSealUrl @"zh-sign/contract-server/seal/select/default"

// 系统印章接口
#define kSystemSealUrl @"zh-sign/seal-server/seal/select/system"

// 新增手写印章接口
#define kAddHandwrittenSealUrl @"zh-sign/seal-server/seal/insert"

// 新增用户个人印章
#define kAddPersonalSealUrl @"zh-sign/seal-server/seal/insertPersonalSeal"

// 获取用户个人印章
#define kGetPersonalSealUrl @"zh-sign/seal-server/seal/getPersonalSeal"

// 删除用户个人印章
#define kDeletePersonalSealUrl @"zh-sign/seal-server/seal/deleteUserSeal"


// ------------------文件操作相关接口-------------------
// 文件上传接口
#define kFileUploadUrl @"zh-sign/contract-server/file/upload"

// 文件批量上传接口
#define kFileUploadsUrl @"zh-sign/contract-server/file/uploads"

// 文件删除接口
#define kFileDeleteUrl @"zh-sign/contract-server/file/delete"

// 文件下载接口
#define kFileDownloadUrl @"zh-sign/contract-server/file/download"

// 获取文件信息接口
#define kFileInfoUrl @"zh-sign/contract-server/file/select"


// ------------------合同管理相关接口-------------------
// 所有待我处理的合同接口
#define kAllContractsAwaitingAttentionUrl @"zh-sign/contract-server/contract/contractManage/allWaitForMeToSign"

// 全部合同接口
#define kAllContractsUrl @"zh-sign/contract-server/contract/contractManage/allContracts"

// 待他人处理合同接口
#define kContractToBeSignedUrl @"zh-sign/contract-server/contract/contractManage/contractToBeSigned"

// 已完成合同接口
#define kCompletedContractUrl @"zh-sign/contract-server/contract/contractManage/completedContract"

// 即将过期合同接口
#define kContractIsAboutToCloseUrl @"zh-sign/contract-server/contract/contractManage/theContractIsAboutToClose"

// 即将截止签署合同接口
#define kContractAboutToExpireUrl @"zh-sign/contract-server/contract/contractManage/contractAboutToExpire"

// 已失效合同接口
#define kContractIsInvalidUrl @"zh-sign/contract-server/contract/contractManage/contractIsInvalid"

// 我发起的
#define kContractMySendUrl @"zh-sign/contract-server/contract/contractManage/initiatedContractAllToMe"

// 合同详情接口
#define kContractDetailUrl @"zh-sign/contract-server/contract/contractManage/getOne"

// HTML合同详情
#define kContractHTMLDetailUrl @"zh-sign/contract-server/contract/contractManage/details"

// 模板PDF预览
#define kContractTemplatePreviewUrl @"zh-sign/template-server/template/templatePreview"

// 下载合同和过程证据，通过证据码下载 - 不需要加密
#define kContractDownloadProcUrl @"zh-sign/contract-server/contract/contractManage/down_Con_Proce"

// 下载合同接口
#define kContractDownloadUrl @"zh-sign/contract-server/contract/contractManage/downloadContract"

// 查詢过程证据接口
#define kProcessEvidenceUrl @"zh-sign/contract-server/contract/contractManage/processEvidence"

// 对合同上链状态一直没有更新，进行自检重试，并重新上链
#define kSelfTestRetryUrl @"zh-sign/contract-server/native/contract/selfTestRetry"

// 租赁取消合同接口
#define kRentContractCancelUrl @"zh-sign/contract-server/native/contract/contractCancel"


// ------------------合同发起签署相关接口-------------------
// 双方合同发起接口
#define kContractInitiationUrl @"zh-sign/contract-server/native/contract/contractInitiation"

// 甲方发起后乙方签章接口
#define kContractBtoSignUrl @"zh-sign/contract-server/native/contract/contractToSign"


// ------------------合同知识相关接口-------------------
// 合同知识列表接口
#define kContractKnowledgeListUrl @"zh-sign/contract-server/information/select/list"

// 合同知识点赞接口
#define kContractKnowledgeLikeUrl @"zh-sign/contract-server/information/like"

// 合同知识收藏接口
#define kContractKnowledgeCollectionUrl @""

// 合同知识点赞数接口
#define kContractKnowledgeSelectLikeUrl @"zh-sign/contract-server/information/select/like"

// 合同知识评论列表接口
#define kContractKnowledgeCommentListUrl @"zh-sign/contract-server/comment/select/list"

// 合同知识评论接口
#define kContractKnowledgeInsertCommentUrl @"zh-sign/contract-server/comment/insert"


// ------------------用户相关接口-------------------
// 根据手机号搜索用户接口
#define kGetUserByPhoneUrl @"zh-sign/contract-server/user/getUserByPhone"

// 根据用户uuid获取实名信息
#define kGetUserRealNameUrl @"zh-sign/user-server/user/getUserToUuid"

// 区块链电子身份证
#define kBlockchainIDcardUrl @"zh-sign/user-server/user/electronicIdCard"

// 区块链订单凭证
#define kBlockchainOrderEvidenceUrl @"zh-sign/contract-server/community/sign/getBlockChainCommunityOrder"


// ------------------问题反馈相关接口-------------------
// 常见问题列表接口
#define kCommonProblemUrl @"zh-sign/contract-server/commonProblem/page"

// 新增一条问题反馈记录接口
#define kFeedbackInsertUrl @"zh-sign/contract-server/feedback/save"


// ------------------签署密码设置相关接口-------------------
// 是否绑定手机号接口
#define kContractTelephoneNumberIsBindingUrl @"zh-sign/contract-server/user/telephoneNumberIsBinding"

// 绑定手机号接口
#define kContractBindingPhoneNumberUrl @"zh-sign/contract-server/user/bindingPhoneNumber"

// 发送验证码接口
#define kContractSendPhoneMessageUrl @"zh-sign/contract-server/user/sendPhoneMessage"

// 短信验证码验证接口
#define kContractPhoneMessageIsCorrectUrl @"zh-sign/contract-server/user/phoneMessageIsCorrect"

// 签署密码是否正确接口
#define kContractPasswordIsCorrectUrl @"zh-sign/contract-server/user/passwordIsCorrect"

// 签署密码是否存在接口
#define kContractIsSignPasswordUrl @"zh-sign/contract-server/user/isSignPassword"

// 设置签署密码接口
#define kContractSetSignPasswordUrl @"zh-sign/contract-server/user/setSignPassword"

// 修改签署密码接口
#define kContractUpdateSignPasswordUrl @"zh-sign/contract-server/user/updateSignPassword"

// 忘记签署密码接口
#define kContractForgetSignPasswordUrl @"zh-sign/contract-server/user/forgetSignPassword"


// ------------------签署支付置相关接口-------------------
// 合同是否付款接口
#define kIsContractPayUrl @"zh-sign/contract-server/houseLeaseContract/selectHouseLeaseContractPay"

// 计算房屋租赁合同首款
#define kHouseLeasePaymentUrl @"zh-sign/contract-server/contract/contractManage/houseLeasePayment"

#endif /* ZYElectronicSignatureUrl_h */
