//
//  BaseTableViewCell.swift
//  MeasurementsViewer
//
//  Created by Vladislav Solovyov on 25/02/2018.
//  Copyright © 2018 Vladislav Solovyov. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    func setup() {
        // Basic initialization.
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

}
