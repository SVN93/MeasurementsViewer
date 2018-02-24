//
//  MeasurementsService.swift
//  MeasurementsViewer
//
//  Created by Vladislav Solovyov on 14/02/2018.
//  Copyright © 2018 Vladislav Solovyov. All rights reserved.
//

import Foundation
import IKEventSource

protocol MeasurementsServiceDelegate: class {
    func measurementsService(_ service: MeasurementsService, didReceive measurements: [MeasurementsContainer])
}

class MeasurementsService: BaseService {
    
    fileprivate let apiString = "https://jsdemo.envdev.io/sse"
    fileprivate var eventSource: EventSource?
    
    var currentMeasurements = [MeasurementsContainer]()
    weak var delegate: MeasurementsServiceDelegate?
    
    override init() {
        super.init()
    }
    
    func connect() {
        self.eventSource = EventSource(url: self.apiString)
        
        self.eventSource?.onOpen {
            // When opened
        }
        
        self.eventSource?.onError { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
        
        self.eventSource?.onMessage { (id, event, data) in
            if let dataString = data {
                let utf8Data = dataString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                do {
                    let json = try JSONSerialization.jsonObject(with: utf8Data, options: []) as! Array<Dictionary<String, Any>>
                    var measurementsContainers = [MeasurementsContainer]()
                    for dictionary in json {
                        let measurmentsContainer = MeasurementsContainer(dictionary)
                        measurementsContainers.append(measurmentsContainer)
                    }
                    
                    self.currentMeasurements.append(contentsOf: measurementsContainers)
                    self.delegate?.measurementsService(self, didReceive: measurementsContainers)
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        }
        
        self.eventSource?.addEventListener("event-name") { (id, event, data) in
            // Here you get an event 'event-name'
        }
    }

    func disconnect() {
        if self.eventSource != nil {
            self.eventSource!.close()
        }
    }
    
}
