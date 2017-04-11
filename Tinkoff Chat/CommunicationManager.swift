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
    lazy var communicator: Communicator = MultipeerCommunicator()
    var vc: ConversationsListViewController? = nil
    
    func start() {
        communicator.delegate = self 
        communicator.start() 
    }
    
    // discovering
    func didFoundUser(userID: String, userName: String) {
        let data = ConversationData()
        data.online = true
        data.name = userName
        data.date = Date()
        vc?.onlineConvers[userID] = data 
    }
    func didLostUser(userID: String) {
        vc?.onlineConvers[userID] = nil
    }
    
    // errors
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    func failedToStartAdvertising(error: Error) {
        
    }
    
    // messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        
    }
}
