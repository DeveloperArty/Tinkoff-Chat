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
    private let dataOperator = ProfileDataOperator()
    
    // Meths 
    func saveData(data: ProfileData, completionHandler: @escaping (_ success: Bool) -> Void ) {
        
        print("GCD")
        DispatchQueue.global(qos: .userInitiated).async {
            self.dataOperator.save(data: data) { success in
                
                DispatchQueue.main.sync {
                    completionHandler(success)
                }
            }
        }
    }
    
    func getData(completionHandler: @escaping (_ data: ProfileData) -> Void ) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.dataOperator.get() { data in
                
                DispatchQueue.main.sync {
                    completionHandler(data)
                }
            }
        }
    }
}
