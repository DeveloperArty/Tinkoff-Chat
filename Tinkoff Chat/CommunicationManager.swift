//
//  CommunicationManager.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 10.04.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation

class CommunicationManager: CommunicatorDelegate {
    
    // Properties 
    private var _communicator: Communicator?
    private var communicator: Communicator? {
        get {
            if _communicator == nil {
                _communicator = MultipeerCommunicator()
                _communicator?.delegate = self
            }
            return _communicator
        } set {
            
        }
    }
    
    var usersPresenter: UsersListPresenter?
    var messagesPresenter: MessagesListPresenter? 
    
    init() {
        communicator?.online = true
    }
    
    // discovering
    func didFoundUser(userID: String, userName: String) {
        let data = ConversationData()
        data.online = true
        data.name = userName
        usersPresenter?.onlineConvers[userID] = data
    }
    func didLostUser(userID: String) {
        usersPresenter?.onlineConvers[userID] = nil
    }
    
    // errors
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    func failedToStartAdvertising(error: Error) {
        
    }
    
    // messages
    
    func sendMessage(text: String, toUser: String, completion: ((Bool, Error?) -> Void)?) {
        communicator?.sendMessage(string: text, to: toUser, completionHandler: completion)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if let userData = usersPresenter?.onlineConvers[fromUser] {
            userData.date = Date()
            userData.message = text
            userData.hasUnreadMessages = true
            usersPresenter?.onlineConvers[fromUser] = userData
            
            if let msg = self.messagesPresenter {
                if msg.userID == fromUser {
                    msg.messages.append(Message(mCase: .incoming, text: text))
                }
            }
        }
    }
}
