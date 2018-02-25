//
//  MeasurementsContainerCell.swift
//  MeasurementsViewer
//
//  Created by Vladislav Solovyov on 25/02/2018.
//  Copyright © 2018 Vladislav Solovyov. All rights reserved.
//

import UIKit

class MeasurementsContainerCell: BaseTableViewCell {

    let nameLabel: UILabel = {
        var v = UILabel()
        v.textColor = .black
        v.textAlignment = .left
        return v
    }()
    let unitLabel: UILabel = {
        var v = UILabel()
        v.textColor = .gray
        v.textAlignment = .center
        return v
    }()
    let measurmentsCountLabel: UILabel = {
        var v = UILabel()
        v.textColor = .gray
        v.textAlignment = .right
        return v
    }()
        
    var measurementsContainer: MeasurementsContainer? {
        didSet {
            self.nameLabel.text = measurementsContainer?.name
            self.unitLabel.text = measurementsContainer?.unit
            if let measurements = measurementsContainer?.measurements {
                self.measurmentsCountLabel.text = "\(measurements.count) " + NSLocalizedString("Measurements", comment: "")
            } else {
                self.measurmentsCountLabel.text = ""
            }
            self.setNeedsLayout()
        }
    }
    
    override func setup() {
        super.setup()
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.unitLabel)
        self.contentView.addSubview(self.measurmentsCountLabel)
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let activeFrame = self.contentView.bounds.insetBy(dx: 10.0, dy: 10.0)
        
        self.nameLabel.frame = {
            var frame = activeFrame
            frame.size.width = self.nameLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: frame.height)).width
            return frame
        }()
        
        self.unitLabel.frame = {
            var frame = activeFrame
            frame.origin.x = self.nameLabel.frame.maxX + 4.0
            frame.size.width = self.unitLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: frame.height)).width
            return frame
        }()
        
        self.measurmentsCountLabel.frame = {
            var frame = activeFrame
            frame.origin.x = self.unitLabel.frame.maxX + 4.0
            frame.size.width = activeFrame.width - frame.origin.x
            return frame
        }()
    }
    
}
