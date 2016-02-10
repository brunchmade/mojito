//
//  ConfigViewModel.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 2/7/16.
//  Copyright © 2016 VictorLin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

class ConfigViewModel {
    let installed:AnyProperty<Bool>
    /// the action for install or uninstall, depends on installed state
    let installOrUninstallAction:Action<AnyObject?, AnyObject, MojitInstallationError>
    
    private let installSignal:Signal<Bool, NoError>
    private let installObserver:Observer<Bool, NoError>
    
    init() {
        let (installSignal, installObserver) = Signal<Bool, NoError>.pipe()
        (self.installSignal, self.installObserver) = (installSignal, installObserver)
        self.installed = AnyProperty(initialValue: MojitInstallation.installed, signal: self.installSignal)
        self.installOrUninstallAction = Action { _ in
            return SignalProducer { observer, _ in
                do {
                    if (MojitInstallation.installed) {
                        try MojitInstallation.uninstall()
                    } else {
                        try MojitInstallation.install()
                    }
                    observer.sendCompleted()
                } catch {
                    observer.sendFailed(MojitInstallationError.InstallInputMethodError)
                }
                installObserver.sendNext(MojitInstallation.installed)
            }
        }
    }
}