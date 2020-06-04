//
//  Appearance.swift
//  Chatter
//
//  Created by kotik on 06.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import SwiftUI

extension SecondScreenViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        loadViews()
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
            let messageBarHeight = messageInputBar.bounds.size.height
            let point = CGPoint(x: messageInputBar.center.x, y: endFrame.origin.y - messageBarHeight/2.0)
            let inset = UIEdgeInsets(top: 0, left: 0, bottom: endFrame.size.height, right: 0)
            UIView.animate(withDuration: 0.25) {
                self.messageInputBar.center = point
                self.tableView.contentInset = inset
            }
        }
    }
    
    
    func loadViews() {
        
        navigationItem.title = "Chatter"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 20)!]
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none //table view без ячеек
        
        view.addSubview(tableView)
        view.addSubview(messageInputBar)
        
        messageInputBar.delegate = self
    }
    
    //constraints
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let messageBarHeight:CGFloat = 60.0
        let size = view.bounds.size
        tableView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height - messageBarHeight - view.safeAreaInsets.bottom)
        messageInputBar.frame = CGRect(x: 0, y: size.height - messageBarHeight - view.safeAreaInsets.bottom, width: size.width, height: messageBarHeight)
    }
}

extension FirstScreenViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews()
        
        view.addSubview(logoImageView)
        view.addSubview(nameTextField)
    }
    
    func loadViews() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        view.contentMode = UIView.ContentMode.scaleAspectFit
        
        logoImageView.image = UIImage(named: "logo2")
        logoImageView.layer.cornerRadius = 4
        logoImageView.clipsToBounds = true
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Введите ваш никнейм!",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)])
        nameTextField.font = UIFont(name: "Avenir-Light", size: 18)
        
        nameTextField.backgroundColor = UIColor(red: 0/255, green: 43/255, blue: 124/255, alpha: 0.25)
        nameTextField.textColor = .white
        nameTextField.layer.cornerRadius = 4
        nameTextField.delegate = self
        
        self.navigationController?.navigationBar.tintColor = UIColor.black //меняет цвет кнопки настройки
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logoImageView.bounds = CGRect(x: 0, y: 0, width: 150, height: 150)
        logoImageView.center = CGPoint(x: view.bounds.size.width / 2.0, y: logoImageView.bounds.size.height / 2.0 + view.bounds.size.height/4)
        
        nameTextField.bounds = CGRect(x: 0, y: 0, width: view.bounds.size.width - 40, height: 44)
        nameTextField.center = CGPoint(x: view.bounds.size.width / 2.0, y: logoImageView.center.y + logoImageView.bounds.size.height / 2.0 + 20 + 22)
    }
}

extension MessageTableView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        if isJoinMessage() {
            forJoinMessage()
            
        } else {
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor(red: 57/255, green: 111/255, blue: 153/255, alpha: 1.0).cgColor, UIColor(red: 142/255, green: 192/255, blue: 238/255, alpha: 1.0).cgColor]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.frame = view.bounds
            colorLabel.layer.insertSublayer(gradient, at: 0)
            
            messageLabel.backgroundColor = .clear
            messageLabel.font = UIFont(name: "Avenir-Book", size: 18)
            messageLabel.textColor = .white
            messageLabel.numberOfLines = 0
            
            
            let size = messageLabel.sizeThatFits(CGSize(width: 2 * (bounds.size.width / 3), height: .greatestFiniteMagnitude))
            colorLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16)
            messageLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16)
            timeLabel.frame = CGRect(x: 0, y: 0, width: size.width + 55, height: size.height + 30)
            
            if messageSender == .yourself {
                nameLabel.isHidden = true
                
                timeLabel.center = CGPoint(x: bounds.size.width - messageLabel.bounds.size.width/2.0 - 14, y: bounds.size.height/1.5 + 18)
                
                colorLabel.center = CGPoint(x: bounds.size.width - messageLabel.bounds.size.width/2.0 - 8, y: bounds.size.height/2.0)
                messageLabel.center = CGPoint(x: bounds.size.width - messageLabel.bounds.size.width/2.0 - 8, y: bounds.size.height/2.0)
                
            } else {
                nameLabel.isHidden = false
                nameLabel.sizeToFit()
                timeLabel.sizeToFit()
                nameLabel.center = CGPoint(x: nameLabel.bounds.size.width / 2.0 + 16 + 4, y: nameLabel.bounds.size.height/1.5 + 2)
                timeLabel.center = CGPoint(x: timeLabel.bounds.size.width / 2.0 + 10, y: timeLabel.bounds.size.height/1.5 + 68)
                
                
                colorLabel.center = CGPoint(x: messageLabel.bounds.size.width / 2.0 + 8, y: messageLabel.bounds.size.height/2.0 + nameLabel.bounds.size.height + 8)
                messageLabel.center = CGPoint(x: messageLabel.bounds.size.width / 2.0 + 8, y: messageLabel.bounds.size.height/2.0 + nameLabel.bounds.size.height + 8)
                messageLabel.backgroundColor = .white
                messageLabel.textColor = .darkText
            }
        }
        
        colorLabel.layer.cornerRadius = min(messageLabel.bounds.size.height / 2.0, 20)
        messageLabel.layer.cornerRadius = min(messageLabel.bounds.size.height / 2.0, 20)
    }
    
    func forJoinMessage() {
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        messageLabel.textColor = .lightGray
        messageLabel.backgroundColor = UIColor(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
        
        let size = messageLabel.sizeThatFits(CGSize(width: 2 * (bounds.size.width / 3), height: .greatestFiniteMagnitude))
        colorLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16)
        messageLabel.frame = CGRect(x: 0, y: 0, width: size.width + 32, height: size.height + 16)
        messageLabel.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2.0)
    }
    
    func isJoinMessage() -> Bool {
        if let words = messageLabel.text?.components(separatedBy: " ") {
            if words.count >= 2 && words[words.count - 2] == "has" && words[words.count - 1] ==
                "joined" {
                messageLabel.layer.borderWidth = 0
                return true
            }
        }
        return false
    }
}

