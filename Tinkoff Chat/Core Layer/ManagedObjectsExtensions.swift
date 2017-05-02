//
//  ManagedObjectsExtensions.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 01.05.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation
import CoreData

extension AppUser {
    
    static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        
        let templateName = "AppUser"
        guard let request = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            print("request unavailable")
            return nil
        }
        return request
    }
    
    static func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("model is unavailable in this cotext!")
            assert(false)
            return nil
        }
        
        var appUser: AppUser?
        guard let fetchResult = AppUser.fetchRequestAppUser(model: model) else {
            
            return nil
        }
        
        do {
            let results = try context.fetch(fetchResult)
            assert(results.count<2, "multiple appUsersFound!")
            if let userFound = results.first {
                appUser = userFound
                print("user found")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
        }
        
        return appUser
    }
    
    static func insertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        if let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser {
            if appUser.currentUser == nil {
                if let currentUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
                    print("new currentUser")
                    appUser.currentUser = currentUser
                    print("appUser with new current user inserted ")
                }
            } 
            return appUser
        }
        
        return nil
    }
}

