//
//  smwUITests.swift
//  smwUITests
//
//  Created by Alexis Creuzot on 22/03/2020.
//  Copyright © 2020 alexiscreuzot. All rights reserved.
//

import XCTest

class smwUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
                
        snapshot("Home")
        
        app.buttons["Settings"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Add fake workouts"]/*[[".cells.staticTexts[\"Add fake workouts\"]",".staticTexts[\"Add fake workouts\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Settings"].buttons["Stop"].tap()
        
        app.buttons["Configure"].tap()
        
        snapshot("ConfigureWorkout")
        
        app.navigationBars["Configure Workout"].buttons["Stop"].tap()
        
        app.buttons["Stats"].tap()
        
        snapshot("Statistics")
        
        app.navigationBars["Statistics"].buttons["Stop"].tap()
        app.terminate()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
