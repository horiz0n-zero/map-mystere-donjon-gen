//
//  player.swift
//  map mystere
//
//  Created by Antoine FeuFeu on 29/05/2016.
//  Copyright © 2016 Antoine FeuFeu. All rights reserved.
//

import Foundation
import SpriteKit

protocol hero {
    
    var pv: Int { get }
    var sac: [Character] { get }
    
}

class joueur: SKSpriteNode, hero {
    
    var pv: Int = 300
    var sac: [Character] = []
    
    class func InitializerJoueur(frame: CGRect) -> joueur {
        
        let player = joueur(texture: SKTexture(imageNamed: "bande1"))
        player.size = CGSize(width: ((frame.size.height/15)*1.22222)*0.9, height: (frame.size.width/15)*0.9)
        player.anchorPoint = CGPointZero
        player.zPosition = 42
        return player
    }
    
   
    let helio_marche_droit_un = SKTexture(imageNamed: "bande7")
    let helio_marche_droit_deux = SKTexture(imageNamed: "bande8")
   
    let helio_marche_devant_un = SKTexture(imageNamed: "bande1")
    let helio_marche_devant_deux = SKTexture(imageNamed: "bande2")
    let helio_marche_gauche_un = SKTexture(imageNamed: "bande4")
    let helio_marche_dos_un = SKTexture(imageNamed: "bande3")

    let helio_marche_dos_deux = SKTexture(imageNamed: "bande6")
  
    let helio_gauche_marche_deux = SKTexture(imageNamed: "bande5")
    
    let action = "action!"
    
    var colonne: Int = 0
    var ranger: Int = 0
    var key: Int = 0
    
    func KeyRefresh() {
        self.key = colonne*1000 + ranger
    }
    
    func textureNearset() {
        
        helio_marche_droit_un.filteringMode = .Nearest
        helio_marche_droit_deux.filteringMode = .Nearest
        
        helio_marche_devant_un.filteringMode = .Nearest
        helio_marche_devant_deux.filteringMode = .Nearest
        helio_marche_gauche_un.filteringMode = .Nearest
        helio_marche_dos_un.filteringMode = .Nearest
       
        helio_marche_dos_deux.filteringMode = .Nearest
       
        helio_gauche_marche_deux.filteringMode = .Nearest
    }
    
    func supr() {
        if (self.actionForKey(action) != nil) {
        self.removeActionForKey(action)
        }
    }
    func animer(textures: [SKTexture]) {
        
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.25)), withKey: action)
        
    }
    
    func sautiller(textures: [SKTexture]) {
        
        self.runAction(SKAction.animateWithTextures(textures, timePerFrame: 0.25))
        
    }
    
    func devant() {
        
        supr()
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock({
                self.sautiller([self.helio_marche_devant_un, self.helio_marche_devant_deux])
            }),
            SKAction.waitForDuration(1)
            ])), withKey: action)
        
    }
    
    func dos() {
        supr()
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock({
                self.sautiller([self.helio_marche_dos_un, self.helio_marche_dos_deux])
            }),
            SKAction.waitForDuration(1)
            ])), withKey: action)
    }
    
    func gauche() {
        supr()
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock({
                self.sautiller([self.helio_marche_gauche_un, self.helio_gauche_marche_deux])
            }),
            SKAction.waitForDuration(1)
            ])), withKey: action)
    }
    func droit() {
        supr()
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock({
                self.sautiller([self.helio_marche_droit_un, self.helio_marche_droit_deux])
            }),
            SKAction.waitForDuration(1)
            ])), withKey: action)
    }
    
    func PlacerDevant() {
        supr()
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.waitForDuration(1),
            SKAction.runBlock({
            self.sautiller([self.helio_marche_devant_un, self.helio_marche_devant_deux])
            })
            ])), withKey: action)
    }
    func PlacerDroite() {
        supr()
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.waitForDuration(1),
            SKAction.runBlock({
                self.sautiller([self.helio_marche_droit_un, self.helio_marche_droit_deux])
            })
            ])), withKey: action)
    }
    func PlacerGauche() {
        supr()
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.waitForDuration(1),
            SKAction.runBlock({
                self.sautiller([self.helio_marche_gauche_un, self.helio_gauche_marche_deux])
            })
            ])), withKey: action)
    }
    func PlacerDos() {
        supr()
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.waitForDuration(1),
            SKAction.runBlock({
                self.sautiller([self.helio_marche_dos_un, self.helio_marche_dos_deux])
            })
            ])), withKey: action)
    }
    
    
    func MarcherDevant() {
        supr()
        animer([helio_marche_devant_un, helio_marche_devant_deux])
    }
    func MarcherDroite() {
        supr()
        animer([helio_marche_droit_un, helio_marche_droit_deux])
    }
    func MarcherGauche() {
        supr()
        animer([helio_marche_gauche_un, helio_gauche_marche_deux])
    }
    func MarcherDos() {
        supr()
        animer([helio_marche_dos_un, helio_marche_dos_deux])
    }
    
    
}














