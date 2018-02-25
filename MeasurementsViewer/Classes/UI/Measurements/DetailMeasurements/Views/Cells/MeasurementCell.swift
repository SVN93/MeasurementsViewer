//
//  MeasurementCell.swift
//  MeasurementsViewer
//
//  Created by Vladislav Solovyov on 25/02/2018.
//  Copyright © 2018 Vladislav Solovyov. All rights reserved.
//

import UIKit

class MeasurementCell: BaseTableViewCell {

    let dateLabel: UILabel = {
        var v = UILabel()
        v.font = UIFont.boldSystemFont(ofSize: 12)
        v.textColor = .black
        v.textAlignment = .left
        v.baselineAdjustment = .alignCenters
        return v
    }()
    let valuesLabel: UILabel = {
        var v = UILabel()
        v.font = UIFont.systemFont(ofSize: 12)
        v.textColor = .gray
        v.textAlignment = .right
        v.baselineAdjustment = .alignCenters
        v.numberOfLines = 0
        return v
    }()

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    var measurement: Measurement? {
        didSet {
            if let measurement = self.measurement {
                self.dateLabel.text = type(of: self).dateFormatter.string(from: measurement.timestamp)
                if let locations = measurement.locations {
                    self.valuesLabel.text = "\(locations.first!), \(locations.last!)"
                } else if let serialNumber = measurement.serialNumber {
                    self.valuesLabel.text = serialNumber
                } else if let value = measurement.value {
                    self.valuesLabel.text = "\(value)"
                } else {
                    self.valuesLabel.text = ""
                }
            } else {
                self.dateLabel.text = ""
                self.valuesLabel.text = ""
            }
            
            self.setNeedsLayout()
        }
    }

    override func setup() {
        super.setup()
        self.contentView.addSubview(self.dateLabel)
        self.contentView.addSubview(self.valuesLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let horizontalOffset = CGFloat(10)
        
        self.dateLabel.frame = {
            var frame = CGRect.zero
            frame.origin.x = horizontalOffset
            frame.size.height = self.contentView.bounds.height
            frame.size.width = self.dateLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: frame.height)).width
            return frame
        }()
        
        self.valuesLabel.frame = {
            var frame = CGRect.zero
            frame.origin.x = self.dateLabel.frame.maxX + horizontalOffset
            frame.size.height = self.contentView.bounds.height
            frame.size.width = self.contentView.bounds.width - frame.origin.x - horizontalOffset
            return frame
        }()
    }
    
}
