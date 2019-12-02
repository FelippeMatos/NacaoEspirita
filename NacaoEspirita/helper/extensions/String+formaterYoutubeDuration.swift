//
//  String+formaterYoutubeDuration.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 27/11/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation

extension String {
    func getYoutubeFormattedDuration() -> String {
        
        let formattedDuration = self.replacingOccurrences(of: "PT", with: "").replacingOccurrences(of: "H", with:":").replacingOccurrences(of: "M", with: ":").replacingOccurrences(of: "S", with: "")
        
        let components = formattedDuration.components(separatedBy: ":")
        var duration = ""
        for component in components {
            duration = duration.count > 0 ? duration + ":" : duration
            if component.count < 2 {
                duration += "0" + component
                continue
            }
            duration += component
        }
        
        return duration
        
    }
}
