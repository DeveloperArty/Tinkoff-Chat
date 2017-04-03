//
//  GCDDataManager.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 31.03.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import Foundation
import UIKit

class GCDDataManager: ProfileDataManager {
    
    // Properties 
    private let fileManager = FileManager.default
    
    // Open Meths
    func saveData(data: (nickname: String?, info: String?, avatar: UIImage?, textColor: UIColor?), completionHandler: (_ success: Bool) -> Void ) {
        if let nickname = data.nickname {
            self.saveNickname(string: nickname)
        }
        if let avatar = data.avatar {
            self.saveAvatar(image: avatar)
        }
        if let info = data.info {
            self.saveInfo(string: info)
        }
        if let color = data.textColor {
            self.saveColor(color: color)
        }
        completionHandler(true)
    }
    
    func getData(completionHandler: (_ data: (nickname: String?, info: String?, avatar: UIImage?, textColor: UIColor?)) -> Void ) {
        // Getting nickname
        let nickPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true)[0] + "nickname.txt"
        var nickname: String?
        do {
            try nickname = String(contentsOfFile: nickPath)
        } catch {
            nickname = nil
        }
        
        // Getting info 
        let infoPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true)[0] + "info.txt"
        var info: String?
        do {
            try info = String(contentsOfFile: infoPath)
        } catch {
            info = nil
        }
        
        // Getting avatar
        let imagePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true)[0] + "avatar.jpg"
        let avatar: UIImage? = UIImage(contentsOfFile: imagePath)
        
        // Getting color 
        let colorPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true)[0] + "color.txt"
        var color: UIColor?
        var colorString: String?
        do {
            try colorString = String(contentsOfFile: colorPath)
        } catch {
            color = nil
        }
        if let colorful = colorString?.components(separatedBy: " ") {
            if colorful.count > 3 {
                color = UIColor(colorLiteralRed: colorful[0].floatValue,
                                green: colorful[1].floatValue,
                                blue: colorful[2].floatValue,
                                alpha: colorful[3].floatValue)
            }
        }
        
        completionHandler((nickname, info, avatar, color))
    }
    
    // MARK: - Private Meths 
    private func saveNickname(string: String) {
        print(#function)
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true)[0] + "nickname.txt"
        fileManager.createFile(atPath: path,
                               contents: string.data(using: .utf8),
                               attributes: nil)
    }
    
    private func saveInfo(string: String) {
        print(#function)
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true)[0] + "info.txt"
        fileManager.createFile(atPath: path,
                               contents: string.data(using: .utf8),
                               attributes: nil)
    }
    
    private func saveAvatar(image: UIImage) {
        print(#function)
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true)[0] + "avatar.jpg"
        fileManager.createFile(atPath: path,
                               contents: UIImageJPEGRepresentation(image, 1),
                               attributes: nil)
    }
    
    private func saveColor(color: UIColor) {
        print(#function)
        
        if let comps = color.cgColor.components {
            let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true)[0] + "color.txt"
            var colorfulString = ""
            if comps.count > 3 {
                colorfulString = "\(comps[0]) " + "\(comps[1]) " + "\(comps[2]) " + "\(comps[3])"
            }
            print(colorfulString)
            fileManager.createFile(atPath: path,
                                   contents: colorfulString.data(using: .utf8),
                                   attributes: nil)
        }
    }
    
}
