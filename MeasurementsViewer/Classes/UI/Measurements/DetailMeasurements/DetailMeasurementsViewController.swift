//
//  DetailMeasurementsViewController.swift
//  MeasurementsViewer
//
//  Created by Vladislav Solovyov on 25/02/2018.
//  Copyright © 2018 Vladislav Solovyov. All rights reserved.
//

import UIKit

class DetailMeasurementsViewController: BaseViewController {

    var measurementsContainer: MeasurementsContainer?
    let detailMeasurementsView = DetailMeasurementsView()
    
    convenience init(measurementsContainer: MeasurementsContainer) {
        self.init(nibName: nil, bundle: nil)
        self.measurementsContainer = measurementsContainer
    }
    
    override func loadView() {
        self.view = self.detailMeasurementsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.measurementsContainer?.name
        // Do any additional setup after loading the view.
    }

}
