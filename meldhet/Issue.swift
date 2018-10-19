//
//  issue.swift
//  MeldHet
//
//  Created by Michel Megens on 17/10/2018.
//  Copyright 2018 cheesycode.com. All rights reserved.
//

import Foundation

struct Issue : Decodable {
    let acc: Float
    let creator: String
    let image: String
    let lat: Float
    let lon: Float
    let tag: String
    let id: String
    var status: String?
    var messages: [Message]?
}
