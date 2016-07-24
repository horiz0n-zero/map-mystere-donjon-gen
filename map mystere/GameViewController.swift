//
//  GameViewController.swift
//  map mystere
//
//  Created by Antoine FeuFeu on 29/05/2016.
//  Copyright (c) 2016 Antoine FeuFeu. All rights reserved.
//

import UIKit
import SpriteKit

@available(iOS 9.0, *)
class GameViewController: UIViewController {

    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MaterielObjet = objet()
        MaterielObjet.objetNearest()
        epees = epee()
        
        let vue = self.view as! SKView
        scene = GameScene(size: vue.frame.size)
        scene.scaleMode = .AspectFill
        vue.presentScene(scene)
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
