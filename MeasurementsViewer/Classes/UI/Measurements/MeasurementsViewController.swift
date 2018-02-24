//
//  ViewController.swift
//  MeasurementsViewer
//
//  Created by Vladislav Solovyov on 14/02/2018.
//  Copyright © 2018 Vladislav Solovyov. All rights reserved.
//

import UIKit

class MeasurementsViewController: BaseViewController, MeasurementsServiceDelegate, UITableViewDelegate, UITableViewDataSource {

    var controlBarButton: UIBarButtonItem?
    let measurementsView = MeasurementsView()
    let measurementsService = MeasurementsService()
    var isConnected: Bool = true
    var lastSelectedIndexPath: IndexPath?

    override func loadView() {
        self.view = self.measurementsView
    }
    
    func getConnectButtonTitle() -> String {
        return self.isConnected ? NSLocalizedString("Disconnect", comment: "") : NSLocalizedString("Connect", comment: "")
    }
        
    let cellReuseIdentifier = "measurementsContainerCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Measurements", comment: "")
        
        self.controlBarButton = UIBarButtonItem(title: self.getConnectButtonTitle(), style: .plain, target: self, action: #selector(controlButtonTapped))
        self.navigationItem.rightBarButtonItem = self.controlBarButton

        self.measurementsView.tableView.register(MeasurementsContainerCell.self, forCellReuseIdentifier: self.cellReuseIdentifier)
        
        self.measurementsView.tableView.dataSource = self
        self.measurementsView.tableView.delegate = self
        self.measurementsView.tableView.reloadData()
        
        self.measurementsService.delegate = self
        self.measurementsService.connect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = self.lastSelectedIndexPath {
            self.measurementsView.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    deinit {
        self.isConnected = false
        self.measurementsService.disconnect()
    }
    
    @objc func controlButtonTapped() {
        self.isConnected = !self.isConnected
        if self.isConnected {
            self.measurementsService.connect()
        } else {
            self.measurementsService.disconnect()
        }
        self.controlBarButton?.title = self.getConnectButtonTitle()
    }
    
    
    // MARK: - MeasurementsServiceDelegate
 
    func measurementsService(_ service: MeasurementsService, didReceive measurements: [MeasurementsContainer]) {
        var indexPaths = [IndexPath]()
        for (index, measurement) in service.currentMeasurements.enumerated() {
            for newMeasurement in measurements {
                if measurement.id == newMeasurement.id {
                    let indexPath = IndexPath(row: index, section: 0)
                    indexPaths.append(indexPath)
                }
            }
        }
        self.measurementsView.tableView.beginUpdates()
        self.measurementsView.tableView.insertRows(at: indexPaths, with: .right)
        self.measurementsView.tableView.endUpdates()
    }
    
    
    // MARK: - Table
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.measurementsService.currentMeasurements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as? MeasurementsContainerCell else {
            fatalError("Tableview returns incorrect cell for index path: \(indexPath)")
        }
        
        let measurementsContainer = self.measurementsService.currentMeasurements[indexPath.row]
        cell.measurementsContainer = measurementsContainer
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lastSelectedIndexPath = indexPath
        let measurementsContainer = self.measurementsService.currentMeasurements[indexPath.row]
        let detailMeasurementsViewController = DetailMeasurementsViewController(measurementsContainer: measurementsContainer)
        self.navigationController?.pushViewController(detailMeasurementsViewController, animated: true)
    }
    
}

