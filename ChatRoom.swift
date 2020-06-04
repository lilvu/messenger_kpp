//
//  ChatRoom.swift
//  Chatter
//
//  Created by kotik on 06.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

protocol ChatRoomDelegate: class {
    func received(message: Message)
}

class ChatRoom: NSObject {
    //определяем потоки ввода/вывода
    var inputStream: InputStream!
    var outputStream: OutputStream!
    
    weak var delegate: ChatRoomDelegate?
    
    var username = ""
    //максимальная длина сообщения
    let maxLength = 4096
    
    func setupNetworkCommunication() {
        //определяем две переменные для потоков сокета без использования автоматического управления памятью
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        //сами потоки, привязанные к хосту и номеру порта
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, "localhost" as CFString, 70, &readStream, &writeStream)
        //сохраняет ссылки на потоки
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        //добавляет потоки к циклу выполнения, чтобы приложение корректно отрабатывало сетевые события
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        //открывает соединение между клиентом и серверным приложением
        inputStream.open()
        outputStream.open()
    }
    
    func joinChat(username: String) {
        
        let data = "iam:\(username)".data(using: .utf8)!
        self.username = username
        
        //withUnsafeBytes обеспечивает удобный способ работы с небезопасным указателем внутри замыкания
        _ = data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("Ошибка")
                return
            }
            //отправляет сообщение в выходной поток
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    func send(message: String) {
        let data = "msg:\(message)".data(using: .utf8)!
        _ = data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("Ошибка")
                return
            }
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    //так как соединение через сокет обеспечивается дескриптором файла, по окончанию работы нужно его закрыть
    func stopChatSession() {
        inputStream.close()
        outputStream.close()
    }
    
}

//отлавливает сообщения, преобразовывает их в экземпляры класса Message, и передает их таблице для отображения
extension ChatRoom: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable: //показывает, что поступило входящее сообщение
            print("Новое сообщение")
            readAvailableBytes(stream: aStream as! InputStream)
        case .endEncountered:
            stopChatSession()
        case .errorOccurred:
            print("Ошибка")
        default:
            print("")
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {
        //буфер, в который будем читать поступающие байты
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxLength)
        while stream.hasBytesAvailable {
            //считывает байты из потока и помещает их в буфер
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxLength)
            //если вызов вернул отрицательное значение — возвращаем ошибку и выходим из цикла
            if numberOfBytesRead < 0, let error = stream.streamError {
                print(error)
                break
            }
            
            if let message = processedMessageString(buffer: buffer, length: numberOfBytesRead) {
                delegate?.received(message: message)
            }
        }
    }
    
    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>,
                                        length: Int) -> Message? {
        //инициализируем String, используя буфер и размер, которые передаем в этот метод
        guard
            let stringArray = String(
                bytesNoCopy: buffer,
                length: length,
                encoding: .utf8,
                //освобождаем буфер, и делим сообщение по символу ':', чтобы разделить имя отправителя и сообщение
                freeWhenDone: true)?.components(separatedBy: ":"),
            let name = stringArray.first,
            let message = stringArray.last
            else {
                return nil
        }
        // проверка, мое ли это сообщение или от другого участника
        let messageSender: MessageSender = (name == self.username) ? .yourself : .someoneElse
        return Message(message: message, messageSender: messageSender, username: name)
    }
}

