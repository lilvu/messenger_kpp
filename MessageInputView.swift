//
//  MessageInputView.swift
//  Chatter
//
//  Created by kotik on 06.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

protocol MessageInputDelegate {
    func sendWasTapped(message: String)
    
}

class MessageInputView: UIView {
    var delegate: MessageInputDelegate?
    
    let textView = UITextView()
    let sendButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1.0)
        textView.font = UIFont(name: "Avenir-Light", size: 18)
        textView.layer.cornerRadius = 4
        textView.font = UIFont(name: "Avenir-Light", size: 18)
        
        textView.layer.borderColor = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 0.6).cgColor
        textView.layer.borderWidth = 1
        
        sendButton.setImage(UIImage(named: "send"), for: .normal)
        sendButton.setImage(UIImage(named: "send2"), for: .highlighted)
        
        sendButton.layer.cornerRadius = 6
        
        sendButton.isEnabled = true
        sendButton.addTarget(self, action: #selector(MessageInputView.sendTapped), for: .touchUpInside)
        
        addSubview(textView)
        addSubview(sendButton)
    }
    
    @objc func sendTapped() {
        if let delegate = delegate, let message = textView.text {
            delegate.sendWasTapped(message:  message)
            textView.text = ""
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = bounds.size
        textView.bounds = CGRect(x: 0, y: 0, width: size.width - 20 - 15 - 35, height: 40)
        sendButton.bounds = CGRect(x: 0, y: 0, width: 38, height: 38)
        
        textView.center = CGPoint(x: textView.bounds.size.width/2.0 + 15, y: bounds.size.height / 2.0)
        sendButton.center = CGPoint(x: bounds.size.width - 8 - 20, y: bounds.size.height / 2.0)
    }
}

extension MessageInputView: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
}
