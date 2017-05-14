//
//  ConversationDataProvider.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 14.05.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ConversationDataProvider: NSObject {
    let fetchedResultsController: NSFetchedResultsController<CDMessage>
    let tableView: UITableView
    init(tableView: UITableView) {
        
        self.tableView = tableView
        let context =
            NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let fetchRequest = NSFetchRequest<CDMessage>(entityName: "Message")
        fetchedResultsController = NSFetchedResultsController<CDMessage>(fetchRequest: fetchRequest,
                                                                         managedObjectContext: context,
                                                                         sectionNameKeyPath: nil,
                                                                         cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
    }
}
extension ConversationDataProvider: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<CDMessage>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<CDMessage>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: IndexPath?,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections(IndexSet(integer: (sectionIndex?.section)!),
                                     with: .automatic)
        case .insert:
            tableView.insertSections(IndexSet(integer: (sectionIndex?.section)!),
                                     with: .automatic)
        case .move, .update: break
        }
    }
}
