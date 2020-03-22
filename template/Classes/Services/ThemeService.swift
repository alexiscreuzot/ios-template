//
//  ThemeService.swift
//  pilotv2
//
//  Created by Alexis Creuzot on 29/08/2018.
//  Copyright © 2018 waverlylabs. All rights reserved.
//

import PluggableAppDelegate

enum Theme : String, CaseIterable, Codable {
    case auto = "Auto"
    case dark = "Dark"
    case light = "Light"
}

final class ThemeService: NSObject, ApplicationService {
    
    static let shared = ThemeService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("🚀 ThemeService has started!")
        
        self.styleUIKit()
        self.updateTheme()
        
        return true
    }
    
    func styleUIKit() {
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: CustomFont.subtitle.font,
                                                             .foregroundColor: UIColor.systemBlue],
                                                            for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: CustomFont.subtitle.font,
         .foregroundColor: UIColor.systemBlue],
        for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: CustomFont.subtitle.font,
                                                             .foregroundColor: UIColor.tertiaryLabel],
                                                            for: .disabled)
        
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = CustomFont.subtitle.font
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = CustomFont.subtitle.font
        UITextView.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = CustomFont.subtitle.font
    }
    
    func updateTheme() {
        guard   #available(iOS 13.0, *) else { return }
        let currentTheme = CustomPreferences.colorTheme
        switch currentTheme {
        case .auto:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .unspecified
            }
            break
        case .dark:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
            break
        case .light:
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
            break
        }
    }
    
}


