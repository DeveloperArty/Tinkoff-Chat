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
    
    @IBOutlet weak var gcdButton: UIButton!
    @IBOutlet weak var operationButton: UIButton!
    
    @IBOutlet weak var elementsHeight: NSLayoutConstraint!
    
// MARK: - Properies
    let imagePicker = UIImagePickerController()
//    let gcdDataManager = GCDDataManager()
//    let operationDataManager = OperationDataManager()
    
    // Эх, сюда бы фабрику с DI..
    var dataManager: ProfileDataManager?
    
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
        
        if dataManager == nil {
            dataManager = GCDDataManager()
        }
        
        dataManager!.getData() { dataCortege in
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
                                                self.saveGCD(self.gcdButton)
                                                return
            })
            alertContr.addAction(actionOK)
            alertContr.addAction(actionRepeat)
            self.present(alertContr, animated: true, completion: nil)
        }
    }
    
    func checkDataToSave() -> ProfileData? {
        
        let profileData = ProfileData()
        
        guard (nameField.text != nicknameAL) || (infoTextView.text != infoAL) || userImage.image != avatarAL || textColorLabel.textColor != textColorAL else {
            return nil
        }
        
        gcdButton.isEnabled = false
        operationButton.isEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
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
        
        profileData.nickname = nickname
        profileData.info = info
        profileData.avatar = avatar
        profileData.textColor = color
        
        return profileData
    }
    
    func savingCompleted(_ success: Bool) {
        
        self.gcdButton.isEnabled = true
        self.operationButton.isEnabled = true
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        if success {
            self.presentAlert(forCase: "Success")
        } else {
            self.presentAlert(forCase: "Fail")
        }
    }
    
// MARK: - UI Events
    // Saving Meths
    @IBAction func saveGCD(_ sender: UIButton) {
        
        guard let data = checkDataToSave() else {
            return
        }
        if dataManager is OperationDataManager || dataManager == nil  {
            self.dataManager = GCDDataManager()
        }
        dataManager!.saveData(data: data, completionHandler: savingCompleted(_:))
    }
    
    @IBAction func saveOperation(_ sender: UIButton) {
        
        guard let data = checkDataToSave() else {
            return
        }
        if dataManager is GCDDataManager || dataManager == nil  {
            self.dataManager = OperationDataManager()
        }
        dataManager!.saveData(data: data, completionHandler: savingCompleted(_:))
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
