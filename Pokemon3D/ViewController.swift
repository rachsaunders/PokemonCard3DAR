//
//  ViewController.swift
//  Pokemon3D
//
//  Created by Rachel Saunders on 11/09/2019.
//  Copyright © 2019 Rachel Saunders. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            
            
            configuration.trackingImages = imageToTrack

            // Amount of pokemon cards to track at one time
            configuration.maximumNumberOfTrackedImages = 1
            
            print("Images Successfully Added")
            
        }
       
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            // Plane will be the width and height of the image reference aka the pokemon card
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            // makes the plane transparent and a bit white
            plane.firstMaterial?.diffuse.contents =  UIColor(white: 1.0, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            
            // turns the plane 90 anticlockwise
            planeNode.eulerAngles.x = -Float.pi / 2
            
            node .addChildNode(planeNode)
            
            if let pokeScene = SCNScene(named: "art.scnassets.eevee.scn") {
                
                if let pokeNode = pokeScene.rootNode.childNodes.first {
                    
                    // clockwise on the y axis
                    pokeNode.eulerAngles.x = .pi / 2
                    
                    planeNode.addChildNode(pokeNode)
                }
                
            }
            
        }
        
        return node
        
    }

}
