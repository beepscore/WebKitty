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

    /**
     * If source file exists at destination, replaces it.
     * http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file
     */
    class func duplicateFileToTempDir(_ fileUrl: URL?) -> URL? {
        
        if fileUrl == nil {
            return nil
        }
        
        let fileMgr = FileManager.default
        let tempPath = NSTemporaryDirectory()
        let tempWwwUrl = URL(fileURLWithPath: tempPath).appendingPathComponent("www")
        do {
            try fileMgr.createDirectory(at: tempWwwUrl, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Error createDirectoryAtURL at \(tempWwwUrl)")
            print(error.debugDescription)
            return nil
        }
        
        let pathComponent = fileUrl!.lastPathComponent
        let destinationUrl = tempWwwUrl.appendingPathComponent(pathComponent)
        let _ = deleteFileAtUrl(destinationUrl)
        
        do {
            try fileMgr.copyItem(at: fileUrl!, to: destinationUrl)
        } catch let error as NSError {
            print("copyItemAtURL error \(error.localizedDescription)")
            return nil
        }
        return destinationUrl
    }

    /** If file exists, deletes it.
    return true if fileUrl was nil or file didn't exist or file was deleted
    return false if file existed but couldn't delete it
    */
    class func deleteFileAtUrl(_ fileUrl : URL?) -> Bool {
        let fileMgr = FileManager.default
        
        if let url = fileUrl {
            if fileMgr.fileExists(atPath: url.path) {

                do {
                    try fileMgr.removeItem(at: url)
                    return true
                } catch let error as NSError {
                    print("Error removeItemAtURL at \(url)")
                    print(error.debugDescription)
                    return false
                }

            } else {
                // file doesn't exist
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

        let bundle = Bundle.main

        // let bundlePath = bundle.bundlePath
        // let sourcePath = resourcePath!.stringByAppendingPathComponent(subpath!)
        let resourcePath = bundle.resourcePath

        let fileManager = FileManager()

        // this returns empty
        // if let enumerator: NSDirectoryEnumerator = fileManager.enumeratorAtPath(sourcePath) {

        // this returns many files, could filter by file extension
        if let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: resourcePath!) {

            for element in enumerator.allObjects {
                fileNames.append(element as! String)
            }
        }
        return fileNames
    }

    func fileNamesAtURL() -> [String] {
        
        let bundle = Bundle.main

        guard let resourcePath = bundle.resourcePath else {
            return []
        }
        var urlComponents = URLComponents()
        urlComponents.scheme = "file"
        urlComponents.host = ""
        urlComponents.path = resourcePath
        let resourceURL = urlComponents.url

        let fileManager = FileManager()
        
        var lastPathComponents : [String] = []
        if let enumerator = fileManager.enumerator(at: resourceURL!,
                                                   includingPropertiesForKeys: nil,
                                                   options: .skipsSubdirectoryDescendants,
                                                   errorHandler: nil) {
                
                for element in enumerator.allObjects {
                    lastPathComponents.append((element as! URL).lastPathComponent)
                }
        }
        return lastPathComponents
    }
    
    func fileNamesWithExtensionHtml() -> [String] {
        
        let bundle = Bundle.main
        let urls = bundle.urls(forResourcesWithExtension: "html", subdirectory: "")
        
        var lastPathComponents : [String] = []
        for url in urls! {
            lastPathComponents.append(url.lastPathComponent)
        }
        return lastPathComponents
    }
}
