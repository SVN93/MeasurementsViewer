//
//  MeasurementContainer.swift
//  MeasurementsViewer
//
//  Created by Vladislav Solovyov on 24/02/2018.
//  Copyright © 2018 Vladislav Solovyov. All rights reserved.
//

import UIKit

class MeasurementsContainer {
//    enum Name: String {
//        case pressure, temperature, serial
//    }
//    enum Unit: String {
//        case v, mgm3
//    }

    var id: String
    var name: String
    var unit: String?
    var measurements: [Measurement]?
    
    init(_ dictionary: Dictionary<String, Any>) {
        self.id = dictionary["_id"] as! String
        self.name = dictionary["name"] as! String
        self.unit = dictionary["unit"] as? String
        if let measurements = dictionary["measurements"] as? [[Any]] {
            self.measurements = [Measurement]()
            for measurementArray in measurements {
                let measurement = Measurement(measurementArray)
                self.measurements?.append(measurement)
            }
        }
    }
}
