//
//  API.swift
//  CodeLabApp
//
//  Created by Sera on 2023/5/30.
//

import Foundation
import APIKit

enum LoginAPI: String, API {
    case phoneCodeSend = "v1/account/send_verify_code"
    case phoneLogin = "v1/account/login"
    case registerUserName = "v1/account/init"
    case registerAvatarList = "v1/account/avatar/candidate"
    case getOSSToken = "v1/user/oss_token"
    case appLaunch = "v1/user/startup"
    case logout = "v1/account/logout"
    
    var apiString: String { rawValue }
}

enum MainAPI: String, API {
    case mainList = "index/"
    case userRank = "index/points/rank"
    case nftRank = "index/goods/rank"
    case recommendCommunity = "v1/feed/recCommunity"
    case magazineList = "v1/magazine/list"
    case magazineDetail = "v1/magazine/get"
    case magazineSearch = "v1/magazine/search"
    case contentReport = "v1/report/report"
    
    var apiString: String { rawValue }
}

enum FeedAPI: String, API {
    case followList = "v1/feed/follows"
    case recommendList = "v1/feed/recommend"
    case publishList = "v1/feed/userPublishFeedList"
    case feedDetailInfo = "v1/feed/detail"
    case feedPublish = "v1/feed/publish"
    case feedDelete = "v1/feed/delete"
    
    case like = "v1/feed/like"
    case cancelLike = "v1/feed/dislike"
    
    case mark = "v1/feed/mark"
    case cancelMark = "v1/feed/unmark"
    case markList = "v1/feed/userMarkFeedList"
    
    case tagSearch = "v1/feed/searchLabel"
    case tagCreate = "v1/feed/addLabel"
    case tagFeedList = "v1/feed/label/feedList"
    
    case locationSearch = "v1/feed/searchPoi"
    case locationFeedList = "v1/feed/poiFeedList"

    case communitySearch = "v1/feed/searchCommunity"
    case communityCreate = "v1/feed/addCommunity"
    case communityDetail = "v1/feed/communityDetailInfo"
    case communityFeedList = "v1/feed/community/feedList"
    case communityFollow = "v1/feed/followCommunity"
    case communityCancelFollow = "v1/feed/unfollowCommunity"
    case communityFeedTop = "v1/feed/communityTopFeed"
    case communityFeedCancelTop = "v1/feed/communityCancelTopFeed"
    case communityFeedHidden = "v1/feed/communityFeedHidden"
    case communityManagerApply = "v1/feed/communityManagerApply"

    case commentList = "v1/feed/comment/list"
    case ownCommentList = "v1/feed/comment/myCommentList"
    case commentDelete = "v1/feed/comment/delete"
    case commentPublish = "v1/feed/comment/publish"
    case replyList = "v1/feed/comment/replyList"

    var apiString: String { rawValue }
}

enum UserAPI: String, API {
    case userInfo = "v1/user/"
    case userHomeData = "v1/userHomepage/list"
    case userFollow = "v1/relation/follow"
    case userCancelFollow = "v1/relation/unfollow"
    case followList = "v1/relation/followList"
    case fansList = "v1/relation/fansList"
    case fanRemove = "v1/relation/deleteFans"
    case userEdit = "v1/user/modify"
    case userRemoveAccount = "v1/user/cancel"
    case pushSettings = "v1/push/setPushSwitch"
    case pushSwitchInfo = "v1/push/pushSwitchSettings"
    
    var apiString: String { rawValue }
}

enum NoticeAPI: String, API {
    case noticeList = "v1/notice/listByType"
    case systemList = "v1/notice/listSystemNotice"
    case unreadCount = "v1/notice/noticeRedCount"
    
    var apiString: String { rawValue }
}

enum NFTAPI: String, API {
    case ownNFTList = "v1/nft/user/list"
    case mallList = "v1/mall/points/goods/list"
    case typeList = "v1/mall/points/classification/list"
    
    case mark = "v1/nft/mark/mark"
    case cancelMark = "v1/nft/mark/un_mark"
    case markNFTList = "v1/nft/mark/list"
    
    case nftPriceLine = "v1/mall/points/goods/kLine"
    case nftDetailInfo = "v1/mall/points/goods/get"
    
    case pointsNFTList = "v1/mall/points/raffle/list"
    case pointsGetRandomNFT = "v1/mall/points/raffle/raffle"
    
    case ownProxyList = "v1/mall/points/commission_buy/list"
    case proxyCancel = "v1/mall/points/commission_buy/cancel"
    case onSaleByProxy = "v1/mall/points/commission_sell/sell"
    case proxySubmit = "v1/mall/points/commission_buy/buy"
    case ownSaleList = "v1/mall/points/commission_sell/user/list"
    
    case nftSaleList = "v1/mall/points/commission_sell/list"
    case nftPay = "v1/mall/points/commission_sell/buy"
    case nftCancelSale = "v1/mall/points/commission_sell/cancel"
    
    case nftSearch = "v1/mall/points/goods/search"
    
    var apiString: String { rawValue }
}

enum PointsAPI: String, API {
    case taskList = "v1/task/taskList"
    case pointsReceive = "v1/task/receive"
    case userPoints = "v1/wallet/get"
    case pointsLogList = "v1/wallet/points/record"
    case orderList = "v1/mall/points/order/list"
    
    var apiString: String { rawValue }
}

enum GoodsAPI: String, API {
    case goodsCategoryList = "v1/mall/goods/outGoodsCategory"
    case goodsCategorySection = "v1/mall/goods/insideGoodsCategory"
    case goodsDetailInfo = "v1/mall/goods/goodsDetail"
    case brandGoodsList = "v1/mall/goods/bordGoods"
    
    case categoryGoodsList = "v1/mall/goods/categoryGoodsList"
    case typeGoodsList = "v1/mall/goods/typeGoodsList"
    case typeGoodsFilter = "v1/mall/goods/searchTypeBySizeAndPriceGoods"

    case orderList = "v1/mall/order/orderList"
    case orderPay = "v1/mall/order/orderDo"
    case orderDetailInfo = "v1/mall/order/orderDetail"
    case orderCancel = "v1/mall/order/orderCancel"
    case orderAfterSale = "v1/mall/order/orderAfterSales"
    case orderCreate = "v1/mall/order/createOrder"
    case orderAfterSaleCancel = "v1/mall/order/cancelOrderAfterSales"
    
    case addressEdit = "v1/mall/address/modifyAddress"
    case addressDelete = "v1/mall/address/delete"
    case addressList = "v1/mall/address/addressList"
    case addressDetailInfo = "v1/mall/address/addressDetail"
    case addressAdd = "v1/mall/address/addAddress"
    
    case goodsMark = "v1/mall/goods/mark"
    case goodsCancelMark = "v1/mall/goods/unmark"
    case goodsMarkList = "v1/mall/goods/markList"
    
    case searchHotWords = "v1/mall/goods/hotWords"
    case goodsSearch = "v1/mall/goods/searchGoods"

    var apiString: String { rawValue }
}

