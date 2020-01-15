//
//  UserDefaults+type-safe.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 13/12/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    var messageOfTheDay: String? {
        get { return string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var authorMessageOfTheDay: String? {
        get { return string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var dateMessageOfTheDay: String? {
        get { return string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
    var dateSchedulingOfEvangelhoNoLar: String? {
        get { return string(forKey: #function) }
        set { set(newValue, forKey: #function) }
    }
    
}
