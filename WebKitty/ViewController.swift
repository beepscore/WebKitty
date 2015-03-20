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
//    @IBOutlet var webView: WKWebView!
    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView = UIWebView(frame:self.view.frame)
//        self.webView = WKWebView(frame:self.view.frame)
        self.webView.backgroundColor = UIColor.yellowColor()
        
        self.view.addSubview(self.webView);
        self.webView.setTranslatesAutoresizingMaskIntoConstraints(false)

        //self.view.setNeedsLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.constrainWebView()
    }

    func constrainWebView() {
        // http://stackoverflow.com/questions/27494542/when-can-i-activate-deactivate-layout-constraints
        // http://stackoverflow.com/questions/28521590/size-uiview-to-uiviewcontrollers-view-programmatically
        // http://makeapppie.com/2014/07/26/the-swift-swift-tutorial-how-to-use-uiviews-with-auto-layout-programmatically/

        let bottomConstraint = NSLayoutConstraint(item:self.webView,
            attribute:.Bottom,
            relatedBy:.Equal,
            toItem:self.view,
            attribute:.Bottom,
            multiplier: 1.0,
            constant: 0.0)
        
        let topConstraint = NSLayoutConstraint(item:self.webView,
            attribute:.Top,
            relatedBy:.Equal,
            toItem:self.view,
            attribute:.Top,
            multiplier: 1.0,
            constant: 0.0)
        
        let rightConstraint = NSLayoutConstraint(item:self.webView,
            attribute:.Right,
            relatedBy:.Equal,
            toItem:self.view,
            attribute:.Right,
            multiplier: 1.0,
            constant: 0.0)
        
        let leftConstraint = NSLayoutConstraint(item:self.webView,
            attribute:.Left,
            relatedBy:.Equal,
            toItem:self.view,
            attribute:.Left,
            multiplier: 1.0,
            constant: 0.0)

        let widthConstraint = NSLayoutConstraint(item:self.webView,
            attribute:.Width,
            relatedBy:.Equal,
            toItem:self.view,
            attribute:.Width,
            multiplier: 1.0,
            constant: 0.0)


        // TODO: fix bug rotate to landscape right margin
//        widthConstraint.priority = 400
//        NSLayoutConstraint.activateConstraints([bottomConstraint, topConstraint,
//            leftConstraint, rightConstraint])
//        NSLayoutConstraint.activateConstraints([topConstraint, bottomConstraint, widthConstraint])
        NSLayoutConstraint.activateConstraints([topConstraint, bottomConstraint])

        self.view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

