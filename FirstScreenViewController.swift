//
//  FirstScreenViewController.swift
//  Chatter
//
//  Created by kotik on 06.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import SwiftUI

//первое окно, ввод никнейма
class FirstScreenViewController: UIViewController {
    let logoImageView = UIImageView()
    let nameTextField = TextField()
    
    //убирает navigation bar
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
         navigationItem.hidesBackButton = true
        
        super.viewWillAppear(animated)
    }
    
}
//переход во второй контроллер с чатом
extension FirstScreenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let chatRoom = SecondScreenViewController()
        let username = nameTextField.text
        
        // проверка на пустой никнейм
        if username!.isEmpty {
            print("Ошибка: никнейм не может быть пустым")
            return false
        }
        else {
            chatRoom.username = username!
        }
        
        navigationController?.pushViewController(chatRoom, animated: true)
        return true
    }
}
//констрейнты для текстового поля
class TextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 8)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


