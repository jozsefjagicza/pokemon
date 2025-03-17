//
//  Config.swift
//  Pokemon
//
//  Created by József Jagicza on 2025. 03. 13..
//

import Foundation
import UIKit

struct Config {

    static let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String

    static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    static let buildVersionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
            
    static let osVersion = UIDevice.current.systemVersion
    
    static var baseURL = "https://\((Bundle.main.object(forInfoDictionaryKey: "BASE_URL") ?? ""))/api/v2/pokemon/"
}


