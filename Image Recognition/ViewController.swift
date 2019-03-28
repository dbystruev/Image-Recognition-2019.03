//
//  ViewController.swift
//  Image Recognition
//
//  Created by Denis Bystruev on 28/03/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        let images = ARReferenceImage.referenceImages(inGroupNamed: "images", bundle: nil)
        
        configuration.detectionImages = images

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARImageAnchor else { return }
        
        let planeNode = createPlane(imageAnchor: anchor)
        
        planeNode.runAction(
            .sequence([
                .wait(duration: 5),
                .fadeOut(duration: 2),
                .removeFromParentNode()
            ])
        )
        
        node.addChildNode(planeNode)
    }
}

// MARK: - Methods
extension ViewController {
    func createPlane(imageAnchor: ARImageAnchor) -> SCNNode {
        
        let image = imageAnchor.referenceImage
        let size = image.physicalSize
        let plane = SCNPlane(width: size.width, height: size.height)
        let node = SCNNode(geometry: plane)
        
        plane.firstMaterial?.diffuse.contents = UIImage(named: "washington-drivers-license")
        node.eulerAngles.x = -.pi / 2
        
        return node
    }
}
