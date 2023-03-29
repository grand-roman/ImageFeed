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
           
           XCTAssertTrue(webView.waitForExistence(timeout: 5))

           let loginTextField = webView.descendants(matching: .textField).element
           XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
           
           loginTextField.tap()
           loginTextField.typeText("Your login")
           webView.swipeUp()
           
           let passwordTextField = webView.descendants(matching: .secureTextField).element
           XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
           
           passwordTextField.tap()
           passwordTextField.typeText("Your pass")
           webView.swipeUp()
           
           webView.buttons["Login"].tap()
           
           let tablesQuery = app.tables
           let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
           
           XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
    }
    
    func testFeed() throws {
        
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["NotActiveLikeButton"].tap()
        cellToLike.buttons["ActiveLikeButton"].tap()
        
        sleep(2)
        
        cellToLike.tap()
           
        sleep(2)
           
        let image = app.scrollViews.images.element(boundBy: 0)
           
        image.pinch(withScale: 3, velocity: 1) // zoom in
           
        image.pinch(withScale: 0.5, velocity: -1)
           
        let navBackButtonWhiteButton = app.buttons["BackButton"]
           navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        
        sleep(3)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Your name"].exists)
        XCTAssertTrue(app.staticTexts["@username"].exists)
        
        app.buttons["ProfileExitImage"].tap()
        
        app.alerts["Выход из профиля"].scrollViews.otherElements.buttons["Да"].tap()
    }
}

