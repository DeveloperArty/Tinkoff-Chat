//
//  Messages.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 12.04.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation


enum MessageCase {
    case outcoming, incoming
}

class Message {
    
    let mCase: MessageCase
    let text: String
    
    init(mCase: MessageCase, text: String) {
        self.mCase = mCase
        self.text = text
    }
}
