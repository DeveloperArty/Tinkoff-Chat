//
//  Communicator.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 10.04.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation

protocol Communicator {
    
    func sendMessage(string: String,
                     to userID: String,
                     completionHandler: ((_ success: Bool, _ error: Error?) -> Void)? )
    weak var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}
}
