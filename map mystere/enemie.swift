//
//  enemie.swift
//  map mystere
//
//  Created by Antoine FeuFeu on 31/05/2016.
//  Copyright © 2016 Antoine FeuFeu. All rights reserved.
//

import Foundation
import SpriteKit



class chenille: SKSpriteNode {
    
    var pv: Int = 100
    var objet: Bool = false
    var objetTenu: Character? = nil
    
    enum direction {
        case devant
        case derriere
        case gauche
        case droite
        case aucune
    }
    
    let t_cheni_devant_un = SKTexture(imageNamed: "cheni1")
    let t_cheni_devant_deux = SKTexture(imageNamed: "cheni2")
    let t_cheni_droite_un = SKTexture(imageNamed: "cheni3")
    let t_cheni_droit_deux = SKTexture(imageNamed: "cheni8")
    let t_cheni_gauche_un = SKTexture(imageNamed: "cheni5")
    let t_cheni_gauche_deux = SKTexture(imageNamed: "cheni7")
    let t_cheni_derriere_un = SKTexture(imageNamed: "cheni4")
    let t_cheni_derriere_deux = SKTexture(imageNamed: "cheni6")
    
    let action = "actioncoco chenille !"
    let action_sautillement = "action sautillement !"
    var colonne: Int = 0
    var ranger: Int = 0
    var chaine: Int = 0
    var sens: direction = .aucune
    
    var frame_local = CGRect(origin: CGPointZero, size: CGSize(width: 1, height: 1))
    
    class func InitialiserChenille(frame: CGRect) -> chenille {
        
        let chenille_enemie = chenille(texture: SKTexture(imageNamed: "cheni1"))
        chenille_enemie.zPosition = 42
        chenille_enemie.size = CGSize(width: (frame.width/15)*0.5, height: (frame.width/15)*0.5)
        chenille_enemie.anchorPoint = CGPointZero
        
        return chenille_enemie
    }
    
    func textureNearest(frame: CGRect) {
        self.frame_local = frame
        t_cheni_devant_un.filteringMode = .Nearest
        t_cheni_devant_deux.filteringMode = .Nearest
        t_cheni_droite_un.filteringMode = .Nearest
        t_cheni_droit_deux.filteringMode = .Nearest
        t_cheni_gauche_un.filteringMode = .Nearest
        t_cheni_gauche_deux.filteringMode = .Nearest
        t_cheni_derriere_un.filteringMode = .Nearest
        t_cheni_derriere_deux.filteringMode = .Nearest
        
    }
    
    func InitPosition() {
        
        self.position = CGPoint(x: frame_local.origin.x + (frame_local.height/15)*CGFloat(colonne) + self.size.width/4, y: frame_local.origin.y + (frame_local.height/15)*CGFloat(ranger) + self.size.width/4)
        
    }
    
    func RefreshPosition() {
        
        let position = CGPoint(x: frame_local.origin.x + (frame_local.height/15)*CGFloat(colonne) + self.size.width/4, y: frame_local.origin.y + (frame_local.height/15)*CGFloat(ranger) + self.size.width/4)
        self.runAction(SKAction.moveTo(position, duration: 0.5))
        
    }
    
    func supr() {
        
        if self.actionForKey(action) != nil {
           self.removeActionForKey(action)
        }
        
    }
    
    func suprSautillement() {
        if self.actionForKey(action_sautillement) != nil {
            self.removeActionForKey(action_sautillement)
        }
    }
    
    func animer(textures: [SKTexture]) {
        
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.5)), withKey: action)
        
    }
    
    func sautiller(textures: [SKTexture]) {
        
        self.runAction(SKAction.animateWithTextures(textures, timePerFrame: 0.25))
        
    }
    
    func PlacerDevant() {
        
        supr()
        self.texture = t_cheni_devant_un
        
    }
    func PlacerDroit() {
        
        supr()
        self.texture = t_cheni_droite_un
    }
    func PlacerGauche() {
        
        supr()
        self.texture = t_cheni_gauche_un
    }
    func PlacerDerriere() {
        supr()
        self.texture = t_cheni_derriere_un
    }
    
    func AvancerDevant() {
        supr()
        suprSautillement()
        animer([t_cheni_devant_un, t_cheni_devant_deux])
    }
    func AvancerDroit() {
        supr()
        suprSautillement()
        animer([t_cheni_droite_un, t_cheni_droit_deux])
    }
    func AvancerGauche() {
        supr()
        suprSautillement()
        animer([t_cheni_gauche_un, t_cheni_gauche_deux])
    }
    func AvancerDerriere() {
        supr()
        suprSautillement()
        animer([t_cheni_derriere_un, t_cheni_derriere_deux])
    }
    func MarcherDevant() {
        supr()
        self.runAction(SKAction.sequence([
            SKAction.runBlock({
                self.AvancerDevant()
            }), SKAction.waitForDuration(0.5),
            SKAction.runBlock({
                self.supr()
                self.suprSautillement()
                self.sautillerDevant()
            })
            ]))
    }
    func MarcherDerriere() {
        supr()
        self.runAction(SKAction.sequence([
            SKAction.runBlock({
                self.AvancerDerriere()
            }), SKAction.waitForDuration(0.5),
            SKAction.runBlock({
                self.supr()
                self.suprSautillement()
                self.sautillerDerriere()
            })
            ]))
    }
    func MarcherGauche() {
        supr()
        self.runAction(SKAction.sequence([
            SKAction.runBlock({
                self.AvancerGauche()
            }), SKAction.waitForDuration(0.5),
            SKAction.runBlock({
                self.supr()
                self.suprSautillement()
                self.sautillerGauche()
            })
            ]))
    }
    func MarcherDroite() {
        supr()
        self.runAction(SKAction.sequence([
            SKAction.runBlock({
                self.AvancerDroit()
            }), SKAction.waitForDuration(0.5),
            SKAction.runBlock({
                self.supr()
                self.suprSautillement()
                self.sautillerDroit()
                
            })
            ]))
    }
    
    func sautillerDevant() {
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock({
                self.sautiller([self.t_cheni_devant_un, self.t_cheni_devant_deux])
            }), SKAction.waitForDuration(1)
            ])), withKey: action_sautillement)
        
    }
    
    func sautillerGauche() {
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock({
                self.sautiller([self.t_cheni_gauche_un, self.t_cheni_gauche_deux])
            }), SKAction.waitForDuration(1)
            ])), withKey: action_sautillement)
        
    }
    
    func sautillerDroit() {
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock({
                self.sautiller([self.t_cheni_droite_un, self.t_cheni_droit_deux])
            }), SKAction.waitForDuration(1)
            ])), withKey: action_sautillement)
        
    }
    func sautillerDerriere() {
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock({
                self.sautiller([self.t_cheni_derriere_un, self.t_cheni_derriere_deux])
            }), SKAction.waitForDuration(1)
            ])), withKey: action_sautillement)
    }
    
    
}



















