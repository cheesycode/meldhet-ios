//
//  Message.swift
//  meldhet
//
//  Created by Michel Megens on 19/10/2018.
//  Copyright © 2018 cheesycode.com. All rights reserved.
//

import Foundation

class Message : Decodable {
    var issue : String? = nil
    var sender : String? = nil
    var body : String? = nil
    var recipient : String? = nil
}
