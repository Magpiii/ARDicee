//
//  ViewController.swift
//  ARDicee
//
//  Created by Hunter Hudson on 11/9/20.
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
        
        /*Creates new SCNBox (cube) predefined AR object (NOTE: chamferRadius is how rounded the edges are, units are in METERS, so watch your measurements):
        */
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
        //Creates a new material that can be applied to AR objects:
        let material = SCNMaterial()
        
        //Sets the diffuse (base) color of the material to red:
        material.diffuse.contents = UIColor.red
        
        /*Sets the cube's materials ot the material made above (NOTE: AR materials are arrays):
        */
        cube.materials = [material]
        
        //Creates a new node (position in 3D space):
        let node = SCNNode()
        
        /*Sets the node's position (NOTE: x-axis position: negative to the left, positive to the right, y-axis position: negative towards the ground, positive towards the ceiling, z-axis position: POSITIVE AWAY FROM USER, NEGATIVE TOWARDS USER):
        */
        node.position = SCNVector3(x: 0, y: 0.1, z: -1.5)
        
        //Sets the node's geometry as the previously created cube.
        node.geometry = cube
        
        //This line adds a "child node" to the "root note" of the sceneView:
        sceneView.scene.rootNode.addChildNode(node)
        
        /*This line allows the sceneView to use lighting from user's surroundings instead of just the scn graph:
        */
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Checks if ARWorldTrackingConfiguraiton is supported:
        if (ARWorldTrackingConfiguration.isSupported) {
            /* Create a session configuration; ARWorldTrackingConfiguration is better because it actually tracks the world around you, but doesn't work if the device doesn't at least have the A9 chip:
            */
            let configuration = ARWorldTrackingConfiguration()
            
            // Run the view's session
            sceneView.session.run(configuration)
        } else {
            //Runs the AR configuration without world tracking if it's not:
            let configuration = AROrientationTrackingConfiguration()
            
            // Run the view's session
            sceneView.session.run(configuration)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
