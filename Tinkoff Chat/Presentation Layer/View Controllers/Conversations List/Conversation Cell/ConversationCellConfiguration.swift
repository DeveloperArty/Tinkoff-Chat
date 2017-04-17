//
//  ConversationCellConfiguration.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 24.03.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation

protocol ConversationCellConfiguration {
    
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessages: Bool {get set}
}

class ConversationData {
    
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool = false
    var hasUnreadMessages: Bool = false 
}
