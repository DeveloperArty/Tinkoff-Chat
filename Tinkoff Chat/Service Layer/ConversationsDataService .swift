//
//  ConversationsDataService .swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 11.05.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation

protocol ConversationsDataService {
    
    func conversationForUser(with id: String, name: String) -> Conversation?
}
