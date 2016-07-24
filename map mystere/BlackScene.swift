//
//  BlackScene.swift
//  map mystere
//
//  Created by Antoine FeuFeu on 31/05/2016.
//  Copyright © 2016 Antoine FeuFeu. All rights reserved.
//

import Foundation
import SpriteKit

var NiveauActuel: Int = 1

class BlackScene: SKScene {
    
    let label = SKLabelNode(fontNamed: "Arial")
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = UIColor.blackColor()
        
        
        label.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        label.fontColor = UIColor.whiteColor()
        label.horizontalAlignmentMode = .Center
        label.verticalAlignmentMode = .Center
        label.text = "forêt crepuscule  Niveau - \(NiveauActuel)"
        label.alpha = 0.0
        self.addChild(label)
        self.runAction(SKAction.sequence([
            SKAction.runBlock({
            self.label.runAction(SKAction.fadeAlphaTo(1.0, duration: 1.5))
            }), SKAction.waitForDuration(2),
            SKAction.runBlock({
                self.charger()
            })
            ]))
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func charger() {
        
        if #available(iOS 9.0, *) {
            let scene_suivante = GameScene(size: self.frame.size)
            scene_suivante.scaleMode = .AspectFill
            
            let transition = SKTransition.fadeWithDuration(1.5)
            
            self.view?.presentScene(scene_suivante, transition: transition)
            
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    
}




