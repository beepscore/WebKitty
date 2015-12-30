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
        print("viewDidLoad")
        super.viewDidLoad()

        configureWebView()
        constrainWebView()

        //loadExample()

        //loadLocalFile("index", fileType: "html")

        if let htmlTempUrl = duplicateFilesToTempDir() {
            let request = NSURLRequest(URL: htmlTempUrl)
            self.webView.loadRequest(request)
        }
    }

    // viewDidLayoutSubviews gets called upon rotation
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
    }

    func configureWebView() {

        // http://nshipster.com/wkwebkit/

        let userContentController = WKUserContentController()

        // Communicate from app to web page
        // addUserScript can dynamically inject javascript
        // from native Swift app into any web page in the WKWebView
        // App can use this to customize any web page!

        // inject javascript to set web page background color
        // this overrides setting in style.css
        let paleBlueColor = "\"#CCF\""
        let colorScriptSource = "document.body.style.background = \(paleBlueColor);"
        let colorScript = WKUserScript(source: colorScriptSource,
            injectionTime: .AtDocumentEnd,
            forMainFrameOnly: true)
        userContentController.addUserScript(colorScript)

        // inject javascript so web page will send message to app
        let messageScriptSource = "window.webkit.messageHandlers.notification.postMessage({body: \"Hi from javascript\"});"
        let messageScript = WKUserScript(source: messageScriptSource,
            injectionTime: .AtDocumentEnd,
            forMainFrameOnly: true)
        userContentController.addUserScript(messageScript)

        // Communicate from web page to app
        // Register handler to get messages from WKWebView javascript into native Swift app.
        // To send message, web page javascript must contain corresponding postMessage statement.
        // Web page author can write postMessage statements for use by WKWebView
        // Alternatively, app can use addUserScript to inject postMessage statements into any web page.
        let webScriptMessageHandler = WebScriptMessageHandler()
        userContentController.addScriptMessageHandler(webScriptMessageHandler,
            name: "notification")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // on device to see webView background pinch view to zoom out
        webView.backgroundColor = UIColor.yellowColor()
        webView.scrollView.backgroundColor = UIColor.redColor()
        
        view.addSubview(webView);
    }
    
    func constrainWebView() {
        // http://code.tutsplus.com/tutorials/introduction-to-the-visual-format-language--cms-22715

        let viewDict = Dictionary(dictionaryLiteral:("view", view), ("webView", webView))

        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewDict)
        NSLayoutConstraint.activateConstraints(horizontalConstraints)

        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewDict)
        NSLayoutConstraint.activateConstraints(verticalConstraints)

        printConstraints()
    }

    func printConstraints() {
        print("view.constraints().count \(view.constraints.count)")
        for constraint in view.constraints {
            print("\(constraint.debugDescription)")
        }
        print("")
        print("webView.constraints().count \(webView.constraints.count)")
        print("")
    }

    func duplicateFilesToTempDir() -> NSURL? {
        let cssUrl = NSBundle.mainBundle().URLForResource("style", withExtension: "css")
        FileUtils.duplicateFileToTempDir(cssUrl)

        let htmlUrl = NSBundle.mainBundle().URLForResource("index", withExtension: "html")
        let htmlTempUrl = FileUtils.duplicateFileToTempDir(htmlUrl)
        return htmlTempUrl
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    func loadExample() {
        // http://stackoverflow.com/questions/24410473/how-to-convert-this-var-string-to-nsurl-in-swift?rq=1
        let url = NSURL(string: "http://www.beepscore.com")
        let request = NSURLRequest(URL:url!)
        webView.loadRequest(request)
    }
    */

    /**
    @param fileType may start with a period or not e.g. ".html" or "html"
    */
    /*
    func loadLocalFile (fileName: String, fileType: String) {
        if let url = NSBundle.mainBundle().URLForResource(fileName, withExtension: fileType) {
            // currently WKWebView loadRequest can't load local file directly
            // error Could not create a sandbox extension for '/'
            // let request = NSURLRequest(URL:url)
            // webView.loadRequest(request!)
            
            // workaround: use loadHTMLString instead of loadRequest
            // http://stackoverflow.com/questions/27803341/swift-wkwebview-loading-local-file-not-working-on-a-device
            // index.html references index.css but unfortunately webView doesn't find or use index.css
            loadFileAtUrlAndHandleError(url)
        } else {
            println("url nil")
        }
    }
    */

    /*
    func loadFileAtUrlAndHandleError(url: NSURL) {
        // http://stackoverflow.com/questions/24176383/swift-programming-nserrorpointer-error-etc
        var error : NSError?
        var fileString = String(contentsOfURL:url,
            encoding: NSUTF8StringEncoding,
            error: &error)
        if let actualError = error {
            println("error : \(actualError)")
        } else {
            if let actualFileString = fileString {
                webView.loadHTMLString(actualFileString, baseURL: url)
            } else {
                println("fileString nil")
            }
        }
    }
    */

}

