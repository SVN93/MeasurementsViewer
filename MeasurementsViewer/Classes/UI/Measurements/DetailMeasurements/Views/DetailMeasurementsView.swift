//
//  DetailMeasurementsView.swift
//  MeasurementsViewer
//
//  Created by Vladislav Solovyov on 25/02/2018.
//  Copyright © 2018 Vladislav Solovyov. All rights reserved.
//

import UIKit

class DetailMeasurementsView: BaseView {
    
    let idLabel: UILabel = {
        var v = UILabel()
        v.textColor = .black
        v.textAlignment = .left
        return v
    }()
    let unitLabel: UILabel = {
        var v = UILabel()
        v.textColor = .black
        v.textAlignment = .left
        return v
    }()
    let tableView = UITableView()

    override func setup() {
        super.setup()
        self.backgroundColor = .white
        self.addSubview(self.idLabel)
        self.addSubview(self.unitLabel)
        self.addSubview(self.tableView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let verticalOffset = CGFloat(10)
        self.idLabel.frame = {
            var frame = self.bounds.insetBy(dx: 10.0, dy: 10.0)
            frame.size.height = self.idLabel.sizeThatFits(CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude)).height
            return frame
        }()
        self.unitLabel.frame = {
            var frame = self.bounds.insetBy(dx: 10.0, dy: 10.0)
            frame.origin.y = self.idLabel.frame.maxY + verticalOffset
            frame.size.height = self.unitLabel.sizeThatFits(CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude)).height
            return frame
        }()
        self.tableView.frame = {
            var frame = self.bounds
            frame.origin.y = self.unitLabel.frame.maxY + verticalOffset
            frame.size.height = self.bounds.height - frame.origin.y - verticalOffset
            return frame
        }()
    }
    
}
