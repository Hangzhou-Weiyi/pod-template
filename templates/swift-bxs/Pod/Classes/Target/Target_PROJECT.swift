//
//  Target_PROJECT.swift
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

import Foundation

@objc class Target_PROJECT: NSObject {
    @objc func Action_PROJECTViewController(_ params:NSDictionary) -> UIViewController {
        let vc = PROJECTViewController()
        // if let callback = params["callBack"] as? (Bool) -> Void {
        //     vc.block = callback
        // }
        return vc
    }
}
