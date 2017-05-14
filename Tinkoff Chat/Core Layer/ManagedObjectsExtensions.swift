//
//  ManagedObjectsExtensions.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 01.05.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation
import CoreData


// MARK: - CDMessage 
extension CDMessage {
    
    
}

// MARK: - Conversation
extension Conversation {
    
    static func getConversationRequest(id: String, model: NSManagedObjectModel) -> NSFetchRequest<Conversation>? {
        
        let templateName = "ConversationWithId"
        guard let request = model.fetchRequestFromTemplate(withName: templateName,
                                                           substitutionVariables: ["id": id]) as? NSFetchRequest<Conversation> else {
            print("request unavailable")
            return nil
        }
        return request
    }
    
    static func getConversation(with id: String, context: NSManagedObjectContext) -> Conversation? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("model is unavailable in this cotext!")
            assert(false)
            return nil
        }
        
        guard let request = Conversation.getConversationRequest(id: id, model: model) else {
            return nil
        }
        
        var conversation: Conversation?
        do {
            let conversations = try context.fetch(request)
            assert(conversations.count<2, "multiple conversations with same id?!")
            if let conversationFirst = conversations.first {
                print("conversation found")
                conversation = conversationFirst
            }
        } catch {
            print(error.localizedDescription)
        }
        return conversation
    }
    
    static func insertConversation(with id: String, into context: NSManagedObjectContext) -> Conversation? {
        if let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation {
            conversation.conversationId = id
            return conversation
        }
        return nil
    }
}


// MARK: - AppUser
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

// MARK: User 

extension User {
    
    static func fetchRequestUser(model: NSManagedObjectModel, id: String) -> NSFetchRequest<User>? {
        let templateName = "UserWithId"
        guard let fr = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["id": id]) as? NSFetchRequest<User> else {
            print("request unavailable")
            return nil
        }
        return fr
    }
    
    static func insertUser(for id: String, userName: String, into context: NSManagedObjectContext) -> User? {
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            user.userId = id
            user.nickname = userName
            return user
        }
        print("failed inserting user: userName: \(userName)")
        return nil
    }
    
    static func getUser(with id: String, userName: String, context: NSManagedObjectContext) -> User? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("model is unavailable in this cotext!")
            assert(false)
            return nil
        }
        
        guard let request = User.fetchRequestUser(model: model, id: id) else {
            return nil
        }
        
        var user: User?
        do {
            let results = try context.fetch(request)
            assert(results.count<2, "multiple users with same id found!")
            if let u = results.first {
                user = u
            }
        } catch {
            print(error.localizedDescription)
        }
        if user == nil {
            user = User.insertUser(for: id, userName: userName, into: context)
        }
        return user 
    }
}

