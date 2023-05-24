//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Егор Свистушкин on 22.05.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
        
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        let loginTextField = webView.descendants(matching: .textField).element
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        sleep(10)
        loginTextField.tap()
        loginTextField.typeText("boyegorka@gmail.com")
        sleep(2)
        passwordTextField.tap()
        passwordTextField.typeText("Qwerty123")
        webView.buttons["Login"].tap()
        
        //        Требуется раскрыть, если в перый раз заходите на устройстве под тем или иным аккаунтом, потому что после логина появляется окно с предоставлением разрешений
        //        sleep(3)
        //        webView.buttons["Continue as *ИМЯ*"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        app.swipeUp()
        sleep(3)
    }
    
    func testFeed() throws {
        XCTAssertTrue(app.waitForExistence(timeout: 10))
        app.swipeUp()
        sleep(3)
        app.swipeDown()
        app.swipeDown()
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.buttons["PictureLikeButton"].tap()
        sleep(3)
        cell.buttons["PictureLikeButton"].tap()
        sleep(3)
        cell.tap()
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 15))
        image.pinch(withScale: 3, velocity: 1)
        sleep(2)
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(2)
        app.buttons["SingleImageBackButton"].tap()
        sleep(2)
        
    }
    
    func testProfile() throws {
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(5)
        app.buttons["ProfileLogOutButton"].tap()
        sleep(3)
        app.buttons["Authenticate"].tap()
        sleep(3)
    }
}
