//
//  GetOperation.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 04.04.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation
import UIKit

class GetOperation: Operation {
    
    // Properties 
    let dataOperator = ProfileDataOperator()
    let completion: (_ data: ProfileData) -> Void
    
    // Inits 
    init(completion: @escaping (_ data: ProfileData) -> Void) {
        
        self.completion = completion
    }
    
    override func main() {
        
        guard !self.isCancelled else {
            return 
        }
    
        dataOperator.get() { data in 
            DispatchQueue.main.sync {
                completion(data)
            }
        }
    }
}
