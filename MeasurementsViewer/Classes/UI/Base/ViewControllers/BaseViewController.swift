//
//  BaseViewController.swift
//  MeasurementsViewer
//
//  Created by Vladislav Solovyov on 14/02/2018.
//  Copyright © 2018 Vladislav Solovyov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    open func commpnSetup() {
        self.automaticallyAdjustsScrollViewInsets = true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commpnSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commpnSetup()
    }

}
