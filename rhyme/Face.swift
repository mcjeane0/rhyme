//
//  ViewController.swift
//  rhyme
//
//  Created by Arjun Iyer on 11/15/18.
//  Copyright © 2018 Jeane Limited Liability Corporation. All rights reserved.
//

import UIKit


protocol FaceDelegate {
    
    func handlePressBegan()
    
    func handlePressEnded()
    
    func handleTap()
    
    func handleSwipeLeft()
    
    func handleSwipeRight()
    
    func handleSwipeDown()
    
}

class Face: UIViewController {
    
    var delegate : FaceDelegate?
    var tap : UITapGestureRecognizer!
    var press : UILongPressGestureRecognizer!
    var swipeLeft : UISwipeGestureRecognizer!
    var swipeRight : UISwipeGestureRecognizer!
    var swipeDown : UISwipeGestureRecognizer!
    
    static let faceDidAppearNotification = Notification.Name(rawValue: "FaceDidAppearNotification")
    @IBOutlet weak var stateLabel: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func enableGestures(){
        enableTap()
        enablePress()
        enableSwipeLeft()
        enableSwipeRight()
    }
    
    func disableGestures(){
        disableTap()
        disablePress()
        disableSwipeLeft()
        disableSwipeRight()
    }
    
    func enableTap(){
        tap.isEnabled = true
    }
    
    func disableTap(){
        tap.isEnabled = false
    }
    
    func enablePress(){
        press.isEnabled = true
    }
    
    func disablePress(){
        press.isEnabled = false
    }
    
    func enableSwipeLeft(){
        swipeLeft.isEnabled = true
    }
    
    func enableSwipeRight(){
        swipeRight.isEnabled = true
    }
    
    func disableSwipeLeft(){
        swipeLeft.isEnabled = false
    }
    
    func disableSwipeRight(){
        swipeRight.isEnabled = false
    }
    
    @objc func handleSwipeDown(_ gestureRecognizer:UISwipeGestureRecognizer){
        switch gestureRecognizer.state {
        case .ended:
            delegate?.handleSwipeDown()
            break
        default:
            break
        }
        
    }
    
    @objc func handleSwipeRight(_ gestureRecognizer:UISwipeGestureRecognizer){
        switch gestureRecognizer.state {
        case .ended:
            delegate?.handleSwipeRight()
            break
        default:
            break
        }
    }
    
    @objc func handleSwipeLeft(_ gestureRecognizer:UISwipeGestureRecognizer){
        switch gestureRecognizer.state {
        case .ended:
            delegate?.handleSwipeLeft()
            break
        default:
            break
        }
    }
    
    @objc func handleTap(_ gestureRecognizer:UITapGestureRecognizer){
        switch gestureRecognizer.state {
        case .ended:
            let moneyAlert = UIAlertController(title: "Would you like to tip the developer a dollar ($1.00)?", message: "Your tip directly supports software development of .rhyme", preferredStyle: UIAlertController.Style.alert)
            let yesMoney = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { (action) in
                // MARK: present purchase
                self.delegate?.handleTap()
            }
            let noMoney = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) { (action) in
                // MARK: Disappear
            }
            
            moneyAlert.addAction(yesMoney)
            moneyAlert.addAction(noMoney)
            
            self.present(moneyAlert, animated: true) {
                NSLog("moneyAlertPresented")
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 60.0) {
                if moneyAlert.isBeingPresented {
                    moneyAlert.dismiss(animated: true, completion: {
                        NSLog("moneyAlertDismissed")
                    })
                }
            }
            break
        default:
            break
        }
    }
    
    @objc func handlePress(_ gestureRecognizer:UILongPressGestureRecognizer){
        switch gestureRecognizer.state {
        case .began:
            delegate?.handlePressBegan()
            UIView.animate(withDuration: 0.2) {
                self.view.backgroundColor = .white
            }
            break
        case .ended,.cancelled:
            delegate?.handlePressEnded()
            UIView.animate(withDuration: 0.2) {
                self.view.backgroundColor = .black
            }
            break
        default:
            break
        }
    }
    
    @objc func dispatchDotState(_ string:String){
        
        DispatchQueue.main.async {
            
            self.stateLabel.text = string
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.post(Notification(name: Face.faceDidAppearNotification,object:self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        press = UILongPressGestureRecognizer(target: self, action: #selector(handlePress(_:)))
        press.minimumPressDuration = 0.2
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipeLeft.direction = .left
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight(_:)))
        swipeRight.direction = .right
        
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        swipeDown.direction = .down
        
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(press)
        
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeDown)
        
    }


}

