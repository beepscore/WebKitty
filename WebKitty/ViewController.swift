//
//  ViewController.swift
//  WebKitty
//
//  Created by Steve Baker on 3/19/15.
//  Copyright (c) 2015 Beepscore LLC. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    // ! implies variables are optional, implicitly unwrapped
    // app will crash if they aren't set before use
    // changing type from UIWebView to WKWebView affects layout result!!
    // @IBOutlet var webView: UIWebView!
    var webView: WKWebView!

    override func viewDidLoad() {
        NSLog("viewDidLoad")
        super.viewDidLoad()

        view.backgroundColor = UIColor.blueColor()

        // let configuration = WKWebViewConfiguration()
        // webView = WKWebView(frame:view.frame, configuration:configuration)
        // init with default configuration
        webView = WKWebView(frame:view.frame)
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        webView.backgroundColor = UIColor.yellowColor()
        webView.scrollView.backgroundColor = UIColor.redColor()
        view.addSubview(webView);

        constrainWebView()

        //loadExample()
        //loadLocalFile("index", fileType: "html")

        // duplicateSourceFilesToTempDir
        var htmlPath = NSBundle.mainBundle().pathForResource("index", ofType: "html")
        var htmlTempPath = duplicateSourceToTempDir(htmlPath)

        var cssPath = NSBundle.mainBundle().pathForResource("style", ofType: "css")
        var cssTempPath = duplicateSourceToTempDir(cssPath)

        let request = NSURLRequest(URL: NSURL.fileURLWithPath(htmlTempPath!)!)
        self.webView.loadRequest(request)
    }

    // viewDidLayoutSubviews gets called upon rotation
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLog("viewDidLayoutSubviews")
    }

    func constrainWebView() {
        // http://code.tutsplus.com/tutorials/introduction-to-the-visual-format-language--cms-22715

        //let viewDict: [NSObject : AnyObject] = ["view": view, "webView": webView]
        let viewDict = Dictionary(dictionaryLiteral:("view", view), ("webView", webView))

        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|",
            options: NSLayoutFormatOptions(0),
            metrics: nil,
            views: viewDict)
        NSLayoutConstraint.activateConstraints(horizontalConstraints)

        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|",
            options: NSLayoutFormatOptions(0),
            metrics: nil,
            views: viewDict)
        NSLayoutConstraint.activateConstraints(verticalConstraints)

        // when set active the constraint is added to the parent view constraints()
        // however the argument order for parameters item and toItem does affect the constraint description
//        let topConstraint = NSLayoutConstraint(item:webView,
//            attribute:NSLayoutAttribute.Top,
//            relatedBy:NSLayoutRelation.Equal,
//            toItem:view,
//            attribute:NSLayoutAttribute.Top,
//            multiplier: 1.0,
//            constant: 0.0)
//        topConstraint.active = true

        logConstraints()
    }

    func logConstraints() {
        NSLog("%d view.constraints() %@", view.constraints().count, view.constraints().debugDescription)
        NSLog("")
        NSLog("%d webView.constraints() %@", webView.constraints().count, webView.constraints().debugDescription)
        NSLog("")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadExample () {
        // http://stackoverflow.com/questions/24410473/how-to-convert-this-var-string-to-nsurl-in-swift?rq=1
        let url = NSURL(string: "http://www.beepscore.com")
        let request = NSURLRequest(URL:url!)
        webView.loadRequest(request)
    }

    /**
    @param fileType may start with a period or not e.g. ".html" or "html"
    */
    func loadLocalFile (fileName: String, fileType: String) {
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType) {
            
            if let url = NSURL(fileURLWithPath:path) {
                // currently WKWebView loadRequest can't load local file directly
                // error Could not create a sandbox extension for '/'
                // let request = NSURLRequest(URL:url)
                // webView.loadRequest(request!)
                
                // workaround: use loadHTMLString instead of loadRequest
                // http://stackoverflow.com/questions/27803341/swift-wkwebview-loading-local-file-not-working-on-a-device
                // index.html references index.css but unfortunatley webView doesn't find or use index.css
                loadFileAtPathAndHandleError(path, url: url)

            } else {
                NSLog("url nil")
            }
        } else {
            NSLog("path nil")
        }
    }

    func loadFileAtPathAndHandleError (path: String, url: NSURL) {

        // http://stackoverflow.com/questions/24176383/swift-programming-nserrorpointer-error-etc
        var error : NSError?
        var fileString = String(contentsOfFile: path,
            encoding: NSUTF8StringEncoding,
            error: &error)
        if let actualError = error {
            NSLog("error : \(actualError)")
        } else {
            if let actualFileString = fileString {
                webView.loadHTMLString(actualFileString, baseURL: url)
            } else {
                NSLog("fileString nil")
            }
        }
    }

    func duplicateSourceToTempDir (filePath: String?) -> String? {
        // http://stackoverflow.com/questions/24882834/wkwebview-not-working-in-ios-8-beta-4?lq=1

        let fileMgr = NSFileManager.defaultManager()
        let tmpPath = NSTemporaryDirectory().stringByAppendingPathComponent("www")
        var error: NSErrorPointer = nil
        if !fileMgr.createDirectoryAtPath(tmpPath, withIntermediateDirectories: true,
            attributes: nil, error: error) {
                println("Couldn't create www subdirectory. \(error)")
                return nil
        }

        // TODO: Fixme. Overwrite files in tempDir, currently must delete app and reinstall it
        let dstPath = tmpPath.stringByAppendingPathComponent(filePath!.lastPathComponent)
        if !fileMgr.fileExistsAtPath(dstPath) {
            if !fileMgr.copyItemAtPath(filePath!, toPath: dstPath, error: error) {
                println("Couldn't copy file to /tmp/www. \(error)")
                return nil
            }
        }
        return dstPath
     }

}

