//
//  ProfileDataManager.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 31.03.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileDataManager {
    
    func saveData(data: ProfileData, completionHandler: @escaping (_ success: Bool) -> Void )
    
    func getData(completionHandler: @escaping (_ data: ProfileData) -> Void )
}
