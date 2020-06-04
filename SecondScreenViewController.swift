//
//  SecondScreenViewController.swift
//  Chatter
//
//  Created by kotik on 06.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import SwiftUI

//Сам чат

class SecondScreenViewController: UIViewController {
    
    let tableView = UITableView()
    let messageInputBar = MessageInputView() //окно ввода сообщения
    let chatRoom = ChatRoom()
    
    var messages: [Message] = []
    var username = ""
    
    var controller : UIViewController!
    var menuViewController: UIHostingController<Menu>!
    var isMove = false

    
    func configureMenuViewController() {
        if menuViewController == nil {
            menuViewController = UIHostingController(rootView: Menu())
            
            view.addSubview(menuViewController.view)
            addChild(menuViewController)
            menuViewController.didMove(toParent: self)
            
            menuViewController.view.translatesAutoresizingMaskIntoConstraints = false
            }
            
            NSLayoutConstraint.activate ([
                menuViewController.view.widthAnchor.constraint(equalToConstant: -UIScreen.main.bounds.width / 1.5),
                menuViewController.view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - 50),
            ])
        }
    

    
    func showMenuViewController(shouldMove: Bool) {
    
        if shouldMove {
            // показывает menu
            UIView.animate(withDuration: 0.5,delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.view.frame.origin.x = self.view.frame.width - 140
            })
            
        } else {
            // убираем menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.view.frame.origin.x = 0
            })
        }
    }
    
    @objc func toggleMenu() {
        configureMenuViewController()
        isMove = !isMove
        showMenuViewController(shouldMove: isMove)
    }
    
    @objc func alertAction() {
        let alert = UIAlertController(title: "Выйти из аккаунта?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: { action in }))
        alert.addAction(UIAlertAction(title: "Да", style: .cancel, handler: { action in
        self.navigationController?.pushViewController(FirstScreenViewController(), animated: false)}))
        
        self.present(alert, animated: true)
    }
    
    
    //возвращает видимость navigation bar; button "настройки", которая открывает меню
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setValue(false, forKey: "hidesShadow")
        
        let barButton = UIBarButtonItem(image: UIImage(named: "controls"), style: .plain, target: self, action: #selector(toggleMenu))
        self.navigationItem.leftBarButtonItem = barButton
        
        let backButton = UIBarButtonItem(image: UIImage(named: "login"), style: .plain, target: self, action: #selector(alertAction))
        self.navigationItem.rightBarButtonItem = backButton
        
        super.viewWillAppear(animated)
        
        chatRoom.delegate = self
        chatRoom.setupNetworkCommunication()
        chatRoom.joinChat(username: username)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chatRoom.stopChatSession()
    }
    
}



// проверка: если сообщение не пустое, вызывается функция отправки сообщения
extension SecondScreenViewController: MessageInputDelegate {
    
    func sendWasTapped(message: String) {
        if message.isEmpty {
            print("Ошибка: сообщение не может быть пустым")
        }
        else {
            chatRoom.send(message: message)
        }
    }
}

//отправленное сообщение появляется на экране
extension SecondScreenViewController: ChatRoomDelegate {
    
    func received(message: Message) {
        insertNewMessageCell(message)
    }
}


