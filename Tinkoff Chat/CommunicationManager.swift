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
    lazy var communicator: Communicator = MultipeerCommunicator(delegate: self)
    
    // discovering
    func didFoundUser(userID: String, userName: String) {
        
    }
    func didLostUser(userID: String) {
        
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
