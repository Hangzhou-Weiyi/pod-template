//
//  BXSAPPULPATHTarget.swift
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

class BXSAPPULPATHTarget: BXSBaseTarget {
    /// https://j.winbaoxian.com/APPULPATH/home
    @objc func actionHome(_ params: NSDictionary) -> Any {
        let vc = PROJECTViewController()
        presentOrPush(vc)   

        return true
    }
}

extension BXSMediator {
    @objc func ModuleAndTargetClassString_APPULPATH() -> String {
        return NSStringFromClass(BXSAPPULPATHTarget.self)
    }
}
