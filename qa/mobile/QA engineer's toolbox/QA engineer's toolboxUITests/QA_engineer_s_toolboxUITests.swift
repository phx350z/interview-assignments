//
//  QA_engineer_s_toolboxUITests.swift
//  QA engineer's toolboxUITests
//
//  Created by shixin on 2021/9/20.
//

import XCTest

class QA_engineer_s_toolboxUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasicDisplay() throws {
        // 校验页面基本元素是否都展现
        app.launch()
        let titleText = app.staticTexts["QA Engineer's Toolbox Arsenal:"]
        let nameTextField = app.textFields["Please enter Engineer's name"]
        let submitButton = app.buttons["Submit"]
        let E2EButton = app.buttons["E2E"]
        let HCButton = app.buttons["Headless Chrome"]
        let JestButton = app/*@START_MENU_TOKEN@*/.buttons["Jest"]/*[[".segmentedControls.buttons[\"Jest\"]",".buttons[\"Jest\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let SeleniumButton = app/*@START_MENU_TOKEN@*/.buttons["Selenium"]/*[[".segmentedControls.buttons[\"Selenium\"]",".buttons[\"Selenium\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        XCTAssert(titleText.exists)
        XCTAssert(nameTextField.exists)
        XCTAssert(submitButton.exists)
        XCTAssert(E2EButton.isSelected)
        XCTAssert(HCButton.exists)
        XCTAssert(JestButton.exists)
        XCTAssert(SeleniumButton.exists)
    }
    
    func testEmptySubmitDisable() throws {
        // 校验name输入框为空时，submit按钮是否置灰
        app.launch()
        let submitButton = app.buttons["Submit"]
        XCTAssertFalse(submitButton.isEnabled)
    }
    
    
    func testSubmitBy4Types() throws {
        // 校验输入name之后提交，是否可以提交成功
        app.launch()
        let nameTextField = app.textFields["Please enter Engineer's name"]
        let submitButton = app.buttons["Submit"]
        let E2EButton = app.buttons["E2E"]
        let HCButton = app.buttons["Headless Chrome"]
        let JestButton = app.buttons["Jest"]
        let SeleniumButton = app/*@START_MENU_TOKEN@*/.buttons["Selenium"]/*[[".segmentedControls.buttons[\"Selenium\"]",".buttons[\"Selenium\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    
        //校验e2e
        XCTAssert(nameTextField.isEnabled)
        nameTextField.tap()
        var ts: String = String(NSDate().timeIntervalSince1970)
        nameTextField.typeText(ts)
        XCTAssertEqual(nameTextField.value as! String, ts)
        app.keyboards.buttons["return"].tap()
        submitButton.tap()
        XCTAssert(app.tables.containing(.cell, identifier: ts + ", :, E2E").element.exists)

        //校验headless chrome
        HCButton.tap()
        XCTAssert(HCButton.isSelected)
        nameTextField.tap()
        var deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: ts.count)
        nameTextField.typeText(deleteString)
        ts = String(NSDate().timeIntervalSince1970)
        nameTextField.typeText(ts)
        XCTAssertEqual(nameTextField.value as! String, ts)
        app.keyboards.buttons["return"].tap()
        submitButton.tap()
        XCTAssert(app.tables.containing(.cell, identifier: ts + ", :, Headless Chrome").element.exists)
        
        //校验jest
        JestButton.tap()
        XCTAssert(JestButton.isSelected)
        nameTextField.tap()
        deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: ts.count)
        nameTextField.typeText(deleteString)
        ts = String(NSDate().timeIntervalSince1970)
        nameTextField.typeText(ts)
        XCTAssertEqual(nameTextField.value as! String, ts)
        app.keyboards.buttons["return"].tap()
        submitButton.tap()
        XCTAssert(app.tables.containing(.cell, identifier: ts + ", :, Jest").element.exists)
        
        //校验selenium
        SeleniumButton.tap()
        XCTAssert(SeleniumButton.isSelected)
        nameTextField.tap()
        deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: ts.count)
        nameTextField.typeText(deleteString)
        ts = String(NSDate().timeIntervalSince1970)
        nameTextField.typeText(ts)
        XCTAssertEqual(nameTextField.value as! String, ts)
        app.keyboards.buttons["return"].tap()
        submitButton.tap()
        XCTAssert(app.tables.containing(.cell, identifier: ts + ", :, Selenium").element.exists)
        
        //由于e2e之前是默认选中，没有手动点击过，需要点击e2e进行校验
        E2EButton.tap()
        nameTextField.tap()
        deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: ts.count)
        nameTextField.typeText(deleteString)
        ts = String(NSDate().timeIntervalSince1970)
        nameTextField.typeText(ts)
        XCTAssertEqual(nameTextField.value as! String, ts)
        app.keyboards.buttons["return"].tap()
        submitButton.tap()
        XCTAssert(app.tables.containing(.cell, identifier: ts + ", :, E2E").element.exists)
    }

    func testDuplicateName() throws {
        
        app.launch()
        let nameTextField = app.textFields["Please enter Engineer's name"]
        let submitButton = app.buttons["Submit"]
        let JestButton = app.buttons["Jest"]

        //校验e2e
        nameTextField.tap()
        let ts: String = String(NSDate().timeIntervalSince1970)
        nameTextField.typeText(ts)
        app.keyboards.buttons["return"].tap()
        
        submitButton.tap()
        XCTAssert(app.tables.containing(.cell, identifier: ts + ", :, E2E").element.exists)

        //再次提交重复内容
        submitButton.tap()
        // 校验table最后两行内容是否重复
        let table = app.tables.element
        let lastCell = table.cells.element(boundBy: 0)
        let last2ndCell = table.cells.element(boundBy: 1)
        XCTAssertNotEqual(lastCell.staticTexts.allElementsBoundByIndex[0].label, last2ndCell.staticTexts.allElementsBoundByIndex[0].label)

        
        //切换类型，再次提交重复内容
        JestButton.tap()
        submitButton.tap()
        //校验列表不可以重复提交相同name，即使type不同
        XCTAssertFalse(app.tables.containing(.cell, identifier: ts + ", :, Jest").element.exists)
    }
    
    func testComlicatedText() throws {
        
        app.launch()
        let nameTextField = app.textFields["Please enter Engineer's name"]
        let submitButton = app.buttons["Submit"]

        //校验长文字及编码
        nameTextField.tap()
        let ts: String = String(NSDate().timeIntervalSince1970)
        let txt = ts +  "longlonglonglong中文繁体细雨ひらがなلغة عربيةáéíóúýñÑïüÜ¿¡😊"
        nameTextField.typeText(txt)
        app.keyboards.buttons["return"].tap()
        submitButton.tap()
        XCTAssert(app.tables.containing(.cell, identifier: txt + ", :, E2E").element.exists)
    }
    
    func testSaftyInput() throws {
        app.launch()
        let nameTextField = app.textFields["Please enter Engineer's name"]
        let submitButton = app.buttons["Submit"]

        //校验sql注入
        nameTextField.tap()
        let ts: String = String(NSDate().timeIntervalSince1970)
        let sql = "or 1=1 or " + ts
        nameTextField.typeText(sql)
        app.keyboards.buttons["return"].tap()
        submitButton.tap()
        XCTAssert(app.tables.containing(.cell, identifier: sql + ", :, E2E").element.exists)
        
        //校验swift语法注入
        nameTextField.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: sql.count)
        nameTextField.typeText(deleteString)
        let swift = "let alert = UIAlertView();alert.show("+ts+")"
        nameTextField.typeText(swift)
        app.keyboards.buttons["return"].tap()
        submitButton.tap()
        XCTAssert(app.tables.containing(.cell, identifier: swift + ", :, E2E").element.exists)
    }
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
