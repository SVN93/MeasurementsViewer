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
    var locations: [Double]?
    var value: Double?
    var serialNumber: String?
    
    init(_ array: [Any]) {
        self.timestamp = Date(timeIntervalSince1970: array.first as! TimeInterval)
        if array.last is Array<Any> {
            self.locations = array.last as? [Double]
        } else {
            if let stringValue = array.last as? String {
                self.serialNumber = stringValue
            } else {
                self.value = array.last as? Double
            }
        }
    }
    
}
