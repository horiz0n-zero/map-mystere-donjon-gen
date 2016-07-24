//
//  object.swift
//  map mystere
//
//  Created by Antoine FeuFeu on 31/05/2016.
//  Copyright © 2016 Antoine FeuFeu. All rights reserved.
//

import Foundation
import SpriteKit

struct objet {
    
    let t_cle = SKTexture(imageNamed: "cle")
    let t_gelee_verte = SKTexture(imageNamed: "gelee_verte")
    let t_orbe_doree = SKTexture(imageNamed: "orbe_doree")
    let t_pierre_verte = SKTexture(imageNamed: "pierre_verte")
    
    let t_epine = SKTexture(imageNamed: "epine")
    
    func objetNearest() {
        
        t_cle.filteringMode = .Nearest
        t_orbe_doree.filteringMode = .Nearest
        t_gelee_verte.filteringMode = .Nearest
        t_pierre_verte.filteringMode = .Nearest
        
    }
    
}

struct epee {
    
    var textures = [SKTexture]()
    
    init() {
        
        for i in 1...13 {
            
            let nom = "e\(i)"
            let t = SKTexture(imageNamed: nom)
            t.filteringMode = .Nearest
            textures.append(t)
            
        }
        
    }
    
    func animer(sprite: SKSpriteNode) {
        
        sprite.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.05)))
        
    }
    
}

var MaterielObjet: objet!
var epees: epee!