//
//  GCDDataManager.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 31.03.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation
import UIKit

class GCDDataManager: ProfileDataManager {
    
    // Properties 
    private let dataOperator = CoreDataStack()
    
    // Meths 
    func saveData(data: ProfileData, completionHandler: @escaping (_ success: Bool) -> Void ) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let success = self.dataOperator.saveCurrentUserData(profileData: data)
            DispatchQueue.main.sync {
                completionHandler(success)
            }
            return
        }
    }
    
    func getData(completionHandler: @escaping (_ data: ProfileData) -> Void ) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            if let data = self.dataOperator.getCurruntUserData() {
                DispatchQueue.main.sync {
                    completionHandler(data)
                }
            } else {
                print("Profile data manager did not receive data from core layer")
            }
        }
    }
}
