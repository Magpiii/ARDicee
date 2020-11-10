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
    
    //Init diceArray as empty array of SCNNode objects:
    var diceArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        /*While this line will eventually be commented out, it is good during testing because it allows the developer to see things (like geometric guides for example) that normally aren't visible to the end user, but are helpful during testing:
        */
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        /*Creates new SCNBox (cube) predefined AR object (NOTE: chamferRadius is how rounded the edges are, units are in METERS, so watch your measurements):
         
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        */
        
        //Creates a new material that can be applied to AR objects:
        let material = SCNMaterial()
        
        /*Sets the diffuse (base) color of the material to red:
        material.diffuse.contents = UIColor.red
        */
        
        //Sets the contents of the material to the moon image asset using its filepath:
        material.diffuse.contents = UIImage(named: "art.scnassets/8k_moon.jpg")
        
        /*Sets the cube's materials ot the material made above (NOTE: AR materials are arrays):
        
        cube.materials = [material]
        */
        
        //Creates a new node (position in 3D space):
        let node = SCNNode()
        
        /*Sets the node's position (NOTE: x-axis position: negative to the left, positive to the right, y-axis position: negative towards the ground, positive towards the ceiling, z-axis position: POSITIVE AWAY FROM USER, NEGATIVE TOWARDS USER):
        */
        node.position = SCNVector3(x: 0, y: 0.1, z: -1.5)
        
        /*Sets the node's geometry as the previously created cube.
        node.geometry = cube
        */
        
        //This line adds a "child node" to the "root note" of the sceneView:
        sceneView.scene.rootNode.addChildNode(node)
        
        /*This line allows the sceneView to use lighting from user's surroundings instead of just the scn graph:
        */
        sceneView.autoenablesDefaultLighting = true
        
        /*Creates a new Scene object as a sphere this time (NOTE: measurements are still in METERS):
        
        let sphere = SCNSphere(radius: 0.2)
        
        //Assigns the material made above to the sphere:
        sphere.materials = [material]
        
        //Sets the node's geometry to the sphere made above:
        node.geometry = sphere
        
        //Initializes a new scene with the filepath of the dice object:
        let diceScene = SCNScene(named: "art.scnassets/diceeColada copy.scn")
        
        /*Initializes the node of the dice object to the node of the dice object in the scene tree (NOTE: "recursively" parameter is a bool for whether or not you wnat to include every single other object in the tree for the scene):
        */
        let diceNode = diceScene?.rootNode.childNode(withName: "Dice", recursively: true)
        
        //Sets the diceNode's position:
        if let safeDiceNode = diceNode{
            safeDiceNode.position = SCNVector3(x: 0, y: 0, z: 0.1)
            
            //Adds the diceNode to the rootNode of the sceneView:
            sceneView.scene.rootNode.addChildNode(safeDiceNode)
        }
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Checks if ARWorldTrackingConfiguraiton is supported:
        if (ARWorldTrackingConfiguration.isSupported) {
            /* Create a session configuration; ARWorldTrackingConfiguration is better because it actually tracks the world around you, but doesn't work if the device doesn't at least have the A9 chip:
            */
            let configuration = ARWorldTrackingConfiguration()
            
            //Sets the configuration of the sceneView to recognize horizontal planes:
            configuration.planeDetection = .horizontal
            
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
    
    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
        //Rolls all dice once the barButton item is pressed:
        rollAll()
    }
    
    @IBAction func removeAllDice(_ sender: UIBarButtonItem) {
        //If the diceArray isn't empty...
        if !diceArray.isEmpty {
            for dice in diceArray {
                //Removes all dice from the parent node (in this case, the root node):
                dice.removeFromParentNode()
            }
        }
    }
    
    //This method is called after the user shakes the device:
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        //Rolls all dice if the user shakes the device (hey, that rhymes!):
        rollAll()
    }
    
    
    /*This method triggers when the user touches a location on the screen. The location is then converted into an AR location in the world:
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*If we were using multitouch, we wouldn't use first here, but since we're only worried about one touch for this example, "touches.first" (which is the first detected touch in an array of detected touches) is optionally bound here:
        */
        if let touch = touches.first {
            /*Init new constant touchLocation equal to the location touched in the AR sceneView:
            */
            let touchLoctaion = touch.location(in: sceneView)
            
            /*Init new constant "results" equal to the results of a "hitTest" (takes the 2D geometric data and transfers it to the 3D coordinates of where the tap would be in the real world using the camera):
            */
            let results = sceneView.hitTest(touchLoctaion, types: .existingPlaneUsingExtent)
            
            //If the hitTest succeeded and it found a position on an existing plane...
            if !results.isEmpty {
                print("Horizontal plane detected.")
            } else {
                print("Error code 1: no plane detected.")
            }
            
            /*Optionally bind hitResult to the first element of the results array if the hitTest got a result:
            */
            if let hitResult = results.first{
                print(hitResult)
                
                //Initializes a new scene with the filepath of the dice object:
                let diceScene = SCNScene(named: "art.scnassets/diceeColada copy.scn")
                
                /*Initializes the node of the dice object to the node of the dice object in the scene tree (NOTE: "recursively" parameter is a bool for whether or not you wnat to include every single other object in the tree for the scene):
                */
                if let diceNode = diceScene?.rootNode.childNode(withName: "Dice", recursively: true){
                
                /*Sets the diceNode's position as the position (which is the number 3 after ".columns") of the x, y, and z components of the hitTest result (NOTE: the radius of the diceNode is added to the y parameter, otherwise half of the dice object will be sunk into the plane instead of the dice appearing above the plane):
                */
                    diceNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: (hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius), z: hitResult.worldTransform.columns.3.z)
                    
                    //Appends the diceNode to the array of diceNodes:
                    diceArray.append(diceNode)
                    
                    //Adds the diceNode to the rootNode of the sceneView:
                    sceneView.scene.rootNode.addChildNode(diceNode)
                    
                    roll(dice: diceNode)
        }
    }
}
}
            
    func rollAll() {
        //If diceArray isn't empty...
        if !diceArray.isEmpty {
            //Rolls each dice in the diceArray:
            for dice in diceArray{
                roll(dice: dice)
            }
            
        }
    }
    
    func roll(dice: SCNNode) {
        /*Creates a new constant x equal to a random dice face between 1 and 4 and multiplies it by pi / 2 because half of pi is 90 deg, so the dice will show a new face every time (the "+ 1" is a vertical transformation upward):
        */
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)
        
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)
        
        /*Makes the dice rotate using the predefined SCNAction "rotateBy" (y is 0 because it doesn't need to rotate on the y-axis, there would be no point); duration parameter is in seconds; randomX and randomZ are multiplied by 10 to make the animation go faster and look more badass:
        */
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 10), y: 0, z: CGFloat(randomZ * 10), duration: 0.5))
    }
    
    /*This method is called when a node is added to the sceneView (NOTE: the "ARAnchor" is a position on a horizontal plane on which an AR object can be placed):
    */
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //Checks if anchor is of type ARPlaneAnchor (this block prevents runtime errors):
        if anchor is ARPlaneAnchor {
            print("Plane detected.")
            
            /*If anchor is of type ARPlaneAnchor, downcasts planeAnchor constant as ARPlaneAnchor:
            */
            let planeAnchor = anchor as! ARPlaneAnchor
            
            /*Initializes a new constant plane equal to a SCNPlane at the extent of planeAnchor at x and z positions (NOTE: do not use y for the second parameter, as height refers to the distance from the user):
            */
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            //Initializes planeNode as a SCNNode object:
            let planeNode = SCNNode()
            
            /*Sets the position of the planeNode as the center of the planeAnchor. REMEMBER: y is typically unmodified because if it isn't, the object will wind up above (or worse, below) the horizontal plane, which would be pointless:
            */
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
            /*SCNNodes are vertical by default, so a transformation is necessary to make planeNode horizontal. Since we're rotating using the x-axis (vertical to horizontal), the x axis is the only parameter that is not equal to zero (NOTE: parameters for this rotation are in RADIANS, not DEGREES. Also, can use "Float.pi" predefined property in order to work with pi. Float.pi is negative since we're rotating counterclockwise in order to make the vertical plane horizontal):
            */
            planeNode.transform = SCNMatrix4MakeRotation((-Float.pi / 2), 1, 0, 0)
            
            //Creates a new material for the grid of the plane:
            let gridMaterial = SCNMaterial()
            
            //Sets the gridMaterial's contents to an image with the grid's filepath:
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            //Adds gridMaterial to plane:
            plane.materials = [gridMaterial]
            
            //Sets the geometry of the planeNode to the plane object:
            planeNode.geometry = plane
            
            /*Uses the inputted node parameter of the method to insert the planeNode as a child node:
            */
            node.addChildNode(planeNode)
        } else {
            //Exits the method if the plane isn't detected (this prevents runtime errors).
            return
        }
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
