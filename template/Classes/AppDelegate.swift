//
//  AppDelegate.swift
//  template
//
//  Created by Alexis Creuzot on 22/03/2020.
//  Copyright © 2020 alexiscreuzot. All rights reserved.
//

import UIKit
import PluggableAppDelegate

@UIApplicationMain
class AppDelegate: PluggableApplicationDelegate {
    
    override var services: [ApplicationService] {
        return [
            LogService.shared,
            LocalDataService.shared,
            ThemeService.shared,
            AnalyticsService.shared,
            RoutingService.shared
        ]
    }
}
