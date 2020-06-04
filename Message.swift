//
//  MessageViewController.swift
//  Chatter
//
//  Created by kotik on 06.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

struct Message {
    let message: String
    let senderUsername: String
    let messageSender: MessageSender
    
    
    init(message: String, messageSender: MessageSender, username: String) {
        self.message = message.withoutWhitespace()
        self.messageSender = messageSender
        self.senderUsername = username
    }
}

extension String {
    func withoutWhitespace() -> String {
    return self.replacingOccurrences(of: "\n", with: "")
    }
}

