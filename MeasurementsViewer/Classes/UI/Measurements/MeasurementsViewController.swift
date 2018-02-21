//
//  ViewController.swift
//  MeasurementsViewer
//
//  Created by Vladislav Solovyov on 14/02/2018.
//  Copyright © 2018 Vladislav Solovyov. All rights reserved.
//

import UIKit

class MeasurementsViewController: BaseViewController {

    let measurementsView = MeasurementsView()
    let measurementsService = MeasurementsService()
    
    override func loadView() {
        self.view = self.measurementsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Measurements", comment: "")
        
        self.measurementsService.connect()
    }
    
    deinit {
        self.measurementsService.disconnect()
    }

}

