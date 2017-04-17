//
//  MessagesPresenter.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 13.04.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation

protocol MessagesListPresenter: class {
    
    var messages: [Message] {get set}
    var userID: String? {get set}
    
}
