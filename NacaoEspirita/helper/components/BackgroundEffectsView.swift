//
//  ParticleBackgroundView.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/16/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class ParticleBackgroundView:UIView {
    var particleImage:UIImage?
    
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    
    func makeEmmiterCell(color:UIColor, velocity:CGFloat, scale:CGFloat)-> CAEmitterCell {
        let cell = CAEmitterCell()
        let color = AppColor.MAIN_BLUE_TRANSLUCENT
        
        cell.color = color.cgColor
        cell.birthRate = 0.75
        cell.lifetime = 50.0
        cell.lifetimeRange = 0
        cell.velocity = velocity
        cell.velocityRange = velocity / 4
        cell.emissionLongitude = .pi / 50
        cell.emissionRange = .pi / 8
        cell.scale = scale
        cell.scaleRange = scale / 3
        cell.contents = particleImage?.cgImage
        
        return cell
    }
    
    override func layoutSubviews() {
        let emitter = self.layer as! CAEmitterLayer
        emitter.masksToBounds = true
        emitter.emitterShape = .line
        emitter.emitterPosition = CGPoint(x: bounds.midX, y: bounds.maxY)
        emitter.emitterSize = CGSize(width: bounds.size.width, height: 1)
        
        let near = makeEmmiterCell(color: UIColor(white: 1, alpha: 1), velocity: 25, scale: 0.5)
        let middle = makeEmmiterCell(color: UIColor(white: 1, alpha: 0.66), velocity: 20, scale: 0.4)
        let far = makeEmmiterCell(color: UIColor(white: 1, alpha: 0.33), velocity: 15, scale: 0.3)
        
        emitter.emitterCells = [near, middle, far]
    }
    

}

class ParallaxBackgroundView:UIView {

    func addParallaxToView(vw: UIView) -> UIMotionEffectGroup {
        let amount = 50
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        return group
    }
    
}

