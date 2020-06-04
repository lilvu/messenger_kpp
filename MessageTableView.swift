//
//  MessageTable.swift
//  Chatter
//
//  Created by kotik on 06.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

enum MessageSender {
    case yourself
    case someoneElse
}

class MessageTableView: UITableViewCell {
    var messageSender: MessageSender = .yourself
    let colorLabel = Label()
    let messageLabel = Label()
    let nameLabel = UILabel()
    
    //label времени, в которое было отправлено сообщение
    let timeLabel: UILabel = {
        var time = Date()
        var formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" //формат времени часы:минуты
        let formattedDateInString = formatter.string(from: time)
        let timelabel = UILabel()
        
        timelabel.text = formattedDateInString
        timelabel.textAlignment = .right
        timelabel.textColor = .lightGray
        timelabel.font = UIFont(name: "Avenir-Light", size: 13)
        return timelabel
    }()
    
    class Label: UILabel {
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets.init(top: 8, left: 16, bottom: 8, right: 16)
            super.drawText(in: rect.inset(by: insets))
        }
    }
    
    func apply(message: Message) {
        nameLabel.text = message.senderUsername
        messageLabel.text = message.message
        messageSender = message.messageSender
        setNeedsLayout()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        colorLabel.clipsToBounds = true
        messageLabel.clipsToBounds = true
        messageLabel.textColor = .white
        messageLabel.layer.borderWidth = 0.5
        messageLabel.layer.borderColor = UIColor.lightGray.cgColor
        messageLabel.numberOfLines = 0
        
        
        nameLabel.textColor = .lightGray
        nameLabel.font = UIFont(name: "Avenir", size: 14)
        
        clipsToBounds = true
        
        addSubview(timeLabel)
        addSubview(colorLabel)
        addSubview(messageLabel)
        addSubview(nameLabel)
    }
    
    class func height(for message: Message) -> CGFloat {
        let maxSize = CGSize(width: 2*(UIScreen.main.bounds.size.width/3), height: CGFloat.greatestFiniteMagnitude)
        let nameHeight = message.messageSender == .yourself ? 0 : (height(forText: message.senderUsername, fontSize: 14, maxSize: maxSize) + 4 )
        let messageHeight = height(forText: message.message, fontSize: 17, maxSize: maxSize)
        
        return nameHeight + messageHeight + 32 + 16
    }
    
    private class func height(forText text: String, fontSize: CGFloat, maxSize: CGSize) -> CGFloat {
        let font = UIFont(name: "Avenir-Book", size: fontSize)!
        let attrString = NSAttributedString(string: text, attributes:[NSAttributedString.Key.font: font,
                                                                      NSAttributedString.Key.foregroundColor: UIColor.white])
        let textHeight = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size.height
        
        return textHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder error")
    }
}
