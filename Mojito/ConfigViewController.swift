//
//  ConfigViewController.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 2/6/16.
//  Copyright © 2016 VictorLin. All rights reserved.
//

import Foundation
import Cocoa
import ReactiveCocoa

class ConfigViewController: NSViewController {
    var viewModel:ConfigViewModel!
    
    @IBOutlet weak var installButton: NSButton!
    
    private var installButtonHidden:DynamicProperty!
    
    func bindViewModel(viewModel:ConfigViewModel) {
        self.viewModel = viewModel
        let installButtonHidden = DynamicProperty(object: installButton, keyPath: "state")
        installButtonHidden.value = viewModel.installed.value
        installButtonHidden <~ viewModel.installed.signal.map { installed -> NSNumber in
            return installed ? NSOnState : NSOffState
        }
        
        installButton.rac_command = toRACCommand(viewModel.installOrUninstallAction)
    }
    
    override func viewDidLoad() {
        
    }
    
}
