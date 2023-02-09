//
//  SampleMetricKitUITests.swift
//  SampleMetricKitUITests
//
//  Created by Anton Pomozov on 06.02.2023.
//

import XCTest

final class SampleMetricKitUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Button"]/*[[".buttons[\"Button\"].staticTexts[\"Button\"]",".staticTexts[\"Button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }

    override func tearDownWithError() throws {
        app.navigationBars["SampleMetricKit.View"].buttons["Back"].tap()
    }

    func testHitchTime() throws {
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Button"]/*[[".buttons[\"Button\"].staticTexts[\"Button\"]",".staticTexts[\"Button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        execTest(repeatCount: Constant.repeatCount, swipeCount: Constant.swipeCount)
    }

    func testPerformance() throws {
        let measureOptions = XCTMeasureOptions()
        measureOptions.invocationOptions = [.manuallyStop]

        measure(metrics: [XCTOSSignpostMetric.scrollingAndDecelerationMetric], options: measureOptions) {
            execTest(repeatCount: 1, swipeCount: 1, isMeasuring: true)
        }
    }

    private var app: XCUIApplication!
}

private extension SampleMetricKitUITests {
    func execTest(repeatCount: Int, swipeCount: Int, isMeasuring: Bool = false) {
        let collection = app.collectionViews.firstMatch
        for _ in 0 ..< repeatCount {
            for _ in 0 ..< swipeCount {
                collection.swipeUp(velocity: .superFast)
            }

            if isMeasuring { stopMeasuring() }

            for _ in 0 ..< swipeCount {
                collection.swipeDown(velocity: .superFast)
            }
        }
    }
}

private enum Constant {
    static let repeatCount = 10
    static let swipeCount = 10
}

private extension XCUIGestureVelocity {
    static let superFast = XCUIGestureVelocity(rawValue: 10000.0)
}
