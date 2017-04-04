//
//  SaveOperation.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 04.04.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation
import UIKit

class SaveOperation: Operation {
    
    // Properties
    let dataOperator = ProfileDataOperator()
    let data: ProfileData
    let completion: (_ success: Bool) -> Void
    
    // Inits
    init(data: ProfileData, completion: @escaping (_ success: Bool) -> Void ) {
        self.data = data
        self.completion = completion
    }
    
    // Meths
    override func main() {
        
        guard !self.isCancelled else {
            return
        }
        
        dataOperator.save(data: data) { success in
            
            DispatchQueue.main.sync {
                completion(success)
            }
        }
    }
}
