//
//  helperProgressIndicator.swift
//  ProjectF
//
//  Created by Felippe Matos Francoski on 4/26/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import UIKit

let PROGRESS_INDICATOR_VIEW_TAG:Int = 10

/* Show Progress Indicator */
func showProgressIndicator(view:UIView){
    
    view.isUserInteractionEnabled = false
    
    // Create and add the view to the screen.
    //TODO: Colocar texto em variavel
    let progressIndicator = ProgressIndicator(text: "Espere por favor...")
    progressIndicator.tag = PROGRESS_INDICATOR_VIEW_TAG
    view.addSubview(progressIndicator)
    
}

/* Hide progress Indicator */
func hideProgressIndicator(view:UIView){
    
    view.isUserInteractionEnabled = true
    
    if let viewWithTag = view.viewWithTag(PROGRESS_INDICATOR_VIEW_TAG) {
        viewWithTag.removeFromSuperview()
    }
    
}
