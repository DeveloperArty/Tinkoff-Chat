//
//  CommunicatorDelegate.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 10.04.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation
import UIKit

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
    func sendMessage(text: String, toUser: String, completion: ((_ success: Bool, _ error: Error?) -> Void)?)
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}
