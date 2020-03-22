//
//  LogService.swift
//  template
//
//  Created by Alexis Creuzot on 26/07/2019.
//  Copyright © 2019 waverlylabs. All rights reserved.
//

import PluggableAppDelegate
import SwiftyBeaver

let log = SwiftyBeaver.self

final class LogService: NSObject, ApplicationService {
    
    static let shared = LogService()
    
    public var logFileURL : URL? {
        if var url = try? FileManager.default.url(for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true) {
            url.appendPathComponent("logs")
            url.appendPathExtension("txt")
            return url
        }
        return nil
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        self.configure()
        
        print("🚀 LogService has started!")
        
        return true
    }
    
    func configure() {
        let console = LooqDestination()
        console.minLevel = .debug
        log.addDestination(console)
    }
    
}


class LooqDestination : BaseDestination {
    /// uses colors compatible to Terminal instead of Xcode, default is false
    
    public override init() {
        super.init()
        
        levelColor.verbose = "💬 "     // silver
        levelColor.debug = "🔎 "        // green
        levelColor.info = "ℹ️ "         // blue
        levelColor.warning = "⚠️ "     // yellow
        levelColor.error = "❌ "       // red
    }
    
    // print to Xcode Console. uses full base class functionality
    override public func send(_ level: SwiftyBeaver.Level, msg: String, thread: String,
                              file: String, function: String, line: Int, context: Any? = nil) -> String? {
        
        switch level {
        case .verbose, .debug, .info:
            self.format = "$C$M"
        break
        default:
            self.format = "$C$c $N.$F:$l - $M"
            break
        }
        
        let formattedString = super.send(level, msg: msg, thread: thread, file: file, function: function, line: line, context: context)
        if let str = formattedString {
            print(str)
        }
        return formattedString
    }
}

