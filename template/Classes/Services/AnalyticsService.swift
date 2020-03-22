//
//  AnalyticsApplicationService.swift
//  looq
//
//  Created by Alexis Creuzot on 10/08/2018.
//  Copyright © 2018 alexiscreuzot. All rights reserved.
//

import PluggableAppDelegate

final class AnalyticsService: NSObject, ApplicationService {
    
    static let shared = AnalyticsService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        guard !Debug.isOmega else {
            return true
        }
        print("🚀 AnalyticsService has started!")

        return true
    }

    func logEvent(name: String, attributes:[String: Any]) {
        guard !Debug.isOmega else { return }
        
        // Log event
    }
    
}
