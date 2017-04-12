//
//  ConversationsListViewController.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 24.03.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConversationsListViewController: UIViewController, UsersListPresenter {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Properties 
    let communicationManager: CommunicatorDelegate = CommunicationManager()
    
    var onlineConvers = [String: ConversationData]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var offlineConvers = [String: ConversationData]()
    
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        communicationManager.usersPresenter = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ConversationTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "conversationCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ConversationViewController {
            let array = sender as? [String]
            vc.navigationItem.title = array?[1]
            vc.userID = array?[0]
            vc.communicationManager = self.communicationManager
        }
    }
}


// MARK: - TV Delegate 
extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        } else {
            return "History"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ConversationTableViewCell {
            let name = cell.name
            var ids = [String]()
            for id in onlineConvers.keys {
                ids.append(id)
            }
            let userId = ids[indexPath.row]
            self.performSegue(withIdentifier: "toSelectedConversation", sender: [userId, name])
        }
    }
}



// MARK: - TV DataSource 
extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return onlineConvers.count
        } else {
            return offlineConvers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationTableViewCell

        var conversationsData = [ConversationData]()
        for value in onlineConvers.values {
            conversationsData.append(value)
        }
        let convData = conversationsData[indexPath.row]
        cell.name = convData.name
        cell.date = convData.date
        cell.message = convData.message
        cell.online = convData.online
        cell.hasUnreadMessages = convData.hasUnreadMessages
        
        return cell
    }
}

