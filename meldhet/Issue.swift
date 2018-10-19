//
//  issue.swift
//  MeldHet
//
//  Created by Michel Megens on 17/10/2018.
//  Copyright 2018 cheesycode.com. All rights reserved.
//

import Foundation

class Issue : Decodable {
    init(acc : Float, creator : String, image :String, lat: Float, lon: Float, tag: String, id: String, status: String?) {
        self.acc = acc
        self.creator = creator
        self.image = image
        self.lat = lat
        self.lon = lon
        self.tag = tag
        self.id = id
        self.status = status
    }
    init(acc : Float, creator : String, image :String, lat: Float, lon: Float, tag: String, id: String, status: String?, messages: [Message]?) {
        self.acc = acc
        self.creator = creator
        self.image = image
        self.lat = lat
        self.lon = lon
        self.tag = tag
        self.id = id
        self.status = status
        self.messages = messages
    }
    var acc: Float
    var creator: String
    var image: String
    var lat: Float
    var lon: Float
    var tag: String
    var id: String
    var status: String?
    var messages: [Message]?
}
