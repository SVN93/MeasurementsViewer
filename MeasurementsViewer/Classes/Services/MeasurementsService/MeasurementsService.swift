//
//  MeasurementsService.swift
//  MeasurementsViewer
//
//  Created by Vladislav Solovyov on 14/02/2018.
//  Copyright © 2018 Vladislav Solovyov. All rights reserved.
//

import Foundation

class MeasurementsService: BaseService, StreamDelegate {
    
    private let hostString = "jsdemo.envdev.io"
    private let apiString = "https://jsdemo.envdev.io/sse"
    private let port: Int = 443
    private let maxReadLength: Int = 4096
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    
    override init() {
        super.init()
    }
    
    func connect() {
        Stream.getStreamsToHost(withName: self.hostString, port: self.port, inputStream: &self.inputStream, outputStream: &self.outputStream)
        
        guard let _ = self.inputStream, let _ = self.outputStream else {
            print("Something went wrong!")
            return
        }
        
        self.inputStream?.delegate = self
        self.outputStream?.delegate = self
        
        self.inputStream?.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)
        self.outputStream?.schedule(in: RunLoop.current, forMode: .defaultRunLoopMode)

        self.inputStream?.setProperty(StreamSocketSecurityLevel.tlSv1, forKey: .socketSecurityLevelKey)
        self.outputStream?.setProperty(StreamSocketSecurityLevel.tlSv1, forKey: .socketSecurityLevelKey)

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
    
    func write(_ data: Data) {
        let _ = data.withUnsafeBytes { (unsafePointer:UnsafePointer<UInt8>) in
            if let bytesWritten = self.outputStream?.write(unsafePointer, maxLength: data.count) {
                print("Bytes written \(bytesWritten)")
            } else {
                print("No bytes written!")
            }
        }
    }
    
    func readAvailableBytes(stream: InputStream) {
        var data = Data()
        var totalBytesRead = 0
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: self.maxReadLength)
        while stream.hasBytesAvailable {
            let numberOfBytesRead = stream.read(buffer, maxLength: self.maxReadLength)
            if numberOfBytesRead < 0 {
                if let streamError = stream.streamError {
                    print(streamError.localizedDescription)
                }
            }
            
            if (numberOfBytesRead > 0) {
                data.append(buffer, count: numberOfBytesRead)
                totalBytesRead += numberOfBytesRead
            } else {
                NSLog("Empty string from stream. Something went wrong!")
            }
            
        }
        buffer.deallocate(capacity: self.maxReadLength)
        
        if data.isEmpty == false {
            if let dataString = String(data: data, encoding: .utf8) {
                NSLog("server said: %@", dataString)
                //TODO: start Measurements mapping!
            }
        }
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
            print("Stream \(aStream.debugDescription) opened!")
            break
            
        case Stream.Event.hasBytesAvailable:
            if aStream == self.inputStream {
                self.readAvailableBytes(stream: aStream as! InputStream)
            }
            break
            
        case Stream.Event.hasSpaceAvailable:
            if (aStream == self.outputStream) {
                if let data = "GET \(self.apiString) HTTP/1.0\r\n\r\n".data(using: .utf8, allowLossyConversion: true) {
                    self.write(data)
                    self.outputStream?.close()
                }
            }
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
            print("Unsupported case.")
            break
        }
    }
    
}
