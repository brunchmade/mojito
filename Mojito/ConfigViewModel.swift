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
    let installOrUninstallAction:Action<AnyObject?, AnyObject, MojitoInstallationError>
    
    private let installSignal:Signal<Bool, NoError>
    private let installObserver:Observer<Bool, NoError>
    
    init() {
        let (installSignal, installObserver) = Signal<Bool, NoError>.pipe()
        (self.installSignal, self.installObserver) = (installSignal, installObserver)
        self.installed = AnyProperty(initialValue: MojitoInstallation.installed, signal: self.installSignal)
        self.installOrUninstallAction = Action { _ in
            return SignalProducer { observer, _ in
                do {
                    if (MojitoInstallation.installed) {
                        try MojitoInstallation.uninstall()
                    } else {
                        try MojitoInstallation.install()
                    }
                    observer.sendCompleted()
                } catch {
                    observer.sendFailed(MojitoInstallationError.InstallInputMethodError)
                }
                installObserver.sendNext(MojitoInstallation.installed)
            }
        }
    }
}