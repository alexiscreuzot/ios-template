//
//  Constants.swift
//  rotoscopy
//
//  Created by Alexis Creuzot on 29/11/2019.
//  Copyright © 2019 monoqle. All rights reserved.
//

import Foundation

let i18n = R.string.localizable.self

struct Debug {
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    static var isOmega : Bool {
        return App.displayName.contains("Ω")
    }
}

struct App {
        
    static var bundleId : String {
        return Bundle.main.bundleIdentifier!
    }
    
    static var targetName : String {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    static var displayName : String {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }
    
    static var version : String {
        return( Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0"
    }
    
    static var buildNumber : String {
        return( Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "0"
    }

}
