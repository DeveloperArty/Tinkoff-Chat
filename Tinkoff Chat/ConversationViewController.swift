//
//  ConversationViewController.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 26.03.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, MessagesListPresenter {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var messageView: UIView!
    
    // Properties
    var communicationManager: CommunicatorDelegate?
    
    var messages = [Message]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        communicationManager?.messagesPresenter = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        messageField.delegate = self 

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UI Events
    @IBAction func sendMessage(_ sender: Any) {
        guard messageField.text != "" && messageField.text != nil else {
            messageField.endEditing(true)
            return
        }
        let message = Message(mCase: .outcoming, text: messageField.text!)
        messages.append(message)
        // send
    }
    
    @IBAction func backTap(_ sender: UITapGestureRecognizer) {
        messageField.endEditing(true)
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
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MessageTableViewCell?
        let message = messages[indexPath.row]
        if message.mCase == .incoming {
             cell = tableView.dequeueReusableCell(withIdentifier: "incoming", for: indexPath) as? MessageTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "outcoming", for: indexPath) as? MessageTableViewCell
        }
        cell?.textt = message.text
        cell?.ident.constant = self.view.frame.width*0.25
        return cell!
    }
}

extension ConversationViewController: UITextFieldDelegate {
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let oldFrame = messageView.frame
            self.messageView.frame = CGRect(x: 0,
                                            y: self.view.frame.height - keyboardHeight - oldFrame.height,
                                            width: oldFrame.width,
                                            height: oldFrame.height)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageField.endEditing(true)
        return true 
    }
}

