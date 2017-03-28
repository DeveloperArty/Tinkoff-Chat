//
//  ProfileViewController.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 21.03.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // Outlets
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
    
    @IBOutlet weak var elementsHeight: NSLayoutConstraint!
    
    // Properies
    let imagePicker = UIImagePickerController()
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.view.frame.height < 500 {
            self.elementsHeight.constant = 19
        }
        
        print(#function)
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(#function)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print(#function)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Meths 
    func presentAlert(msg: String) {
        let alert = UIAlertController(title: "Oooops!",
                                      message: msg + " Please, go to settings and allow access",
                                      preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok..",
                                     style: .default,
                                     handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    // UI Events 
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        print("Сохранение данных профиля")
    }
    
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
