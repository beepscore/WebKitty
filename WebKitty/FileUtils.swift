//
//  FileUtils.swift
//  WebKitty
//
//  Created by Steve Baker on 4/22/15.
//  Copyright (c) 2015 Beepscore LLC. All rights reserved.
//

import Foundation

class FileUtils: NSObject {

    func fileNamesAtBundleResourcePath() -> [String] {
        // Returns list of all files in bundle resource path
        // NOTE:
        // I tried writing a function to enumerate the contents of a subdirectory
        // such as webViewResources
        // func fileNamesInSubdirectory(subpath: String?) -> [String]
        // It didn't work.
        // Apparently the bundle contains many files at the same heirarchical level,
        // doesn't keep index.html and style.css in a subdirectory
        // http://stackoverflow.com/questions/25285016/swift-iterate-through-files-in-a-folder-and-its-subfolders?lq=1

        var fileNames : [String] = []

        let bundle = NSBundle.mainBundle()

        // let bundlePath = bundle.bundlePath
        // let sourcePath = resourcePath!.stringByAppendingPathComponent(subpath!)
        let resourcePath = bundle.resourcePath

        let fileManager = NSFileManager()

        // this returns empty
        // if let enumerator: NSDirectoryEnumerator = fileManager.enumeratorAtPath(sourcePath) {

        // this returns many files, could filter by file extension
        if let enumerator: NSDirectoryEnumerator = fileManager.enumeratorAtPath(resourcePath!) {

            for element in enumerator.allObjects {
                fileNames.append(element as! String)
            }
        }
        return fileNames
    }

    func fileNamesAtURL() -> [String] {
        
        let bundle = NSBundle.mainBundle()
        
        let resourcePath = bundle.resourcePath
        let resourceURL = NSURL.init(scheme:"file", host: "", path: resourcePath!)
        
        let fileManager = NSFileManager()
        
        var lastPathComponents : [String] = []
        if let enumerator = fileManager.enumeratorAtURL(resourceURL!,
            includingPropertiesForKeys: nil, options: nil, errorHandler: nil) {
                
                for element in enumerator.allObjects {
                    lastPathComponents.append(element.lastPathComponent)
                }
        }
        return lastPathComponents
    }
    
    func fileNamesWithExtensionHtml() -> [String] {
        
        let bundle = NSBundle.mainBundle()
        let resourcePath = bundle.resourcePath
        let urls = bundle.URLsForResourcesWithExtension("html", subdirectory: "")
        
        var lastPathComponents : [String] = []
        for url in urls! {
            lastPathComponents.append(url.lastPathComponent)
        }
        return lastPathComponents
    }
}