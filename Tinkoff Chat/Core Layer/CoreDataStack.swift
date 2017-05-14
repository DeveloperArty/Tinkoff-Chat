//
//  CoreDataStack.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 25.04.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataStack {
    
    // Singleton 
    static let sharedInstance = CoreDataStack()
    
    private init() { }
    
    // MARK: - Properties
    // storage path
    private var storeURL: URL {
        get {
            let docsURL = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask).first!
            let url = docsURL.appendingPathComponent("Store.sqlite")
            return url
        }
    }
    
    // Model
    private let managedObjectModelName = "Storage"
    private var _managedObjectModel: NSManagedObjectModel?
    private var managedObjectModel: NSManagedObjectModel? {
        get {
            if _managedObjectModel == nil {
                guard let modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension: "momd") else {
                    print("Empty model url")
                    return nil
                }
                _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
            }
            return _managedObjectModel
        }
    }
    
    // Coordinator
    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        get {
            if _persistentStoreCoordinator == nil {
                guard let model = self.managedObjectModel else {
                    print("no mo model")
                    return nil
                }
                
                _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                do {
                    try _persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType,
                                                                        configurationName: nil,
                                                                        at: storeURL,
                                                                        options: nil)
                } catch {
                    assert(false, "Error adding persistent store coordinator: \(error.localizedDescription)")
                }
            }
            return _persistentStoreCoordinator
        }
    }
    
    // Master Co
    private var _masterContext: NSManagedObjectContext?
    private var masterContext: NSManagedObjectContext? {
        get {
            if _masterContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                guard let persistentStoreCoordinator = self.persistentStoreCoordinator else {
                    print("Empty persistent store coordinator")
                    return nil
                }
                
                context.persistentStoreCoordinator = persistentStoreCoordinator
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _masterContext = context
            }
            return _masterContext
        }
    }
    
    // Main Co
    private var _mainContext: NSManagedObjectContext?
    private var mainContext: NSManagedObjectContext? {
        get {
            if _mainContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                guard let parentContext = self.masterContext else {
                    print("no master context")
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _mainContext = context
            }
            return _mainContext
        }
    }
    
    // Save Co
    private var _saveContext: NSManagedObjectContext?
    private var saveContext: NSManagedObjectContext! {
        get {
            if _saveContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                guard let parentContext = self.mainContext else {
                    print("no main context")
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _saveContext = context
            }
            return _saveContext
        }
    }
    
    
    
    
    
    // MARK: - Open Meths
    
    // Profile Data
    func getCurruntUserData() -> ProfileData? {
        
        let profileData = ProfileData()
        
        if let appUser = getAppUser(in: saveContext!) {
            guard let currentUser = appUser.currentUser else {
                print("no current user! ")
                return nil
            }
            if let avatarData = currentUser.avatar {
                if let avatar = UIImage(data: avatarData as Data) {
                    profileData.avatar = avatar
                }
            }
            profileData.info = currentUser.info
            profileData.nickname = currentUser.nickname
        }
        
        return profileData
    }
    
    func saveCurrentUserData(profileData: ProfileData) ->  Bool  {
        
        guard let appUser = getAppUser(in: saveContext!) else {
            print("unable to get appUser")
            return false
        }
        if let avatar = profileData.avatar {
            let binAvatar = UIImageJPEGRepresentation(avatar, 1) as NSData?
            appUser.currentUser?.avatar = binAvatar
        }
        if let nickname = profileData.nickname {
            appUser.currentUser?.nickname = nickname
        }
        if let info = profileData.info {
            appUser.currentUser?.info = info
        }
        performSave(context: saveContext, completionHandler: nil)
        return true 
    }
    
    // Users
    func getUser(with id: String, userName: String) -> User? {
        let user = User.getUser(with: id, userName: userName, context: saveContext)
        self.performSave(context: saveContext, completionHandler: nil) 
        return user
    }
    
    
    
    
    
    // Conversations
//    func saveConversation(with id: String) {
//        
//        if Conversation.getConversation(with: id, context: saveContext) == nil {
//            Conversation.insertConversation(with: id, into: saveContext)
//            performSave(context: saveContext, completionHandler: nil)
//        }
//    }
//    
    
    
    
    
    // MARK: - Private Meths
    
    private func getAppUser(in context: NSManagedObjectContext) -> AppUser? {
        if let appUser = AppUser.findOrInsertAppUser(in: context) {
            performSave(context: context, completionHandler: nil)
            return appUser
        } 
        return nil
    }
    
    
    private func performSave(context: NSManagedObjectContext, completionHandler: (() -> Void)? ) {
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                } catch {
                    print("context save error: \(error.localizedDescription)")
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                } else {
                    completionHandler?()
                }
            }
        } else {
            completionHandler?()
        }
    }
}



