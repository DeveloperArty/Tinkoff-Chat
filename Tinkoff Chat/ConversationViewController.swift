//
//  ConversationViewController.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 26.03.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Properties
    let data = ["Lorem",
                "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."]
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - TV Delegate
extension ConversationViewController: UITableViewDelegate {
    
}


// MARK: - TV DataSource
extension ConversationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MessageTableViewCell?
        if (indexPath.row % 2) == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "incoming", for: indexPath) as? MessageTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "outcoming", for: indexPath) as? MessageTableViewCell
        }
        cell?.textt = data[indexPath.row % 3]
        cell?.ident.constant = self.view.frame.width*0.25
        return cell!
    }
}



