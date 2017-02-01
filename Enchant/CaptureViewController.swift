//
//  ViewController.swift
//  Enchant
//
//  Created by Xie kesong on 1/22/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Parse

fileprivate let captureBtnActiveColor = UIColor(red: 199 / 255.0, green: 10 / 255.0, blue: 10 / 255.0, alpha: 1.0)
fileprivate let captureBtnDeActiveColor = UIColor.white
fileprivate let obeserverKeyPath = "status"
fileprivate let maximumVideoTimeInterval = 10.0

class CaptureViewController: UIViewController {

    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var cameraControlView: UIView!
    @IBOutlet weak var switchCameraBtn: UIButton!
    @IBOutlet weak var captureBtn: UIButton!{
        didSet{
            let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(captureBtnPressing(_:)))
            self.captureBtn.addGestureRecognizer(longPressed)
            self.captureBtn.becomeCircleView()
        }
    }
    
    @IBOutlet weak var captureBtnBorder: UIVisualEffectView!{
        didSet{
            self.captureBtnBorder.becomeCircleView()
        }
    }
    
    
    @IBAction func switchCameraBtnTapped(_ sender: UIButton) {
        self.switchCameraBtn.animateBounceView()
        if self.captureDevice?.position == .front{
            self.addSessionWithCameraPosition(position: .back)
        }else{
             self.addSessionWithCameraPosition(position: .front)
        }
    }
    
    //record a video UI
    var session: AVCaptureSession!
    var videoOutput: AVCaptureMovieFileOutput?
    var captureDevice: AVCaptureDevice?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var shapeLayer: CAShapeLayer?
    
    //play the recorded video UI
    @IBOutlet weak var cancelVideoBtn: UIButton!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var playerView: PlayerView!
    @IBAction func cancelVideo(_ sender: UIButton) {
        sender.animateBounceView()
        self.resetPlayer()
        self.captureBtn.isUserInteractionEnabled = true
        self.captureBtn.backgroundColor = captureBtnDeActiveColor
        self.view.bringSubview(toFront: self.cameraPreviewView)
    }

    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var playerItemContext: UnsafeMutableRawPointer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSessionWithCameraPosition(position: .back)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground(_:)), name: AppNotification.AppWillEnterForegroundNotificationName, object: App.delegate)
    }
    
    
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func appWillEnterForeground(_ notification: Notification){
        let position: AVCaptureDevicePosition =  self.captureDevice?.position ?? .back
        self.addSessionWithCameraPosition(position: position)
    }
    
    func addSessionWithCameraPosition(position: AVCaptureDevicePosition){
        self.session = AVCaptureSession()
        self.session.sessionPreset = AVCaptureSessionPresetMedium
        self.captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType:  AVMediaTypeVideo, position: position)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if session.canAddInput(input) {
                session.addInput(input)
                self.videoOutput = AVCaptureMovieFileOutput()
                if session!.canAddOutput(videoOutput) {
                    session!.addOutput(videoOutput)
                    self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                    self.videoPreviewLayer.frame = UIScreen.main.bounds
                    self.playerView.frame = UIScreen.main.bounds
                    self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    self.videoPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    self.cameraPreviewView.layer.addSublayer(videoPreviewLayer!)
                    self.cameraPreviewView.bringSubview(toFront: self.cameraControlView)
                    session!.startRunning()
                }else{
                    self.videoOutput = nil
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func captureBtnPressing(_ gesture: UILongPressGestureRecognizer){
       self.captureBtn.backgroundColor = captureBtnActiveColor
        switch gesture.state{
        case .began:
            //record
            self.startRecording()
        case .ended:
            self.stopRecording()
        default:
            break
        }
    }
    
    /*
     * start recording video, triggered when the user long pressed the capture button
     */
    func startRecording(){
        self.startRecordingAnimation()
        var  temporaryPath = createRadomFileName(withExtension: ".mov")
        let fileManager = FileManager()
        while fileManager.fileExists(atPath: temporaryPath){
            temporaryPath = createRadomFileName(withExtension: ".mov")
        }
        let videoURL = URL(fileURLWithPath: temporaryPath)
        self.videoOutput?.startRecording(toOutputFileURL: videoURL, recordingDelegate: self)
    }

    
    /*
     * stop video recording, triggered when the user release the capture button
     */
    func stopRecording(){
        self.pauseLayer(layer: self.shapeLayer!)
        self.captureBtn.isUserInteractionEnabled = false
        self.videoOutput?.stopRecording()
    }
    
    /*
     * start an animation layer for the recording wheel
     */
    func startRecordingAnimation(){
        self.shapeLayer = CAShapeLayer()
        let path = UIBezierPath(arcCenter: self.captureBtn.center, radius: 40.0, startAngle: -CGFloat.pi / 2.0, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        self.shapeLayer?.path = path.cgPath
        self.shapeLayer?.strokeColor = UIColor.white.cgColor
        self.shapeLayer?.fillColor = UIColor.clear.cgColor
        self.shapeLayer?.lineWidth = 4.0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        /* set up animation */
        animation.fromValue = 0.0
        //        animation.toValue = 1.0
        animation.duration = maximumVideoTimeInterval
        animation.delegate = self
        self.shapeLayer?.add(animation, forKey: "drawLineAnimation")
        self.view.layer.addSublayer(self.shapeLayer!)
    }
    
    
    /*
     * pause the currently animating layer
     */
    func pauseLayer(layer: CALayer){
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    
    func playVideoAfterFinishedRecording(withVideoURL url: URL){
        let asset = AVAsset(url: url)
        let assetsKey = ["playable"]
        self.playerItem =  AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetsKey)
        self.playerItem?.addObserver(self, forKeyPath: obeserverKeyPath, options: .new, context: self.playerItemContext)
        self.player = AVPlayer(playerItem: self.playerItem)
        self.playerView?.player = self.player;
        self.playerView.playerLayer.videoGravity =  AVLayerVideoGravityResizeAspectFill
        NotificationCenter.default.addObserver(self, selector: #selector(didPlayToEnd(_:)), name: AppNotification.AVPlayerItemDidPlayToEndTimeNotificationName, object: nil)
        
        
        
//        let post = PFObject(className: "Post")
//        post["description"] = "hello world"
//        do{
//            let data = try Data(contentsOf: url)
//            post["media"] = PFFile(data: data)
//            post.saveInBackground { (success, error) in
//                if success{
//                    print("video saved")
//                }else{
//                    if error != nil{
//                        print(error!.localizedDescription)
//                    }
//                }
//            }
//        }catch let error as NSError{
//            print(error.localizedDescription)
//        }
        
        
        
        
//        let fileManager = FileManager()
//        do{
//            try fileManager.removeItem(at: url)
//            print("file removed")
//        }catch let error as NSError{
//            print(error.localizedDescription)
//        }
    }
    
    /**
     * handle the playerItem status update, play video when status equals to .readyToPlay
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == self.playerItemContext{
            DispatchQueue.main.async {
                if self.player?.currentItem != nil && self.player?.currentItem?.status == .readyToPlay{
                    self.shapeLayer?.removeFromSuperlayer()
                    self.view.bringSubview(toFront: self.previewView)
                    self.previewView.isHidden = false
                    self.player?.play()
                    
                }
            }
            return
        }
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
    
    func didPlayToEnd(_ notification: Notification){
        self.player?.seek(to: kCMTimeZero)
        self.player?.play()
    }
    
    func resetPlayer(){
        self.playerItem?.removeObserver(self, forKeyPath: obeserverKeyPath, context: self.playerItemContext)
        self.playerItemContext = nil
        self.player?.pause()
    }
    
}

extension CaptureViewController: AVCaptureFileOutputRecordingDelegate{
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
    }

    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        if error == nil{
            self.playVideoAfterFinishedRecording(withVideoURL: outputFileURL)
        }else{
           print(error.localizedDescription)
        }
    }
}

extension CaptureViewController: CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.stopRecording()
    }
}
