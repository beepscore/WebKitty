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

    // ! implies variable is optional, force unwrapped
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
            let request = URLRequest(url: htmlTempUrl)
            self.webView.load(request)
        }
    }

    // viewDidLayoutSubviews gets called upon rotation
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
    }

    func configureWebView() {

        let userContentController = WKUserContentController()

        // http://nshipster.com/wkwebkit/

        // MARK: Communicate from app to web page
        addUserScriptBackgroundColor(userContentController: userContentController)

        // MARK: Communicate from web page to app
        // To send a message, web page must contain javascript with one or more calls to postMessage().
        // Original web page author can write the javascript, or
        // Swift app can use addUserScript to inject javascript into any web page.
        addUserScriptMessage(userContentController: userContentController)

        // Register handler to get messages from WKWebView javascript into native Swift app.
        let webScriptMessageHandler = WebScriptMessageHandler()
        userContentController.add(webScriptMessageHandler, name: "notification")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController

        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false

        // on device to see webView background pinch view to zoom out
        webView.backgroundColor = UIColor.yellow
        webView.scrollView.backgroundColor = UIColor.red

        view.addSubview(webView);
    }

    /** Add javascript with call to postMessage to web page so web page will send message to app
     Dynamically injects javascript from native Swift app into web page in the WKWebView.
     */
    func addUserScriptMessage(userContentController: WKUserContentController) {
        let messageScriptSource = "window.webkit.messageHandlers.notification.postMessage({body: \"Hi from javascript\"});"
        let messageScript = WKUserScript(source: messageScriptSource,
                                         injectionTime: .atDocumentEnd,
                                         forMainFrameOnly: true)
        userContentController.addUserScript(messageScript)
    }

    /** Sets web page background color. This overrides setting in style.css
     Dynamically injects javascript from native Swift app into web page in the WKWebView.
     App can use addUserScript() to customize any web page!
     */
    func addUserScriptBackgroundColor(userContentController: WKUserContentController) {
        let paleBlueColor = "\"#CCF\""
        let colorScriptSource = "document.body.style.background = \(paleBlueColor);"
        let colorScript = WKUserScript(source: colorScriptSource,
                                       injectionTime: .atDocumentEnd,
                                       forMainFrameOnly: true)
        userContentController.addUserScript(colorScript)
    }

    func constrainWebView() {
        // http://code.tutsplus.com/tutorials/introduction-to-the-visual-format-language--cms-22715

        let viewDict: [String: UIView] = Dictionary(dictionaryLiteral:("view", view), ("webView", webView))

        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewDict)
        NSLayoutConstraint.activate(horizontalConstraints)

        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewDict)
        NSLayoutConstraint.activate(verticalConstraints)

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

    func duplicateFilesToTempDir() -> URL? {
        let cssUrl = Bundle.main.url(forResource: "style", withExtension: "css")
        let _ = FileUtils.duplicateFileToTempDir(cssUrl)

        let htmlUrl = Bundle.main.url(forResource: "index", withExtension: "html")
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

