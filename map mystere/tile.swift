//
//  tile.swift
//  map mystere
//
//  Created by Antoine FeuFeu on 29/05/2016.
//  Copyright © 2016 Antoine FeuFeu. All rights reserved.
//

import Foundation
import SpriteKit

struct materiel {
    
    let t_herbe = SKTexture(imageNamed: "herbe")
    let t_herbe_fraiche = SKTexture(imageNamed: "herbe_fraiche")
    let t_herbe_clair = SKTexture(imageNamed: "herbe_clair")
    let t_plante = SKTexture(imageNamed: "plant")
    let t_tronc = SKTexture(imageNamed: "tronc")
    let t_plante_moyenne = SKTexture(imageNamed: "grandplant")
    let t_arbre_grand = SKTexture(imageNamed: "garbre")
    let t_arbre = SKTexture(imageNamed: "arbre")
    let t_petit_tronc_couper = SKTexture(imageNamed: "petit_tronc")
    let t_mousse = SKTexture(imageNamed: "mousse")
    let t_caillou_briser = SKTexture(imageNamed: "caillou_briser")
    let t_champignon = SKTexture(imageNamed: "champignon")
    let t_branchette = SKTexture(imageNamed: "branchette")
   
    
}

let texture = materiel()

class texture_manageur {
    
    
    class func genererString(taille tiles: Int) -> [Int: evenement] {
        
        var collection = [Int: evenement]()
        var clePoser: Bool = false
        
        for ranger in 0...tiles {
            
            
            for colonne in 0...tiles {
                
                let clé = ranger*1000 + colonne
                
                if colonne == 0 || colonne == tiles || ranger == 0 || ranger == tiles {
                    
                    var eve = evenement()
                    eve.character = "m"
                    eve.colonne = colonne
                    eve.ranger = ranger
                    
                    collection[clé] = eve
                    
                } else {
                    var eve = evenement()
                    eve.character = "x"
                    eve.colonne = colonne
                    eve.ranger = ranger
                    
                    collection[clé] = eve
                    
                    
                }
                
                
            }
            
            
        }
        // evenement : tout ce qui sera generer de particulier dans la map
        let nombreHazardeux = Int(arc4random_uniform(UInt32(tiles)*2))
        print("nombre d'evenement sur cette map :", nombreHazardeux)
        for _ in 0...nombreHazardeux {
            
            let hazard = Int(arc4random_uniform(7)) + 1
            
            switch hazard {
            case 1: // herbe -> h
                let hazardument = Int(arc4random_uniform(UInt32(tiles - 4)))
                let hazardumentz = Int(arc4random_uniform(UInt32(tiles - 4)))
                var colonne = hazardument
                var ranger = hazardumentz
                
                let tailleH = Int(arc4random_uniform(5)) + 1
                for _ in 1...tailleH {
                    for _ in 1...tailleH {
                        
                        let cler = ranger*1000 + colonne
                        if collection[cler]?.character != "m" {
                            collection[cler]?.character = "h"
                        }
                        ranger += 1
                    }
                    ranger = hazardumentz
                    colonne += 1
                }
            case 2: // g pour grand arbre et 1 pour sa case d acoter
                let hazardument = Int(arc4random_uniform(UInt32(tiles - 4)))
                let hazardumentz = Int(arc4random_uniform(UInt32(tiles - 4)))
                let key = hazardument*1000 + hazardumentz
                
                // regarde au dessus et a coter
                let Acoter = hazardument*1000 + hazardumentz+1
                let Dessu = (hazardument+1)*1000 + hazardumentz
                let Adessu = (hazardument+1)*1000 + hazardumentz+1
                if collection[key] != nil && collection[Acoter] != nil && collection[Dessu] != nil && collection[Adessu] != nil {
                    if collection[key]?.character != "m" && collection[Acoter]?.character != "m" && collection[Dessu]?.character != nil && collection[Adessu]?.character != nil {
                        
                        collection[key]?.character = "g"
                        collection[Acoter]?.character = "1"
                        collection[Dessu]?.character = "1"
                        collection[Adessu]?.character = "1"
                        
                    }
                }
            case 3: // p pour petit tronc
                let hazardument = Int(arc4random_uniform(UInt32(tiles - 4)))
                let hazardumentz = Int(arc4random_uniform(UInt32(tiles - 4)))
                let key = hazardument*1000 + hazardumentz
                if collection[key] != nil {
                    
                    if collection[key]?.character != "m" && collection[key]?.character != "1" && collection[key]?.character != "g" {
                        
                        collection[key]?.character = "p"
                        
                    }
                    
                }
            case 4: // u pour mousse
                let hazardument = Int(arc4random_uniform(UInt32(tiles - 4)))
                let hazardumentz = Int(arc4random_uniform(UInt32(tiles - 4)))
                var colonne = hazardument
                var ranger = hazardumentz
                let key = hazardument*1000 + hazardumentz
                
                if collection[key] != nil {
                    let tailleH = Int(arc4random_uniform(3)) + 1
                    for _ in 1...tailleH {
                        for _ in 1...tailleH {
                            
                            let cler = ranger*1000 + colonne
                            let apparaitra = Int(arc4random_uniform(4)) + 1
                            if collection[cler]?.character != "g" && collection[cler]?.character != "1" && collection[cler]?.character != "p" && collection[cler]?.character != "h" && collection[cler]?.character != "m" && apparaitra == 1 {
                                collection[cler]?.character = "u"
                                let acoter = (ranger+1)*1000 + colonne
                                collection[acoter]?.character = "1"
                            }
                            ranger += 1
                        }
                        ranger = hazardumentz
                        colonne += 1
                    }
                    
                    
                }
            case 5: // caillou et champignon
                let hazardument = Int(arc4random_uniform(UInt32(tiles - 4)))
                let hazardumentz = Int(arc4random_uniform(UInt32(tiles - 4)))
                var colonne = hazardument
                var ranger = hazardumentz
                let key = hazardument*1000 + hazardumentz
                
                if collection[key] != nil {
                    let tailleH = Int(arc4random_uniform(3)) + 1
                    for _ in 1...tailleH {
                        for _ in 1...tailleH {
                            
                            let cler = ranger*1000 + colonne
                            let apparaitra = Int(arc4random_uniform(4)) + 1
                            if collection[cler]?.character != "g" && collection[cler]?.character != "1" && collection[cler]?.character != "p" && collection[cler]?.character != "h" && collection[cler]?.character != "m" {
                                if apparaitra == 1 {
                                    collection[cler]?.character = "a"
                                } else {
                                    collection[cler]?.character = "c"
                                }
                            } 
                            ranger += 1
                        }
                        ranger = hazardumentz
                        colonne += 1
                    }
                    
                    
                }
            case 6: // herbe haute
                let hazardument = Int(arc4random_uniform(UInt32(tiles - 4)))
                let hazardumentz = Int(arc4random_uniform(UInt32(tiles - 4)))
                let key = hazardument*1000 + hazardumentz
                if collection[key] != nil {
                    
                    if collection[key]?.character != "m" && collection[key]?.character != "1" && collection[key]?.character != "g" && collection[key]?.character != "a" && collection[key]?.character != "c" {
                        
                        collection[key]?.character = "b"
                    }
                    
                }
            case 7: // generer des murs
                let hazardument = Int(arc4random_uniform(UInt32(tiles - 4)))
                let hazardumentz = Int(arc4random_uniform(UInt32(tiles - 4)))
                let key = hazardument*1000 + hazardumentz
                
                if collection[key] != nil {
                    
                    
                    if collection[key]?.character != "1" && collection[key]?.character != "g" {
                        
                        collection[key]?.character = "m"
                        let taillex = Int(arc4random_uniform(8)) + 1
                        let tailley = Int(arc4random_uniform(8)) + 1
                        
                        let randomtypeMur = Int(arc4random_uniform(2)) + 1
                        
                        switch randomtypeMur {
                        case 1: // mur en forme de croix
                            for i in 1...taillex {
                                let trou = Int(arc4random_uniform(10))
                                let cler = (hazardument+i)*1000 + hazardumentz
                                if collection[cler] != nil && trou != 1 {
                                    
                                    collection[cler]?.character = "m"
                                    
                                }
                                
                            }
                            for i in 1...tailley {
                                let trou = Int(arc4random_uniform(10))
                                let cler = hazardument*1000 + hazardumentz+i
                                if collection[cler] != nil && trou != 1 {
                                    
                                    collection[cler]?.character = "m"
                                    
                                }
                                
                            }
                            
                            for i in 1...taillex {
                                let trou = Int(arc4random_uniform(10))
                                let cler = (hazardument+(-i))*1000 + hazardumentz
                                if collection[cler] != nil && trou != 1 {
                                    
                                    collection[cler]?.character = "m"
                                    
                                }
                                
                            }
                            for i in 1...tailley {
                                let trou = Int(arc4random_uniform(10))
                                let cler = hazardument*1000 + hazardumentz+(-i)
                                if collection[cler] != nil && trou != 1 {
                                    
                                    collection[cler]?.character = "m"
                                    
                                }
                                
                            }
                            
                        case 2:
                            for i in 1...taillex {
                                let trou = Int(arc4random_uniform(10))
                                let cler = (hazardument+i)*1000 + hazardumentz
                                if collection[cler] != nil && trou != 1 {
                                    
                                    collection[cler]?.character = "m"
                                    
                                }
                                
                            }
                            for i in 1...tailley {
                                let trou = Int(arc4random_uniform(10))
                                let cler = hazardument*1000 + hazardumentz+i
                                if collection[cler] != nil && trou != 1 {
                                    
                                    collection[cler]?.character = "m"
                                    
                                }
                                
                            }
                            
                            for i in 1...taillex {
                                let trou = Int(arc4random_uniform(10))
                                let cler = (hazardument+(-i)+taillex)*1000 + hazardumentz
                                if collection[cler] != nil && trou != 1 {
                                    
                                    collection[cler]?.character = "m"
                                    
                                }
                                
                            }
                            for i in 1...tailley {
                                let trou = Int(arc4random_uniform(10))
                                let cler = hazardument*1000 + hazardumentz+(-i)+tailley
                                if collection[cler] != nil && trou != 1 {
                                    
                                    collection[cler]?.character = "m"
                                    
                                }
                                
                            }
                        default:
                            print(randomtypeMur)
                        }
                        
                        
                    }
                    
                }
                
                
            default: break
            }
            
        }
        // tout ce qui est evenement est coder juste au dessus
        
        // poser la cle "@" dans le niveau
        
        repeat {
            let hazardument = Int(arc4random_uniform(UInt32(tiles - 4)))
            let hazardumentz = Int(arc4random_uniform(UInt32(tiles - 4)))
            let cler: Int = hazardument*1000 + hazardumentz
            
            if collection[cler]?.character == "x" {
                collection[cler]?.character = "@"
                clePoser = true
            }
            
        } while clePoser != true
        
        var NombreDePierrePrecieuse = Int(arc4random_uniform(5)) + 1
        repeat {
            let hazardument = Int(arc4random_uniform(UInt32(tiles - 4)))
            let hazardumentz = Int(arc4random_uniform(UInt32(tiles - 4)))
            
            let cler = hazardument*1000 + hazardumentz
            if collection[cler]?.character == "x" {
                
                collection[cler]?.character = "%"
                NombreDePierrePrecieuse -= 1
                
            }
            
        } while NombreDePierrePrecieuse != 0
        
        var NombreOrb = Int(arc4random_uniform(2)) + 1
        repeat {
            let hazardument = Int(arc4random_uniform(UInt32(tiles - 4)))
            let hazardumentz = Int(arc4random_uniform(UInt32(tiles - 4)))
            
            let cler = hazardument*1000 + hazardumentz
            if collection[cler]?.character == "x" {
                
                collection[cler]?.character = "£"
                NombreOrb -= 1
                
            }
            
        } while NombreOrb != 0
        
        var NombreGelee = Int(arc4random_uniform(15)) + 1
        repeat {
            let hazardument = Int(arc4random_uniform(UInt32(tiles - 4)))
            let hazardumentz = Int(arc4random_uniform(UInt32(tiles - 4)))
            
            let cler = hazardument*1000 + hazardumentz
            if collection[cler]?.character == "x" {
                
                collection[cler]?.character = "-"
                NombreGelee -= 1
                
            }
            
        } while NombreGelee != 0
        
        return collection
        
    }
    class func positioner(inout map: [Int: evenement], frame: CGRect, taille: CGSize, longueur: Int) -> [SKSpriteNode]{
        
        var sprites = [SKSpriteNode]()
        
        
        for colonne in 0...longueur {
            
            for ranger in 0...longueur {
                
                let key = colonne*1000 + ranger
                
                
                if let carac = map[key]?.character {
                    
                    
                    
                    let sprite = SKSpriteNode(texture: texture.t_herbe_fraiche)
                    sprite.size = taille
                    sprite.position = CGPoint(x: frame.origin.x + taille.width*CGFloat(colonne), y: frame.origin.y + taille.height*CGFloat(ranger))
                    sprite.zPosition = -1
                    sprite.anchorPoint = CGPointZero
                    sprite.texture?.filteringMode = .Nearest
                    sprites.append(sprite)
                    switch carac {
                    case "g": // grand arbre
                        let sprite = SKSpriteNode(texture: texture.t_arbre_grand)
                        sprite.size = CGSize(width: taille.width*1.5, height: taille.width*2.1)
                        sprite.position = CGPoint(x: frame.origin.x + taille.width*CGFloat(colonne), y: frame.origin.y + taille.height*CGFloat(ranger))
                        sprite.anchorPoint = CGPointZero
                        sprite.zPosition = 4
                        sprite.texture?.filteringMode = .Nearest
                        sprites.append(sprite)
                        map[key]!.sprites = sprite
                    case "h": // herbe
                        let sprite = SKSpriteNode(texture: texture.t_plante)
                        sprite.size = taille
                        sprite.position = CGPoint(x: frame.origin.x + taille.width*CGFloat(colonne), y: frame.origin.y + taille.height*CGFloat(ranger))
                        sprite.anchorPoint = CGPointZero
                        sprite.zPosition = 1
                        sprite.texture?.filteringMode = .Nearest
                        sprites.append(sprite)
                        map[key]!.sprites = sprite
                    case "m": // arbre de bordure
                        let sprite = SKSpriteNode(texture: texture.t_plante_moyenne)
                        sprite.size = taille
                        sprite.position = CGPoint(x: frame.origin.x + taille.width*CGFloat(colonne), y: frame.origin.y + taille.height*CGFloat(ranger))
                        sprite.anchorPoint = CGPointZero
                        sprite.zPosition = 3
                        sprite.texture?.filteringMode = .Nearest
                        sprites.append(sprite)
                        map[key]!.sprites = sprite
                    case "p": // petit tronc
                        let sprite = SKSpriteNode(texture: texture.t_petit_tronc_couper)
                        sprite.size = taille
                        sprite.position = CGPoint(x: frame.origin.x + taille.width*CGFloat(colonne), y: frame.origin.y + taille.height*CGFloat(ranger))
                        sprite.anchorPoint = CGPointZero
                        sprite.zPosition = 3
                        sprite.texture?.filteringMode = .Nearest
                        sprites.append(sprite)
                        map[key]!.sprites = sprite
                    case "u": // mousse
                        let sprite = SKSpriteNode(texture: texture.t_tronc)
                        sprite.size = CGSize(width: taille.width*2, height: taille.width)
                        sprite.position = CGPoint(x: frame.origin.x + taille.width*CGFloat(colonne), y: frame.origin.y + taille.height*CGFloat(ranger))
                        sprite.anchorPoint = CGPointZero
                        sprite.zPosition = 5
                        sprite.texture?.filteringMode = .Nearest
                        sprites.append(sprite)
                        map[key]!.sprites = sprite
                    case "c": // caillou -> c
                        let sprite = SKSpriteNode(texture: texture.t_caillou_briser)
                        sprite.size = taille
                        sprite.position = CGPoint(x: frame.origin.x + taille.width*CGFloat(colonne), y: frame.origin.y + taille.height*CGFloat(ranger))
                        sprite.anchorPoint = CGPointZero
                        sprite.zPosition = 2
                        sprite.texture?.filteringMode = .Nearest
                        sprites.append(sprite)
                        map[key]!.sprites = sprite
                    case "a": // champigon -> a
                        let sprite = SKSpriteNode(texture: texture.t_champignon)
                        sprite.size = taille
                        sprite.position = CGPoint(x: frame.origin.x + taille.width*CGFloat(colonne), y: frame.origin.y + taille.height*CGFloat(ranger))
                        sprite.anchorPoint = CGPointZero
                        sprite.zPosition = 2
                        sprite.texture?.filteringMode = .Nearest
                        sprites.append(sprite)
                        map[key]!.sprites = sprite
                    case "b": // branchette -> b
                        let sprite = SKSpriteNode(texture: texture.t_branchette)
                        sprite.size = CGSize(width: taille.width, height: taille.width*1.64)
                        sprite.position = CGPoint(x: frame.origin.x + taille.width*CGFloat(colonne), y: frame.origin.y + taille.height*CGFloat(ranger))
                        sprite.anchorPoint = CGPointZero
                        sprite.zPosition = 3
                        sprite.texture?.filteringMode = .Nearest
                        sprites.append(sprite)
                        map[key]!.sprites = sprite
                    case "@": // la cle mythique !
                        let sprite = SKSpriteNode(texture: MaterielObjet.t_cle)
                        sprite.size = CGSize(width: taille.width*0.5, height: taille.width*0.5)
                        sprite.position = CGPoint(x: frame.origin.x + taille.width*CGFloat(colonne) + sprite.size.width/4, y: frame.origin.y + taille.height*CGFloat(ranger) + sprite.size.width/4)
                        sprite.anchorPoint = CGPointZero
                        sprite.zPosition = 5
                        sprite.texture?.filteringMode = .Nearest
                        sprites.append(sprite)
                        map[key]!.sprites = sprite
                    case "%": // pierre precieuse
                        let sprite = SKSpriteNode(texture: MaterielObjet.t_pierre_verte)
                        sprite.size = CGSize(width: taille.width*0.5, height: taille.width*0.5)
                        sprite.position = CGPoint(x: frame.origin.x + taille.width*CGFloat(colonne) + sprite.size.width/4, y: frame.origin.y + taille.height*CGFloat(ranger) + sprite.size.width/4)
                        sprite.anchorPoint = CGPointZero
                        sprite.zPosition = 4
                        sprite.texture?.filteringMode = .Nearest
                        sprites.append(sprite)
                        map[key]!.sprites = sprite
                    case "£": // orbe doree
                        let sprite = SKSpriteNode(texture: MaterielObjet.t_orbe_doree)
                        sprite.size = CGSize(width: taille.width*0.5, height: taille.width*0.5)
                        sprite.position = CGPoint(x: frame.origin.x + taille.width*CGFloat(colonne) + sprite.size.width/2, y: frame.origin.y + taille.height*CGFloat(ranger) + sprite.size.width/2)
                        sprite.anchorPoint = CGPointZero
                        sprite.zPosition = 4
                        sprite.texture?.filteringMode = .Nearest
                        sprites.append(sprite)
                        map[key]!.sprites = sprite
                    case "-": // gelee verte
                        let sprite = SKSpriteNode(texture: MaterielObjet.t_gelee_verte)
                        sprite.size = CGSize(width: taille.width*0.5, height: taille.width*0.5)
                        sprite.position = CGPoint(x: frame.origin.x + taille.width*CGFloat(colonne) + sprite.size.width/3, y: frame.origin.y + taille.height*CGFloat(ranger) + sprite.size.width/3)
                        sprite.anchorPoint = CGPointZero
                        sprite.zPosition = 4
                        sprite.texture?.filteringMode = .Nearest
                        sprites.append(sprite)
                        map[key]!.sprites = sprite
                    case "x": break // par default pour indiquer qu'il n'y a rien a mettre
                    case "1": break // exception ! 1 designe la case a coter d'un arbre
                    case "2": break // exception ! 2 designe la case a coter d'un tronc
                    default:
                        let sprite = SKSpriteNode(color: UIColor.redColor(), size: taille)
                        sprite.position = CGPoint(x: frame.origin.x + taille.width*CGFloat(colonne), y: frame.origin.y + taille.height*CGFloat(ranger))
                        sprite.anchorPoint = CGPointZero
                        sprite.blendMode = .Replace
                        sprite.texture?.filteringMode = .Nearest
                        sprites.append(sprite)
                    }
                }
            }
        }
        
        return sprites
    }

    
    
}












