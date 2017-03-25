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
    var webView: WKWebView!

    // MARK: - view lifecycle

    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()

        configureWebView()
        constrainWebView()

        //loadRequest()

        loadLocalFile(fileName: "index", fileType: "html")
    }

    // viewDidLayoutSubviews gets called upon rotation
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - layout

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

    // MARK: - communicate between app and WKWebView

    /// adds user script to communicate from app to web page
    /// adds user script to communicate from web page to app
    func configureWebView() {

        let userContentController = WKUserContentController()

        // MARK: Communicate from app to web page
        // addUserScript() dynamically injects javascript from native Swift app into web page in the WKWebView.
        // App can use addUserScript() to customize any web page!
        // http://nshipster.com/wkwebkit/
        userContentController.addUserScript(ViewController.userScriptBackgroundColor())

        // MARK: Communicate from web page to app
        // To send a message, web page must contain javascript with one or more calls to postMessage().
        // Original web page author can write the javascript, or
        // Swift app can use addUserScript to inject javascript into any web page.
        userContentController.addUserScript(ViewController.userScriptPostMessage())

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

    /**
     Typically app calls userContentController.addUserScript(userScriptBackgroundColor())
     - returns: script to set web page background color. This overrides setting in style.css
     */
    class func userScriptBackgroundColor() -> WKUserScript {
        let paleBlueColor = "\"#CCF\""
        let userScriptSource = "document.body.style.background = \(paleBlueColor);"
        let userScript = WKUserScript(source: userScriptSource,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true)
        return userScript
    }

    /**
     Typically app calls userContentController.addUserScript(userScriptPostMessage())
     - returns: script to call postMessage so web page will send message to app
     */
    class func userScriptPostMessage() -> WKUserScript {
        let userScriptSource = "window.webkit.messageHandlers.notification.postMessage({body: \"Hi from javascript\"});"
        let userScript = WKUserScript(source: userScriptSource,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true)
        return userScript
    }

    // MARK: - load urls into web page

    /// creates a request for a remote url and loads it
    func loadRequest() {
        // http://stackoverflow.com/questions/24410473/how-to-convert-this-var-string-to-nsurl-in-swift?rq=1
        guard let url = URL(string: "http://www.beepscore.com") else { return }
        let request = URLRequest(url:url)
        webView.load(request)
    }

    /// Loads local file from main bundle using loadFileURL
    /// Note: In iOS 8 WKWebView loadRequest couldn't load a local file directly,
    /// had to use webView.loadHTMLString.
    ///
    /// - Parameters:
    ///   - fileName: file name to load, e.g. "index"
    ///   - fileType: may start with a period or not e.g. ".html" or "html"
    func loadLocalFile (fileName: String, fileType: String) {

        guard let url = Bundle.main.url(forResource: fileName,
                                        withExtension: fileType) else { return }

        // guard let cssUrl = Bundle.main.url(forResource: "style",
        //                                  withExtension: "css") else { return }

        // guard let cssUrl2 = Bundle.main.url(forResource: "style",
        //                                   withExtension: "css",
        //                                    subdirectory: nil) else { return }

        // get url for directory instead of for just one file
        // http://stackoverflow.com/questions/40692737/how-to-get-path-to-a-subfolder-in-main-bundle
        guard let resourcePath = Bundle.main.resourcePath else { return }
        
        let webResourcesDirUrl = URL(fileURLWithPath:resourcePath)
            .appendingPathComponent("webResources")
        
        // http://stackoverflow.com/questions/24882834/wkwebview-not-loading-local-files-under-ios-8?rq=1
        webView.loadFileURL(url, allowingReadAccessTo: webResourcesDirUrl)
    }
    
}

