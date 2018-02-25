//
//  DetailMeasurementsViewController.swift
//  MeasurementsViewer
//
//  Created by Vladislav Solovyov on 25/02/2018.
//  Copyright © 2018 Vladislav Solovyov. All rights reserved.
//

import UIKit

class DetailMeasurementsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var measurementsContainer: MeasurementsContainer?
    let detailMeasurementsView = DetailMeasurementsView()
    
    override func commpnSetup() {
        super.commpnSetup()
        self.edgesForExtendedLayout = []
    }
    
    convenience init(measurementsContainer: MeasurementsContainer) {
        self.init(nibName: nil, bundle: nil)
        self.measurementsContainer = measurementsContainer
    }
    
    override func loadView() {
        self.view = self.detailMeasurementsView
    }
    
    let cellReuseIdentifier = "measurementCellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.measurementsContainer?.name
        self.detailMeasurementsView.idLabel.text = NSLocalizedString("ID: ", comment: "") + (self.measurementsContainer?.id ?? "")
        if let unit = self.measurementsContainer?.unit {
            self.detailMeasurementsView.unitLabel.text = NSLocalizedString("Unit: ", comment: "") + unit
        }
        
        self.detailMeasurementsView.tableView.isHidden = (self.measurementsContainer?.measurements == nil)
        
        self.detailMeasurementsView.tableView.register(MeasurementCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        self.detailMeasurementsView.tableView.dataSource = self
        self.detailMeasurementsView.tableView.delegate = self
        self.detailMeasurementsView.tableView.reloadData()
    }

    
    // MARK: - Table
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.measurementsContainer?.measurements?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as? MeasurementCell else {
            fatalError("Tableview returns incorrect cell for index path: \(indexPath)")
        }
        
        if let measurements = self.measurementsContainer?.measurements {
            let measurement = measurements[indexPath.row]
            cell.measurement = measurement
        }
        
        return cell
    }

}
