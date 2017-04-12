//
//  UsersListPresenter.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 13.04.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation

protocol UsersListPresenter: class {
    
    var onlineConvers: [String: ConversationData] {get set}
}
