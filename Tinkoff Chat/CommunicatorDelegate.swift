//
//  CommunicatorDelegate.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 10.04.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation
import UIKit


// сообщение communicator и communicationManager

protocol CommunicatorDelegate: class {
    
    var usersPresenter: UsersListPresenter? {get set}
    var messagesPresenter: MessagesListPresenter? {get set}
    
    // discovering
    func didFoundUser(userID: String, userName: String)
    func didLostUser(userID: String)
    
    // errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    // messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}


// сообщение listVC и manager

protocol UsersListPresenter: class {
    
    var onlineConvers: [String: ConversationData] {get set}
}


// сообщение conVC и manager 

protocol MessagesListPresenter: class {
    
    var messages: [Message] {get set}
}
