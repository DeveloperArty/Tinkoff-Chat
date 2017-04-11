//
//  ConversationsListViewController.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 24.03.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConversationsListViewController: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Properties 
    let communicationManager: CommunicatorDelegate = CommunicationManager()
    // Имитация полученных данных
//    var onlineConvers: [(name: String, date: Date?, message: String?, online: Bool, hasUnreadMessages: Bool)] = [("Sam", Date(), "Hi!", true, true),
//                                                                                                                 ("Sam", Date(), "Hi!", true, false),
//                                                                                                                 ("Sam", Date(timeIntervalSinceNow: TimeInterval(arc4random_uniform(100000000))), "Hi!", true, true),
//                                                                                                                 ("Sam", Date(timeIntervalSinceNow: TimeInterval(arc4random_uniform(100000))), "Hi!", true, false),
//                                                                                                                 ("Sam", Date(timeIntervalSinceNow: TimeInterval(arc4random_uniform(10000000))), nil, true, true),
//                                                                                                                 ("Sam", Date(timeIntervalSinceNow: TimeInterval(arc4random_uniform(1000000))), nil, true, false),
//                                                                                                                 ("Sam", Date(), nil, true, true),
//                                                                                                                 ("Sam", Date(), nil, true, false)]
//                                                                                                                 
//                                                                                                                 
//                                                                                                                 
//    var offlineConvers: [(name: String, date: Date?, message: String?, online: Bool, hasUnreadMessages: Bool)] = [("Sam", Date(), "Hi!", false, true),
//                                                                                                                  ("Sam", Date(), "Hi!", false, false),
//                                                                                                                  ("Sam", Date(timeIntervalSince1970: TimeInterval(arc4random_uniform(10000000))), "Hi!", false, true),
//                                                                                                                  ("Sam", Date(timeIntervalSince1970: TimeInterval(arc4random_uniform(1000000000))), "Hi!", false, false),
//                                                                                                                  ("Sam", Date(timeIntervalSince1970: TimeInterval(arc4random_uniform(1000000000))), nil, false, true),
//                                                                                                                  ("Sam", Date(timeIntervalSince1970: TimeInterval(arc4random_uniform(100000000))), nil, false, false),
//                                                                                                                  ("Sam", Date(), nil, false, true),
//                                                                                                                  ("Sam", Date(), nil, false, false)]
    
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
        
        communicationManager.vc = self 
        communicationManager.start()
        
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
            vc.navigationItem.title = sender as? String 
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
            self.performSegue(withIdentifier: "toSelectedConversation", sender: name)
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

