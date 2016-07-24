//
//  GameScene.swift
//  map mystere
//
//  Created by Antoine FeuFeu on 29/05/2016.
//  Copyright (c) 2016 Antoine FeuFeu. All rights reserved.
//

import SpriteKit

@available(iOS 9.0, *)
class GameScene: SKScene {
    

    var MapNode = SKNode()
    var player: joueur!
    var EnMouvement: Bool = false
    var collection = [Int: evenement]()
    
    let music_brumeuse = SKAudioNode(fileNamed: "foret_brumeuse.mp3")
    let music_crepuscule = SKAudioNode(fileNamed: "foret_crepuscule.mp3")
    let music_pomme = SKAudioNode(fileNamed: "foret_pomme.mp3")
    let son_mauvais_mouvement = SKAction.playSoundFileNamed("bad_move_06.caf", waitForCompletion: false)
    let son_deplacement = SKAction.playSoundFileNamed("SFX42.wav", waitForCompletion: false)
    let son_ramasser = SKAction.playSoundFileNamed("ramasse.wav", waitForCompletion: false)
    
    let pad_droit = SKSpriteNode(imageNamed: "droit")
    let pad_gauche = SKSpriteNode(imageNamed: "gauche")
    let pad_bas = SKSpriteNode(imageNamed: "bas")
    let pad_haut = SKSpriteNode(imageNamed: "haut")
    let pad_acc = SKSpriteNode(texture: epees.textures[0])
    var epeeActive: Bool = false
    // enemie :
    var AdvNode = [chenille]()
    var NombreEnemie = 0
    let actionAvd = "action enemie !"
    
    let cameraScene = SKCameraNode()
    
    var vitesse: NSTimeInterval = 0.5
    
    override func update(currentTime: NSTimeInterval) {
        self.camera?.position = self.player.position
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.addChild(cameraScene)
        self.cameraScene.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.camera = cameraScene
        
        
        self.addChild(MapNode)
        MapNode.position = CGPointZero
        
        collection = texture_manageur.genererString(taille: 30)
        let taille = CGSize(width: self.frame.height/15, height: self.frame.height/15)
        
        let sprites = texture_manageur.positioner(&collection, frame: self.frame, taille: taille, longueur: 30)
        let sprites_r = sprites.reverse()
        for sprite in sprites_r {
            MapNode.addChild(sprite)
        }
        
        player = joueur.InitializerJoueur(self.frame)
        player.position = CGPoint(x: self.frame.origin.x + taille.width*7, y: self.frame.origin.y + taille.width*7)
        player.colonne = 7
        player.ranger = 7
        player.KeyRefresh()
        player.textureNearset()
        self.addChild(player)
        PlacerPad()
        
        // musique :
        self.runAction(SKAction.sequence([
            SKAction.waitForDuration(0.25),
            SKAction.runBlock({
                let RANDOMMusic = Int(arc4random_uniform(3)) + 1
                switch RANDOMMusic {
                case 1:
                    self.addChild(self.music_pomme)
                case 2:
                    self.addChild(self.music_brumeuse)
                case 3:
                    self.addChild(self.music_crepuscule)
                default:
                    break
                }
            })
            ]))
        // fx
        self.son_deplacement.timingMode = .EaseIn
        
        
        // enemie
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.waitForDuration(2), SKAction.runBlock({
                
                if self.NombreEnemie < 5 {
                let enemie = chenille.InitialiserChenille(self.frame)
                enemie.textureNearest(self.frame)
                enemie.sautillerDevant()
                let posx = CGFloat(arc4random_uniform(28)) + 1
                let posy = CGFloat(arc4random_uniform(28)) + 1
                enemie.colonne = Int(posx)
                enemie.ranger = Int(posy)
                enemie.InitPosition()
                self.MapNode.addChild(enemie)
                self.AdvNode.append(enemie)
                self.NombreEnemie += 1
                }
                
                
            })
            ])), withKey: actionAvd)
        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            
            
            if pad_bas.containsPoint(location) && EnMouvement == false {
                
                let caseSuivante = self.player.colonne*1000 + self.player.ranger - 1
                
                if var c = collection[caseSuivante] {
                    Check(c.character)
                    if c.character != "m" && c.character != "g" && c.character != "1" && c.character != "u" && c.character != "p" {
                    
                    
                        self.runAction(son_deplacement)
                        self.runAction(SKAction.sequence([
                            SKAction.runBlock({
                                self.ReflexionAdversaire(0, ranger: 1)
                                self.player.ranger -= 1
                                self.player.MarcherDevant()
                                self.HeroCheckObjetc(&c)
                                self.MapNode.runAction(SKAction.moveTo(CGPoint(x: self.MapNode.position.x, y: self.MapNode.position.y + self.frame.height/15), duration: self.vitesse))
                                self.EnMouvement = true
                                self.player.zPosition = self.player.zPosition - 5
                            }), SKAction.waitForDuration(self.vitesse),
                            SKAction.runBlock({
                                self.player.PlacerDevant()
                                self.EnMouvement = false
                               
                            })
                            ]))
                        
                    } else {
                        self.player.devant()
                        self.runAction(son_mauvais_mouvement)
                    }
                    
                }
                
            }
            if pad_haut.containsPoint(location) && EnMouvement == false {
                
                let caseSuivante = self.player.colonne*1000 + self.player.ranger + 1
                
                if var c = collection[caseSuivante] {
                    Check(c.character)
                    if c.character != "m" && c.character != "g" && c.character != "1" && c.character != "u" && c.character != "p"{
                    
                self.runAction(son_deplacement)
                self.runAction(SKAction.sequence([
                    SKAction.runBlock({
                        self.ReflexionAdversaire(0, ranger: -1)
                        self.player.ranger += 1
                        self.player.MarcherDos()
                        self.HeroCheckObjetc(&c)
                        self.MapNode.runAction(SKAction.moveTo(CGPoint(x: self.MapNode.position.x, y: self.MapNode.position.y - self.frame.height/15), duration: self.vitesse))
                        self.EnMouvement = true
                        self.player.zPosition = self.player.zPosition + 5
                    }), SKAction.waitForDuration(self.vitesse),
                    SKAction.runBlock({
                        self.player.PlacerDos()
                        self.EnMouvement = false
                        
                    })
                    ]))
                        
                    } else {
                        self.player.dos()
                        self.runAction(son_mauvais_mouvement)
                    
                    }
                    
                }
            }
            if pad_gauche.containsPoint(location) && EnMouvement == false {
                
                let caseSuivante = (self.player.colonne - 1)*1000 + self.player.ranger
               
                if var c = collection[caseSuivante] {
                    Check(c.character)
                    if c.character != "m" && c.character != "g" && c.character != "1" && c.character != "u" && c.character != "p" {
                
                self.runAction(son_deplacement)
                self.runAction(SKAction.sequence([
                    SKAction.runBlock({
                        self.ReflexionAdversaire(1, ranger: 0)
                        self.player.colonne -= 1
                        self.player.MarcherGauche()
                        self.HeroCheckObjetc(&c)
                        self.MapNode.runAction(SKAction.moveTo(CGPoint(x: self.MapNode.position.x + self.frame.height/15, y: self.MapNode.position.y), duration: self.vitesse))
                        self.EnMouvement = true
                    }), SKAction.waitForDuration(self.vitesse),
                    SKAction.runBlock({
                        self.player.PlacerGauche()
                        self.EnMouvement = false
                    })
                    ]))
                        
                    } else {
                        self.player.gauche()
                        self.runAction(son_mauvais_mouvement)
                      
                    }
                    
                }
            }
            if pad_droit.containsPoint(location) && EnMouvement == false {
                
                let caseSuivante = (self.player.colonne + 1)*1000 + self.player.ranger
                
                if var c = collection[caseSuivante] {
                    Check(c.character)
                    if c.character != "m" && c.character != "g" && c.character != "1" && c.character != "u" && c.character != "p"{
                    
                self.runAction(son_deplacement)
                self.runAction(SKAction.sequence([
                    SKAction.runBlock({
                        self.ReflexionAdversaire(-1, ranger: 0)
                        self.player.colonne += 1
                        self.player.MarcherDroite()
                        self.HeroCheckObjetc(&c)
                        self.MapNode.runAction(SKAction.moveTo(CGPoint(x: self.MapNode.position.x - self.frame.height/15, y: self.MapNode.position.y), duration: self.vitesse))
                        self.EnMouvement = true
                    }), SKAction.waitForDuration(self.vitesse),
                    SKAction.runBlock({
                        self.player.PlacerDroite()
                        self.EnMouvement = false
                    })
                    ]))
                    } else {
                        self.player.droit()
                        self.runAction(son_mauvais_mouvement)
                      
                    }
                }
            }
            if pad_acc.containsPoint(location) {
                
                if epeeActive == false {
                    
                    epeeActive = true
                    epees.animer(pad_acc)
                    vitesse /= 4
                    
                } else {
                    
                    epeeActive = false
                    pad_acc.removeAllActions()
                    pad_acc.texture = epees.textures[0]
                    vitesse *= 4
                    
                }
                
            }
            
        }
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
     
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            if pad_bas.containsPoint(location) && EnMouvement == false {
                
                let caseSuivante = self.player.colonne*1000 + self.player.ranger - 1

                ReflexionAdversaire(0, ranger: 1)
                
                if var c = collection[caseSuivante] {
                    Check(c.character)
                    if c.character != "m" && c.character != "g" && c.character != "1" && c.character != "u" && c.character != "p" {
                        
                        
                        self.runAction(son_deplacement)
                        self.runAction(SKAction.sequence([
                            SKAction.runBlock({
                                self.ReflexionAdversaire(0, ranger: 1)
                                self.player.ranger -= 1
                                self.player.MarcherDevant()
                                self.HeroCheckObjetc(&c)
                                self.MapNode.runAction(SKAction.moveTo(CGPoint(x: self.MapNode.position.x, y: self.MapNode.position.y + self.frame.height/15), duration: self.vitesse))
                                self.EnMouvement = true
                                self.player.zPosition = self.player.zPosition - 5
                            }), SKAction.waitForDuration(self.vitesse),
                            SKAction.runBlock({
                                self.player.PlacerDevant()
                                self.EnMouvement = false
                            })
                            ]))
                        
                    } else {
                        self.player.devant()
                        self.runAction(son_mauvais_mouvement)
                        
                    }
                    
                }
                
            }
            if pad_haut.containsPoint(location) && EnMouvement == false {
                
                let caseSuivante = self.player.colonne*1000 + self.player.ranger + 1
                
                if var c = collection[caseSuivante] {
                    Check(c.character)
                    if c.character != "m" && c.character != "g" && c.character != "1" && c.character != "u" && c.character != "p"{
                        
                        self.runAction(son_deplacement)
                        self.runAction(SKAction.sequence([
                            SKAction.runBlock({
                                self.ReflexionAdversaire(0, ranger: -1)
                                self.player.ranger += 1
                                self.player.MarcherDos()
                                self.HeroCheckObjetc(&c)
                                self.MapNode.runAction(SKAction.moveTo(CGPoint(x: self.MapNode.position.x, y: self.MapNode.position.y - self.frame.height/15), duration: self.vitesse))
                                self.EnMouvement = true
                                self.player.zPosition = self.player.zPosition + 5
                            }), SKAction.waitForDuration(self.vitesse),
                            SKAction.runBlock({
                                self.player.PlacerDos()
                                self.EnMouvement = false
                            })
                            ]))
                        
                    } else {
                        self.player.dos()
                        self.runAction(son_mauvais_mouvement)
                        
                    }
                    
                }
            }
            if pad_gauche.containsPoint(location) && EnMouvement == false {
                
                let caseSuivante = (self.player.colonne - 1)*1000 + self.player.ranger
                
                
                if var c = collection[caseSuivante] {
                    Check(c.character)
                    if c.character != "m" && c.character != "g" && c.character != "1" && c.character != "u" && c.character != "p" {
                        
                        self.runAction(son_deplacement)
                        self.runAction(SKAction.sequence([
                            SKAction.runBlock({
                                self.ReflexionAdversaire(1, ranger: 0)
                                self.player.colonne -= 1
                                self.player.MarcherGauche()
                                self.HeroCheckObjetc(&c)
                                self.MapNode.runAction(SKAction.moveTo(CGPoint(x: self.MapNode.position.x + self.frame.height/15, y: self.MapNode.position.y), duration: self.vitesse))
                                self.EnMouvement = true
                            }), SKAction.waitForDuration(self.vitesse),
                            SKAction.runBlock({
                                self.player.PlacerGauche()
                                self.EnMouvement = false
                            })
                            ]))
                        
                    } else {
                        self.player.gauche()
                        self.runAction(son_mauvais_mouvement)
                       
                    }
                    
                }
            }
            if pad_droit.containsPoint(location) && EnMouvement == false {
                
                let caseSuivante = (self.player.colonne + 1)*1000 + self.player.ranger
                
                
                if var c = collection[caseSuivante] {
                    Check(c.character)
                    if c.character != "m" && c.character != "g" && c.character != "1" && c.character != "u" && c.character != "p"{
                        
                        self.runAction(son_deplacement)
                        self.runAction(SKAction.sequence([
                            SKAction.runBlock({
                                self.ReflexionAdversaire(-1, ranger: 0)
                                self.player.colonne += 1
                                self.player.MarcherDroite()
                                self.HeroCheckObjetc(&c)
                                self.MapNode.runAction(SKAction.moveTo(CGPoint(x: self.MapNode.position.x - self.frame.height/15, y: self.MapNode.position.y), duration: self.vitesse))
                                self.EnMouvement = true
                            }), SKAction.waitForDuration(self.vitesse),
                            SKAction.runBlock({
                                self.player.PlacerDroite()
                                self.EnMouvement = false
                            })
                            ]))
                    } else {
                        self.player.droit()
                        self.runAction(son_mauvais_mouvement)
                        
                    }
                }
            }

            
        }
        
    }
    
    
    
    
    
    
    
    
    
    func Check(c: Character) {
        
        if c == "@" {
            
            NiveauActuel += 1
            
            let scene_suivante = BlackScene(size: self.frame.size)
            scene_suivante.scaleMode = .AspectFill
            let transition = SKTransition.fadeWithDuration(1)
            self.runAction(SKAction.sequence([
                SKAction.waitForDuration(0.5), 
                SKAction.playSoundFileNamed("SFX26.wav", waitForCompletion: false),
                SKAction.runBlock({
                self.view?.presentScene(scene_suivante, transition: transition)
                })
                ]))
            
            
        }
        
    }
    
    func HeroCheckObjetc(inout map: evenement) {
        
        if map.character == "%" {
            
            self.runAction(SKAction.sequence([
                SKAction.waitForDuration(vitesse),
                son_ramasser,
                SKAction.runBlock({
                    map.sprites?.removeFromParent()
                    map.character = "x"
                    self.player.sac.append("%")
                })
                ]))
        }
        if map.character == "£" {
            
            self.runAction(SKAction.sequence([
                SKAction.waitForDuration(vitesse),
                son_ramasser,
                SKAction.runBlock({
                    map.sprites?.removeFromParent()
                    map.character = "x"
                    self.player.sac.append("£")
                })
                ]))
        }
        if map.character == "-" {
            
            self.runAction(SKAction.sequence([
                SKAction.waitForDuration(vitesse),
                son_ramasser,
                SKAction.runBlock({
                    map.sprites?.removeFromParent()
                    map.character = "x"
                    self.player.sac.append("-")
                })
                ]))
        }
        
        
    }

    
    func AdvCheckObject(inout map: evenement, inout sprite: chenille) {
        
        if map.character == "%" && sprite.objet == false {
           
            self.runAction(SKAction.sequence([
                SKAction.waitForDuration(vitesse),
                son_ramasser,
                SKAction.runBlock({
                    map.sprites?.removeFromParent()
                    map.character = "x"
                    sprite.objet = true
                    sprite.objetTenu = "%"
                })
                ]))
            
        }
        if map.character == "£" && sprite.objet == false {
            
            self.runAction(SKAction.sequence([
                SKAction.waitForDuration(vitesse),
                son_ramasser,
                SKAction.runBlock({
                    map.sprites?.removeFromParent()
                    map.character = "x"
                    sprite.objet = true
                    sprite.objetTenu = "£"
                })
                ]))
            
        }
        if map.character == "-" && sprite.objet == false{
            
            self.runAction(SKAction.sequence([
                SKAction.waitForDuration(vitesse),
                son_ramasser,
                SKAction.runBlock({
                    map.sprites?.removeFromParent()
                    map.character = "x"
                    sprite.objet = true
                    sprite.objetTenu = "-"
                })
                ]))
            
        }
        
        
        
    }
    
    func ReflexionAdversaire(colonne: Int, ranger: Int) {
        
        for var sprite in AdvNode {
                    
                   // ici commence les detections 
                   // checker avec les colonnes et rangers reelles puis changer a l'aide

            
                    if sprite.chaine == 0 {
                        
                       let marche = Int(arc4random_uniform(15)) + 1
                       sprite.chaine = marche
                       let sensMarche = Int(arc4random_uniform(4)) + 1
                        switch sensMarche {
                        case 1:
                            sprite.sens = .devant
                        case 2:
                            sprite.sens = .derriere
                        case 3:
                            sprite.sens = .gauche
                        case 4:
                            sprite.sens = .droite
                        default:
                            sprite.sens = .aucune
                        }
                        reload(&sprite)
                        
                    }
                    if sprite.chaine > 0 {
                       sprite.chaine -= 1
                        switch sprite.sens {
                        case .derriere:
                            
                            let key = sprite.colonne*1000 + sprite.ranger+1
                            if var c = collection[key] {
                                
                                if c.character != "m" && c.character != "1" && c.character != "g" && c.character != "u" && c.character != "p" {

                                    sprite.ranger += 1
                                    sprite.RefreshPosition()
                                    sprite.MarcherDerriere()
                                    AdvCheckObject(&c, sprite: &sprite)
                                    
                                } else {
                                    let sensMarche = Int(arc4random_uniform(4)) + 1
                                    switch sensMarche {
                                    case 1:
                                        sprite.sens = .devant
                                    case 2:
                                        sprite.sens = .derriere
                                    case 3:
                                        sprite.sens = .gauche
                                    case 4:
                                        sprite.sens = .droite
                                    default:
                                        sprite.sens = .aucune
                                    }
                                    reload(&sprite)
                               
                                }
                                
                            } 
                        case .devant:
                            let key = sprite.colonne*1000 + sprite.ranger-1
                            if var c = collection[key] {
                                
                                if c.character != "m" && c.character != "1" && c.character != "g" && c.character != "u" && c.character != "p" {
                                    
                                    sprite.ranger -= 1
                                    sprite.RefreshPosition()
                                    sprite.MarcherDevant()
                                    AdvCheckObject(&c, sprite: &sprite)
                                    
                                } else {
                                    let sensMarche = Int(arc4random_uniform(4)) + 1
                                    switch sensMarche {
                                    case 1:
                                        sprite.sens = .devant
                                    case 2:
                                        sprite.sens = .derriere
                                    case 3:
                                        sprite.sens = .gauche
                                    case 4:
                                        sprite.sens = .droite
                                    default:
                                        sprite.sens = .aucune
                                    }
                                    reload(&sprite)
                                   
                                }
                                
                            }
                        case .droite:
                            let key = (sprite.colonne+1)*1000 + sprite.ranger
                            if var c = collection[key] {
                                
                                if c.character != "m" && c.character != "1" && c.character != "g" && c.character != "u" && c.character != "p" {
                                    
                                    sprite.colonne += 1
                                    sprite.RefreshPosition()
                                    sprite.MarcherDroite()
                                    AdvCheckObject(&c, sprite: &sprite)
                                    
                                } else {
                                    let sensMarche = Int(arc4random_uniform(4)) + 1
                                    switch sensMarche {
                                    case 1:
                                        sprite.sens = .devant
                                    case 2:
                                        sprite.sens = .derriere
                                    case 3:
                                        sprite.sens = .gauche
                                    case 4:
                                        sprite.sens = .droite
                                    default:
                                        sprite.sens = .aucune
                                    }
                                    AdvCheckObject(&c, sprite: &sprite)
                                    
                                }
                                
                            }
                        case .gauche:
                            let key = (sprite.colonne-1)*1000 + sprite.ranger
                            if var c = collection[key] {
                                
                                if c.character != "m" && c.character != "1" && c.character != "g" && c.character != "u" && c.character != "p" {
                                    
                                    sprite.colonne -= 1
                                    sprite.RefreshPosition()
                                    sprite.MarcherGauche()
                                    AdvCheckObject(&c, sprite: &sprite)
                                    
                                } else {
                                    let sensMarche = Int(arc4random_uniform(4)) + 1
                                    switch sensMarche {
                                    case 1:
                                        sprite.sens = .devant
                                    case 2:
                                        sprite.sens = .derriere
                                    case 3:
                                        sprite.sens = .gauche
                                    case 4:
                                        sprite.sens = .droite
                                    default:
                                        sprite.sens = .aucune
                                    }
                                    reload(&sprite)
                                    
                                }
                                
                            }

                        default: break
                        }
                        
                    }
                    
                    
                }
        
        
        
    }
    
    
    func reload(inout sprite: chenille) {
        switch sprite.sens {
        case .derriere:
            
            let key = sprite.colonne*1000 + sprite.ranger+1
            if var c = collection[key] {
                
                if c.character != "m" && c.character != "1" && c.character != "g" && c.character != "u" && c.character != "p" {
                    
                    sprite.ranger += 1
                    sprite.RefreshPosition()
                    sprite.MarcherDerriere()
                    AdvCheckObject(&c, sprite: &sprite)
                    
                    
                } else {
                    let sensMarche = Int(arc4random_uniform(4)) + 1
                    switch sensMarche {
                    case 1:
                        sprite.sens = .devant
                    case 2:
                        sprite.sens = .derriere
                    case 3:
                        sprite.sens = .gauche
                    case 4:
                        sprite.sens = .droite
                    default:
                        sprite.sens = .aucune
                    }
                   
                   
                }
                
            }
        case .devant:
            let key = sprite.colonne*1000 + sprite.ranger-1
            if var c = collection[key] {
                
                if c.character != "m" && c.character != "1" && c.character != "g" && c.character != "u" && c.character != "p" {
                    
                    sprite.ranger -= 1
                    sprite.RefreshPosition()
                    sprite.MarcherDevant()
                    AdvCheckObject(&c, sprite: &sprite)
                    
                } else {
                    let sensMarche = Int(arc4random_uniform(4)) + 1
                    switch sensMarche {
                    case 1:
                        sprite.sens = .devant
                    case 2:
                        sprite.sens = .derriere
                    case 3:
                        sprite.sens = .gauche
                    case 4:
                        sprite.sens = .droite
                    default:
                        sprite.sens = .aucune
                    }
              
                }
                
            }
        case .droite:
            let key = (sprite.colonne+1)*1000 + sprite.ranger
            if var c = collection[key] {
                
                if c.character != "m" && c.character != "1" && c.character != "g" && c.character != "u" && c.character != "p" {
                    
                    sprite.colonne += 1
                    sprite.RefreshPosition()
                    sprite.MarcherDroite()
                    AdvCheckObject(&c, sprite: &sprite)
                   
                    
                } else {
                    let sensMarche = Int(arc4random_uniform(4)) + 1
                    switch sensMarche {
                    case 1:
                        sprite.sens = .devant
                    case 2:
                        sprite.sens = .derriere
                    case 3:
                        sprite.sens = .gauche
                    case 4:
                        sprite.sens = .droite
                    default:
                        sprite.sens = .aucune
                    }
             
                }
                
            }
        case .gauche:
            let key = (sprite.colonne-1)*1000 + sprite.ranger
            if var c = collection[key] {
                
                if c.character != "m" && c.character != "1" && c.character != "g" && c.character != "u" && c.character != "p" {
                    
                    sprite.colonne -= 1
                    sprite.RefreshPosition()
                    sprite.MarcherGauche()
                    AdvCheckObject(&c, sprite: &sprite)
                   
                    
                } else {
                    let sensMarche = Int(arc4random_uniform(4)) + 1
                    switch sensMarche {
                    case 1:
                        sprite.sens = .devant
                    case 2:
                        sprite.sens = .derriere
                    case 3:
                        sprite.sens = .gauche
                    case 4:
                        sprite.sens = .droite
                    default:
                        sprite.sens = .aucune
                    }
                   
                }
                
            }
            
        default: break
        }
    

    }
    
    
    
    
    
    
    
    
    
    
    
    func Rougir(sprite: SKSpriteNode?) {
        
    }
    
    
    func PlacerPad() {
        
        let taille = CGSize(width: self.frame.height/12, height: self.frame.height/12)
        pad_bas.position = CGPoint(x: self.frame.origin.x + taille.width, y: self.frame.origin.y)
        pad_haut.position = CGPoint(x: self.frame.origin.x + taille.width, y: self.frame.origin.y + taille.width*2)
        pad_gauche.position = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + taille.width)
        pad_droit.position = CGPoint(x: self.frame.origin.x + taille.width*2, y: self.frame.origin.y + taille.width)
        pad_acc.position = CGPoint(x: self.frame.origin.x + taille.width, y: self.frame.origin.y + taille.width)
        pad_bas.zPosition = 1000
        pad_droit.zPosition = 1000
        pad_gauche.zPosition = 1000
        pad_haut.zPosition = 1000
        pad_acc.zPosition = 1000
        pad_bas.alpha = 1.5
        pad_haut.alpha = 1.5
        pad_droit.alpha = 1.5
        pad_gauche.alpha = 1.5
        
        pad_bas.size = taille
        pad_haut.size = taille
        pad_droit.size = taille
        pad_gauche.size = taille
        pad_acc.size = taille
        pad_bas.anchorPoint = CGPointZero
        pad_haut.anchorPoint = CGPointZero
        pad_droit.anchorPoint = CGPointZero
        pad_gauche.anchorPoint = CGPointZero
        pad_acc.anchorPoint = CGPointZero
        self.addChild(pad_gauche)
        self.addChild(pad_droit)
        self.addChild(pad_haut)
        self.addChild(pad_bas)
        self.addChild(pad_acc)
    }
}










