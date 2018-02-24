//
//  Measurement.swift
//  MeasurementsViewer
//
//  Created by Vladislav Solovyov on 24/02/2018.
//  Copyright © 2018 Vladislav Solovyov. All rights reserved.
//

import UIKit

class Measurement {

    var timestamp: Date
    var values: [Any]
    
    init(_ array: [Any]) {
//        print(array)
        self.timestamp = Date(timeIntervalSince1970: array.first as! TimeInterval)
        if array.last is Array<Any> {
            self.values = array.last as! [Any]
        } else {
            self.values = [array.last as Any]

//            if let stringValue = array.last as? String {
//                if let doubleStr = Double(stringValue) {
//                    self.values = [ doubleStr ]
//                } else {
//                    self.values = [ 0 ]
//                }
//            } else {
//                self.values = [array.last as! Double]
//            }
        }
    }
    
}
