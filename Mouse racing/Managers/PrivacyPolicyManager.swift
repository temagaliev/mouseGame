//
//  PrivacyPolicyManager.swift
//  Mouse racing
//
//  Created by Артем Галиев on 17.02.2020.
//  Copyright © 2020 Артем Галиев. All rights reserved.
//

import Foundation

class PrivacyPolicyManager {
    static func checkLocateYouDevice() -> String {
        let locate = NSLocale.preferredLanguages.first
        let enURL = "https://docs.google.com/document/d/1V5TrKmWAYIf-PUHaENdB4cecULDKh5w-1JDLqcuSDTU/edit?usp=sharing"
        let ruURL = "https://docs.google.com/document/d/1VdOdxOfEVdSoCZovX48QcgQBXlvjwx2Rk0y3nDjHluQ/edit?usp=sharing"
        if (locate?.hasPrefix("en"))! {
            return enURL
        } else if (locate?.hasPrefix("ru"))! {
            return ruURL
        }
        return enURL
    }
}
