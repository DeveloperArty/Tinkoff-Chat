//
//  ConversationTableViewCell.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 24.03.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell, ConversationCellConfiguration {

    // Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    // Properties
    var name: String? {
        willSet {
            nameLabel.text = newValue
        }
    }
    var date: Date? {
        willSet {
            if let date = newValue {
                let calendar = Calendar.current
                
                let componentsMes = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                let currentDate = Date()
                let componentsNow = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate)
                
                if componentsMes.year! < componentsNow.year! {
                    self.showDate(year: componentsMes.year, month: componentsMes.month, day: componentsMes.day, hour: nil, minute: nil)
                } else {
                    if componentsMes.month! < componentsNow.month! {
                        self.showDate(year: nil, month: componentsMes.month, day: componentsMes.day, hour: nil, minute: nil)
                    } else {
                        if componentsNow.day! - componentsMes.day! == 0 {
                            self.showDate(year: nil, month: nil, day: nil, hour: componentsMes.hour, minute: componentsMes.minute)
                        } else {
                            self.showDate(year: nil, month: componentsMes.month, day: componentsMes.day, hour: nil, minute: nil)
                        }
                    }
                }
            }
        }
    }
    var message: String? {
        willSet {
            if newValue == nil {
                messageLabel.font = UIFont(name: "Helvetica Neue", size: 17)
                messageLabel.text = "No messages yet"
            } else {
                messageLabel.text = newValue
            }
        }
    }
    var online: Bool = false {
        willSet {
            if newValue == true {
                self.backgroundColor = #colorLiteral(red: 0.9995459914, green: 0.9886584878, blue: 0.4961454272, alpha: 1)
            } else {
                self.backgroundColor = UIColor.white
            }
        }
    }
    var hasUnreadMessages: Bool = false {
        willSet {
            if newValue == true {
                self.nameLabel.font = UIFont.boldSystemFont(ofSize: 21)
            } else {
                self.nameLabel.font = UIFont.systemFont(ofSize: 21)
            }
        }
    }
    
    // Lifecycle 
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // Meths 
    private func showDate(year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?) {
        if let _year = year {
            var monthStr = "\(month!)."
            if month! < 10 {
                monthStr = "0\(month!)."
            }
            var dayStr = "\(day!)."
            if day! < 10 {
                dayStr = "0\(day!)."
            }
            self.dateLabel.text = dayStr + monthStr + "\(_year)"
        } else if let _month = month {
            var dayStr = "\(day!) "
            if day! < 10 {
                dayStr = "0\(day!) "
            }
            var monthName = ""
            switch _month {
            case 1:
                monthName = "Jan"
            case 2:
                monthName = "Feb"
            case 3:
                monthName = "Mar"
            case 4:
                monthName = "Apr"
            case 5:
                monthName = "May"
            case 6:
                monthName = "Jun"
            case 7:
                monthName = "Jul"
            case 8:
                monthName = "Aug"
            case 9:
                monthName = "Sept"
            case 10:
                monthName = "Oct"
            case 11:
                monthName = "Nov"
            case 12:
                monthName = "Dec"
            default:
                return
            }
            self.dateLabel.text = dayStr + monthName
        } else if let _hour = hour {
            let _minute = minute!
            if _minute < 10 {
                self.dateLabel.text = "\(_hour):0\(_minute)"
            } else {
                self.dateLabel.text = "\(_hour):\(_minute)"
            }
        }
    }
    
}
