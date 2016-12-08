//
//  FileUtilsTests.swift
//  WebKittyTests
//
//  Created by Steve Baker on 3/19/15.
//  Copyright (c) 2015 Beepscore LLC. All rights reserved.
//

import XCTest

class FileUtilsTests: XCTestCase {

    var fileUtils: FileUtils?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fileUtils = FileUtils()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFileNamesAtBundleResourcePath() {
        let expected = 110
        //let webViewResourcesSubdirectory = "webViewResources"
        XCTAssertEqual(expected, fileUtils!.fileNamesAtBundleResourcePath().count)
    }

    func testFileNamesAtURL() {
        let expected = 110
        //let webViewResourcesSubdirectory = "webViewResources"
        XCTAssertEqual(expected, fileUtils!.fileNamesAtBundleResourcePath().count)
    }

    func testFileNamesWithExtensionHtml() {
        let expected = ["index.html"]
        //let webViewResourcesSubdirectory = "webViewResources"
        XCTAssertEqual(expected, fileUtils!.fileNamesWithExtensionHtml())
    }
}
