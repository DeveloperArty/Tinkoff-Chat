//
//  ProfileViewController.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 21.03.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
// MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var binButton: UIButton!
    @IBOutlet weak var camButton: UIButton!
    @IBOutlet weak var libButton: UIButton!
    
    @IBOutlet weak var textColorLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var elementsHeight: NSLayoutConstraint!
    
// MARK: - Properies
    let imagePicker = UIImagePickerController()
    let gcdDataManager = GCDDataManager()
    
    // AL - After Load
    var nicknameAL: String?
    var infoAL: String?
    var avatarAL: UIImage?
    var textColorAL: UIColor?
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.view.frame.height < 500 {
            self.elementsHeight.constant = 19
        }
        loadData()
        imagePicker.delegate = self
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - Meths
    func loadData() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        gcdDataManager.getData() { dataCortege in
            DispatchQueue.main.async {
                
                self.nicknameAL = dataCortege.nickname
                self.infoAL = dataCortege.info
                self.avatarAL = dataCortege.avatar
                self.textColorAL = dataCortege.textColor
                
                if let nick = dataCortege.nickname {
                    self.nameField.text = nick
                }
                if let info = dataCortege.info {
                    self.infoTextView.text = info
                }
                if let ava = dataCortege.avatar {
                    self.userImage.contentMode = .scaleAspectFit
                    self.userImage.image = ava
                }
                if let color = dataCortege.textColor {
                    self.textColorLabel.textColor = color
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true 
                return 
            }
        }
    }
    
    func presentAlert(forCase: String) {
        if forCase == "Success" {
            let alertContr = UIAlertController(title: "Данные сохранены",
                                               message: nil,
                                               preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            alertContr.addAction(actionOK)
            self.present(alertContr, animated: true, completion: nil)
        } else {
            let alertContr = UIAlertController(title: "Ошибка",
                                               message: "Не удалось сохранить данные",
                                               preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            let actionRepeat = UIAlertAction(title: "Повторить",
                                             style: .default,
                                             handler: { action in
                                                // re- saving data
                                                return
            })
            alertContr.addAction(actionOK)
            alertContr.addAction(actionRepeat)
            self.present(alertContr, animated: true, completion: nil)
        }
    }
    
// MARK: - UI Events
    // Saving Meths
    @IBAction func saveGCD(_ sender: UIButton) {
        
        var nickname: String? = nil
        if (nameField.text != "") && (nameField.text != nicknameAL) {
            nickname = nameField.text
            nicknameAL = nickname
        }
        var info: String? = nil
        if (infoTextView.text != "") && (infoTextView.text != infoAL) {
            info = infoTextView.text
            infoAL = info
        }
        var avatar: UIImage? = nil
        if userImage.image != avatarAL {
            avatar = userImage.image
            avatarAL = avatar
        }
        var color: UIColor? = nil
        if textColorLabel.textColor != textColorAL {
            color = textColorLabel.textColor
            textColorAL = color
        }
        
        gcdDataManager.saveData(data: (nickname, info, avatar, color)) { success in
            DispatchQueue.main.async {
                if success {
                    self.presentAlert(forCase: "Success")
                } else {
                    self.presentAlert(forCase: "Fail")
                }
            }
        }
    }
    
    @IBAction func saveOperation(_ sender: UIButton) {
        
    }
    
    // Data Setup
    @IBAction func changeTextColor(_ sender: UIButton) {
        self.textColorLabel.textColor = sender.backgroundColor
    }

    @IBAction func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func chooseFromLib(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func deleteImage(_ sender: UIButton) {
        self.userImage.image = #imageLiteral(resourceName: "ProfilePlaceholder")
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - TextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false 
    }
}


// MARK: - ImagePickerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.userImage.contentMode = .scaleAspectFit
            self.userImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
