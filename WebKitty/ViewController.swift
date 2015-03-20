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
        //view.setNeedsLayout()
    }

    // viewDidLayoutSubviews gets called upon rotation
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLog("viewDidLayoutSubviews")
        loadExample()
    }

    func constrainWebView() {
        // http://code.tutsplus.com/tutorials/introduction-to-the-visual-format-language--cms-22715
        // http://stackoverflow.com/questions/27494542/when-can-i-activate-deactivate-layout-constraints
        // http://stackoverflow.com/questions/28521590/size-uiview-to-uiviewcontrollers-view-programmatically
        // http://makeapppie.com/2014/07/26/the-swift-swift-tutorial-how-to-use-uiviews-with-auto-layout-programmatically/

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

}

