//
//  NFTModel.swift
//  CodeLabApp
//
//  Created by Sera on 2023/9/14.
//

import Foundation
import BasicUIKit

class NFTSeriesItem: Codable, IdentifierElement {
    var id: String = ""
    var desc: String?
    var points: Int?
    var seriesInfo: NFTSeriesInfo?
    var nftList: [NFTInfo]?
    
    var uniqueIdentifier: String { id }
    
    enum CodingKeys: String, CodingKey {
        case id = "seriesId"
        case desc
        case points
        case seriesInfo = "series"
        case nftList = "goods"
    }
}

class NFTSeriesInfo: Codable, IdentifierElement {
    var id: String = ""
    var name: String?
    var points: Int?
    var cover: NFTInfo.MediaCover?
    var history: String?
    
    var uniqueIdentifier: String { id }
    
    enum CodingKeys: String, CodingKey {
        case id = "seriesId"
        case name = "seriesName"
        case cover
        case points
        case history
    }
}

class NFTInfo: Codable, IdentifierElement {
    var id: String = ""
    var name: String = ""
    var cover: MediaCover?
    var classificationType: String?
    var classificationTypeName: String?
    var series: String?
    var seriesName: String?
    var story: String?
    var isMark: Bool?
    var minSalePrice: Int?
    var minDealPrice: Int?
    var pointsRase: Double?
    
    var uniqueIdentifier: String { id }
    
    struct MediaCover: Codable {
        var guid: String = ""
        var wt: Double?
        var ht: Double?
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "goodsId"
        case name = "goodsName"
        case cover
        case classificationType
        case classificationTypeName
        case series
        case seriesName
        case story
        case isMark = "mark"
        case minSalePrice = "minCommissionSellPoints"
        case minDealPrice = "minDealPoints"
        case pointsRase
    }
}

class UserNFTItem: Codable, IdentifierElement {
    var userGoodsId: String = ""
    var uid: String = ""
    var nftId: String?
    var goodsNum: String?
    var info: NFTInfo?
    var status: String?
    var saleId: String?
    
    var isOnSale: Bool {
        return status == "commission"
    }
    
    var uniqueIdentifier: String { userGoodsId }
    
    enum CodingKeys: String, CodingKey {
        case userGoodsId
        case uid
        case nftId = "goodsId"
        case goodsNum = "goodsNo"
        case info = "goods"
        case status
        case saleId = "commissionId"
    }
}

class NFTSaleItem: Codable, IdentifierElement {
    var id: String = ""
    var user: UserInfo?
    var nftInfo: NFTInfo?
    var points: Int?
    var status: Int?
    var goodsNum: String?
    
    var uniqueIdentifier: String { id }
    
    enum CodingKeys: String, CodingKey {
        case id = "commissionId"
        case user = "userInfo"
        case nftInfo = "goods"
        case points
        case status
        case goodsNum = "goodsNo"
    }
}
