//
//  VideoModel.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/22/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

//MARK: MODEL TO YOUTUBE API
struct VideoParser: Codable {
    let kind: String
    let etag: String
    let regionCode: String
    let items: [Item]?
}

struct Item: Codable {
    let id: Id
    let snippet: Video
}

struct Id: Codable {
    let kind: String
    let videoId: String
}

struct Video: Codable {
    let publishedAt: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: Thumbnails
    let channelTitle: String
}

struct Thumbnails: Codable {
    let medium: Thumbnail
    let high: Thumbnail
}

struct Thumbnail: Codable {
    let url: String
    let width: Int
    let height: Int
}

//MARK: MODEL TO FIREBASE
import Firebase

private let ID = "key"
private let CHANNEL_ID = "channelId"
private let CHANNEL_TITLE = "channelTitle"
private let DESCRIPTION = "description"
private let PUBLISHED_AT = "publishedAt"
private let THUMBNAIL_MEDIUM = "thumbnailMedium"
private let THUMBNAIL_HIGH = "thumbnailHigh"
private let TITLE = "title"

class VideoModel {
    
    internal var id: String?
    internal var channelId: String?
    internal var channelTitle: String?
    internal var description: String?
    internal var publishedAt: String?
    internal var thumbnailMedium: String?
    internal var thumbnailHigh: String?
    internal var title: String?
    
    init?(document: QueryDocumentSnapshot) {
        mapping(document: document)
    }
    
    init?(videoParser: Item) {
        mappingWithParser(video: videoParser)
    }
    
    func mapping(document: QueryDocumentSnapshot) {
        
        self.id = document.documentID
        let data = document.data()
        
        self.channelId = data[CHANNEL_ID] as? String
        self.channelTitle = data[CHANNEL_TITLE] as? String
        self.description = data[DESCRIPTION] as? String
        self.publishedAt = data[PUBLISHED_AT] as? String
        self.thumbnailMedium = data[THUMBNAIL_MEDIUM] as? String
        self.thumbnailHigh = data[THUMBNAIL_HIGH] as? String
        self.title = data[TITLE] as? String
        
    }
    
    func mappingWithParser(video: Item) {
        
        self.id = video.id.videoId
        self.channelId = video.snippet.channelId
        self.channelTitle = video.snippet.channelTitle
        self.description = video.snippet.description
        self.publishedAt = video.snippet.publishedAt
        self.thumbnailMedium = video.snippet.thumbnails.medium.url
        self.thumbnailHigh = video.snippet.thumbnails.high.url
        self.title = video.snippet.title
    }

}
