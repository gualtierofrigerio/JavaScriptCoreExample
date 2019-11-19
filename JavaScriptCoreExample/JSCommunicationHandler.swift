//
//  JSCommunicationHandler.swift
//  JavaScriptCoreExample
//
//  Created by Gualtiero Frigerio on 19/11/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//

import Foundation
import JavaScriptCore

class JSCommunicationHandler {
    private let context = JSContext()
    
    init() {
        context?.exceptionHandler = {context, exception in
            if let exception = exception {
                print(exception.toString()!)
            }
        }
    }
    
    func callFunction<T>(functionName:String, withData dataObject:Codable, type:T.Type) -> JSValue? where T:Codable {
        var dataString = ""
        if let string = getString(fromObject: dataObject, type:type) {
            dataString = string
        }
        let functionString = functionName + "(\(dataString))"
        let result = context?.evaluateScript(functionString)
        return result
    }
    
    func loadSourceFile(atUrl url:URL) {
        guard let stringFromUrl = try? String(contentsOf: url) else {return}
        context?.evaluateScript(stringFromUrl)
    }
    
    func evaluateJavaScript(_ jsString:String) -> JSValue? {
        context?.evaluateScript(jsString)
    }
    
    func setObject(object:Any, withName:String) {
        context?.setObject(object, forKeyedSubscript: withName as NSCopying & NSObjectProtocol)
    }
}

extension JSCommunicationHandler {
    private func getString<T>(fromObject jsonObject:Codable, type:T.Type) -> String? where T:Codable {
        let encoder = JSONEncoder()
        guard let dataObject = jsonObject as? T,
            let data = try? encoder.encode(dataObject),
            let string = String(data:data, encoding:.utf8) else  {
                return nil
        }
        return string
    }
}
