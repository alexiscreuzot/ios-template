//
//  PalauService.swift
//  looq
//
//  Created by Alexis Creuzot on 10/08/2018.
//  Copyright © 2018 alexiscreuzot. All rights reserved.
//

import PluggableAppDelegate

final class LocalDataService: NSObject, ApplicationService {
    
    static let shared = LocalDataService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("🚀 LocalDataService has started!")
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
}
