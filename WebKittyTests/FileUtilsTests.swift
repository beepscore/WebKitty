//
//  FileUtilsTests.swift
//  WebKittyTests
//
//  Created by Steve Baker on 3/19/15.
//  Copyright (c) 2015 Beepscore LLC. All rights reserved.
//

import XCTest
@testable import WebKitty

class FileUtilsTests: XCTestCase {

    // swift will initialize this instance variable for each test, don't need separate "setUp" method
    let fileUtils = FileUtils()

    func testFileNamesAtBundleResourcePath() {
        //let webViewResourcesSubdirectory = "webViewResources"
        let actual = fileUtils.fileNamesAtBundleResourcePath().count

        // -D IOS_SIMULATOR defined in project build settings / custom flags / any iOS simulator / Debug
        // http://stackoverflow.com/questions/24869481/detect-if-app-is-being-built-for-device-or-simulator-in-swift#24869607
        #if IOS_SIMULATOR
            XCTAssertTrue(actual >= 107)
            XCTAssertTrue(actual <= 110)
        #else
            XCTAssertEqual(actual, 112)
        #endif
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

        let fileNames =  Set(fileUtils.fileNamesAtURL())

        #if IOS_SIMULATOR
            XCTAssertTrue(fileNames == expectedFileNamesSimulator)
        #else
            XCTAssertTrue(fileNames == expectedFileNamesDevice)
        #endif

    }

    func testFileNamesWithExtensionHtml() {
        let expected = ["index.html"]
        //let webViewResourcesSubdirectory = "webViewResources"
        XCTAssertEqual(expected, fileUtils.fileNamesWithExtensionHtml())
    }
}
