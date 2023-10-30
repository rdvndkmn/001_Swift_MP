//
//  MP_DocumentCreateUITests.swift
//  MP_DocumentCreateUITests
//
//  Created by Rıdvan Dikmen on 11.10.2023.
//

import XCTest

final class MP_DocumentCreateUITests: XCTestCase {

    func testDocumentApp() throws {
        
        let app = XCUIApplication()
        app.launch()
        let emailTextField = app.textFields["Email"]
        let passwordTextField = app.textFields["Password"]
        let siginButton = app.buttons["SignIn"]
        let singupButton = app.buttons["SignUp"]
        let navigationBarsQuery = app.navigationBars
        let addButton = navigationBarsQuery.buttons["Add"]
        let documentNameTextField = app.textFields["Document Name"]
        let documentCommentTextField = app.textFields["Document Comment"]
        let savebutton = navigationBarsQuery.buttons["Save"]
        let logoutButton = navigationBarsQuery.buttons["LogOut"]
        let backButton = navigationBarsQuery.buttons["Back"]
        let tablesQuery = app.tables
        
        let api = tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Patricia Lebsack")/*[[".cells.containing(.staticText, identifier:\"Karianne\")",".cells.containing(.staticText, identifier:\"Patricia Lebsack\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 0)
        let feed = tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"10/30/2023, 10:03 PM")/*[[".cells.containing(.staticText, identifier:\"Deneme\")",".cells.containing(.staticText, identifier:\"10\/30\/2023, 10:03 PM\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 0)
        
        //logoutButton.tap()
        emailTextField.tap()
        emailTextField.typeText("r@gmail.com")
        passwordTextField.tap()
        passwordTextField.typeText("123456")
        singupButton.tap()
        addButton.tap()
        documentNameTextField.tap()
        documentNameTextField.typeText("Deneme")
        documentCommentTextField.tap()
        documentCommentTextField.typeText("Deneme")
        api.tap()
        feed.tap()
        
        

    }

}
