//
//  OperationDataManager.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 31.03.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation
import UIKit 

class OperationDataManager: ProfileDataManager {
    
    // Properties 
    lazy var savingQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Saving queue"
        return queue
    }()
    
    lazy var gettingQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Getting queue"
        return queue
    }()
    
    // Meths
    func saveData(data: ProfileData, completionHandler: @escaping (_ success: Bool) -> Void ) {
        print("Operation")
        let operation = SaveOperation(data: data, completion: completionHandler)
        savingQueue.addOperation(operation)
    }
    
    func getData(completionHandler: @escaping (_ data: ProfileData) -> Void ) {
        
        let operation = GetOperation(completion: completionHandler)
        savingQueue.addOperation(operation)
    }
}
