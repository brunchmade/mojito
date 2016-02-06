//
//  CandidateWindowController.swift
//  Mojito
//
//  Created by Fang-Pen Lin on 12/24/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

import Cocoa

class CandidatesWindowController: NSWindowController {
    var viewModel:CandidatesWindowViewModel!
    
    func bindViewModel(viewModel:CandidatesWindowViewModel) {
        self.viewModel = viewModel
        viewModel.textRect.signal
            .observeNext { [unowned self] rect in
                var frame = self.window!.frame
                frame.origin = NSPoint(
                    x: rect.origin.x + rect.width / 2 - frame.width / 2,
                    y: rect.origin.y + rect.height + 10
                )
                self.window!.setFrame(frame, display: true, animate: false)
            }
        viewModel.visible.signal
            .observeNext { visible in
                if (visible) {
                    self.showWindow(self)
                } else {
                    self.window!.orderOut(self)
                }
            }

    }
}
