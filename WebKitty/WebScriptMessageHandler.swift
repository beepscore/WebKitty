//
//  WebScriptMessageHandler.swift
//  WebKitty
//
//  Created by Steve Baker on 5/1/15.
//  Copyright (c) 2015 Beepscore LLC. All rights reserved.
//

import WebKit

class WebScriptMessageHandler: NSObject, WKScriptMessageHandler {
    
    // MARK: WKScriptMessageHandler protocol
    func userContentController(userContentController: WKUserContentController,
        didReceiveScriptMessage message: WKScriptMessage) {
            println(message.body)
    }
    
}