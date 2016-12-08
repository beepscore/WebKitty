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
        //let webViewResourcesSubdirectory = "webViewResources"
        let actual = fileUtils!.fileNamesAtBundleResourcePath().count
        XCTAssertTrue(actual >= 109)
        XCTAssertTrue(actual <= 112)
    }

    func testFileNamesAtURL() {
        // compare sets instead of arrays to make test independent of element order
        // example
        XCTAssertEqual(Set([1,2]), Set([2,1]))

        //let webViewResourcesSubdirectory = "webViewResources"
        let expectedFileNamesSimulator = Set([
            "_CodeSignature",
            "Base.lproj",
            "Frameworks",
            "index.html",
            "Info.plist",
            "libswiftRemoteMirror.dylib",
            "PkgInfo",
            "PlugIns",
            "style.css",
            "WebKitty"
            ])

        let expectedFileNamesDevice = Set([
            "_CodeSignature",
            "Base.lproj",
            "Frameworks",
            "index.html",
            "Info.plist",
            "libswiftRemoteMirror.dylib",
            "META-INF",
            "embedded.mobileprovision",
            "PkgInfo",
            "PlugIns",
            "style.css",
            "WebKitty"
        ])

        let fileNames =  Set(fileUtils!.fileNamesAtURL())

        // TODO: consider determine if test is running on device or simulator, then expect
        XCTAssertTrue(fileNames.count >= 10 && fileNames.count <= 12)
        XCTAssertTrue((fileNames == expectedFileNamesSimulator)
            || (fileNames == expectedFileNamesDevice))
    }

    func testFileNamesWithExtensionHtml() {
        let expected = ["index.html"]
        //let webViewResourcesSubdirectory = "webViewResources"
        XCTAssertEqual(expected, fileUtils!.fileNamesWithExtensionHtml())
    }
}
