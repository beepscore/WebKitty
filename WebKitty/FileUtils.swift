//
//  FileUtils.swift
//  WebKitty
//
//  Created by Steve Baker on 4/22/15.
//  Copyright (c) 2015 Beepscore LLC. All rights reserved.
//
//  In general, Apple recommends references files via NSURL instead of NSString path.
//  For more info see Apple NSFileManager and NSURL class references.

import Foundation

class FileUtils: NSObject {

    /** If source file exists at destination, replaces it.
    return path to destination file
    return nil if method fails
    */
    class func duplicateSourceToTempDir(filePath: String?) -> String? {
        // http://stackoverflow.com/questions/24882834/wkwebview-not-working-in-ios-8-beta-4?lq=1
        
        let fileMgr = NSFileManager.defaultManager()
        let tmpPath = NSTemporaryDirectory().stringByAppendingPathComponent("www")
        var error: NSError?
        if !fileMgr.createDirectoryAtPath(tmpPath, withIntermediateDirectories: true,
            attributes: nil, error: &error) {
                println("Error createDirectoryAtPath at \(tmpPath)")
                println(error.debugDescription)
                return nil
        }
        
        let destinationPath = tmpPath.stringByAppendingPathComponent(filePath!.lastPathComponent)
        let destinationUrl = NSURL.fileURLWithPath(destinationPath)
        if (!deleteFileAtUrl(destinationUrl)) {
            return nil
        }
        
        if !fileMgr.copyItemAtPath(filePath!, toPath: destinationPath, error: &error) {
            println("Error copyItemAtPath to \(destinationPath)")
            println(error.debugDescription)
            return nil
        }
        return destinationPath
    }

    /** If file exists, deletes it.
    return true if fileUrl was nil or file didn't exist or file was deleted
    return false if file existed but couldn't delete it
    */
    class func deleteFileAtUrl(fileUrl : NSURL?) -> Bool {
        let fileMgr = NSFileManager.defaultManager()
        
        if let url = fileUrl {
            if let path = url.path {
                if fileMgr.fileExistsAtPath(path) {
                    var error: NSError?
                    if (!fileMgr.removeItemAtURL(url, error: &error)) {
                        println("Error removeItemAtURL at \(url)")
                        println(error.debugDescription)
                        return false
                    } else {
                        // deleted file
                        return true
                    }
                } else {
                    // file doesn't exist
                    return true
                }
            } else {
                // url.path nil
                return true
            }
        } else {
            // fileURL nil
            return true
        }
    }

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