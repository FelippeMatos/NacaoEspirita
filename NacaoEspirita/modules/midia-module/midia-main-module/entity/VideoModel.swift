//
//  VideoModel.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/22/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

struct VideoModel: Codable {
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
