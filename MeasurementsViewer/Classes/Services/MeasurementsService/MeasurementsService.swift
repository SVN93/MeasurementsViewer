//
//  MeasurementsService.swift
//  MeasurementsViewer
//
//  Created by Vladislav Solovyov on 14/02/2018.
//  Copyright © 2018 Vladislav Solovyov. All rights reserved.
//

import Foundation

class MeasurementsService: BaseService, StreamDelegate {
    
    private let host = "https://jsdemo.envdev.io/sse"
//    private let host = "www.apple.com"
    private let port: Int = 443
//    private let port: Int = 80
    private let maxReadLength: Int = 1024
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    
    override init() {
        super.init()
    }
    
    func connect() {
        Stream.getStreamsToHost(withName: self.host, port: self.port, inputStream: &self.inputStream, outputStream: &self.outputStream)
        
        guard let _ = self.inputStream, let _ = self.outputStream else {
            print("Something went wrong!")
            return
        }
        
        self.inputStream?.delegate = self
        self.outputStream?.delegate = self
        
        self.inputStream?.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        self.outputStream?.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)

        self.inputStream?.open()
        self.outputStream?.open()
    }

    func disconnect() {
        if let stream = self.inputStream {
            stream.close()
            stream.remove(from: RunLoop.current, forMode: .defaultRunLoopMode)
        }
        
        if let stream = self.outputStream {
            stream.close()
            stream.remove(from: RunLoop.current, forMode: .defaultRunLoopMode)
        }
        
        self.inputStream = nil
        self.outputStream = nil
    }
    
//    func write(_ data: Data) {
//        let _ = data.withUnsafeBytes { (unsafePointer:UnsafePointer<UInt8>) in
//            let bytesWritten = self.outputStream?.write(unsafePointer, maxLength: data.count)
//        }
//    }
    
//    func processedMeasurementsString(buffer: UnsafeMutablePointer<UInt8>,
//                                        length: Int) -> Measurements? {
//        guard let stringArray = String(bytesNoCopy: buffer,
//                                       length: length,
//                                       encoding: .ascii,
//                                       freeWhenDone: true)?.components(separatedBy: ":"),
//            let name = stringArray.first,
//            let message = stringArray.last else {
//                return nil
//        }
//
//        let messageSender:MessageSender = (name == self.username) ? .ourself : .someoneElse
//
//        return Message(message: message, messageSender: messageSender, username: name)
//    }

    func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: self.maxReadLength)
        while stream.hasBytesAvailable {
            let numberOfBytesRead = stream.read(buffer, maxLength: self.maxReadLength)
            if numberOfBytesRead < 0 {
                if let _ = stream.streamError {
                    break
                }
            }
            
            //Construct the Message object
            if (numberOfBytesRead > 0) {
                let output = String(cString:buffer)
                NSLog("server said: %@", output)
            } else {
                NSLog("empty string from stream")
            }
            
        }
        buffer.deallocate(capacity: self.maxReadLength)
        
//        String(bytesNoCopy: buffer, length: self.maxReadLength, encoding: .ascii, freeWhenDone: true)
//        guard let stringArray = String(bytesNoCopy: buffer,
//                                       length: self.maxReadLength,
//                                       encoding: .ascii,
//                                       freeWhenDone: true)?.components(separatedBy: ":"),
//            let name = stringArray.first,
//            let message = stringArray.last else {
//                return nil
//        }
    }
    
    deinit {
        self.inputStream?.delegate = nil
        self.outputStream?.delegate = nil
        self.disconnect()
    }
    
    
    // MARK: - StreamDelegate
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        print("EventCode = \(eventCode)")
        switch eventCode {
        case Stream.Event.openCompleted:
            print("Stream opened!")
            break
            
        case Stream.Event.hasBytesAvailable:
            if aStream == self.inputStream {
                self.readAvailableBytes(stream: aStream as! InputStream)
            }
            break
            
        case Stream.Event.hasSpaceAvailable:
            break
            
        case Stream.Event.errorOccurred:
            if let streamError = aStream.streamError {
                print(streamError.localizedDescription)
            }
            break
            
        case Stream.Event.endEncountered:
            self.inputStream?.close()
            self.outputStream?.close()
            break
            
        default:
            break
        }
    }
    
}
