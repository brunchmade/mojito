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
    static let websiteURL = "https://mojito.cool"
    static let authors = [
        ("Wells Riley", "https://twitter.com/wr"),
        ("Victor Lin", "https://twitter.com/victorlin"),
        ("Ian Hirschfeld", "https://twitter.com/ianhirschfeld")
    ]
    
    var viewModel:ConfigViewModel!
    
    @IBOutlet weak var installButton: NSButton!
    @IBOutlet weak var mojitTitle: NSTextField!
    @IBOutlet weak var websiteLink: NSTextField!
    @IBOutlet weak var authorLinks: NSTextField!
    
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
        
        let bundleInfo = NSBundle.mainBundle().infoDictionary!
        let build = bundleInfo["CFBundleVersion"]!
        let version = bundleInfo["CFBundleShortVersionString"]!
        mojitTitle.stringValue = "Mojit v\(version) (build \(build))"
        
        websiteLink.allowsEditingTextAttributes = true
        websiteLink.selectable = true
        websiteLink.editable = false
        websiteLink.toolTip = "Official website"
        let webAttrStr = NSMutableAttributedString(string: "🌎: ")
        webAttrStr.appendAttributedString(NSAttributedString.hyperlink(ConfigViewController.websiteURL, url: NSURL(string: ConfigViewController.websiteURL)!))
        websiteLink.attributedStringValue = webAttrStr
        
        authorLinks.allowsEditingTextAttributes = true
        authorLinks.selectable = true
        authorLinks.editable = false
        authorLinks.toolTip = "Authors"
        let authorAttrStr = NSMutableAttributedString(string: "👥: ")
        let authorsExceptLastOne = ConfigViewController.authors[0..<ConfigViewController.authors.count - 1]
        for (index, (name, link)) in zip(authorsExceptLastOne.indices, authorsExceptLastOne) {
            authorAttrStr.appendAttributedString(NSAttributedString.hyperlink(name, url: NSURL(string: link)!))
            if (index != ConfigViewController.authors.count - 2) {
                authorAttrStr.appendAttributedString(NSAttributedString(string: ", "))
            }
        }
        if (ConfigViewController.authors.count > 1) {
            let (lastName, lastLink) = ConfigViewController.authors.last!
            authorAttrStr.appendAttributedString(NSAttributedString(string: " and "))
            authorAttrStr.appendAttributedString(NSAttributedString.hyperlink(lastName, url: NSURL(string: lastLink)!))
        }
        authorLinks.attributedStringValue = authorAttrStr
    }
    
}
