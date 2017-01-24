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

class CaptureViewController: UIViewController {

    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var topView: UIView!
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
        self.switchCameraBtn.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: {
            self.switchCameraBtn.transform = .identity
        }, completion: nil)

        if self.captureDevice?.position == .front{
            self.addSessionWithCameraPosition(position: .back)
        }else{
             self.addSessionWithCameraPosition(position: .front)
        }
    }
    
    var session: AVCaptureSession!
    var videoOutput: AVCaptureMovieFileOutput?
    var captureDevice: AVCaptureDevice?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var shapeLayer: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSessionWithCameraPosition(position: .front)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground(_:)), name: AppNotification.AppWillEnterForegroundNotificationName, object: App.delegate)
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
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
        animation.duration = 15.0
        self.shapeLayer?.add(animation, forKey: "drawLineAnimation")
        self.view.layer.addSublayer(self.shapeLayer!)
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
                    self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    self.videoPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    self.cameraPreviewView.layer.addSublayer(videoPreviewLayer!)
                    self.cameraPreviewView.bringSubview(toFront: self.topView)
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
       self.captureBtn.backgroundColor = UIColor(red: 199 / 255.0, green: 10 / 255.0, blue: 10 / 255.0, alpha: 1.0)
        switch gesture.state{
        case .began:
            //record
            self.startRecordingAnimation()
            self.startRecording()
        case .ended:
            self.pauseLayer(layer: self.shapeLayer!)
            self.captureBtn.isUserInteractionEnabled = false
            self.stopRecording()
        default:
            break
        }
    }
    
    func pauseLayer(layer: CALayer){
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func createRadomFileName() -> String{
        let filename = UUID().uuidString.appending(".mov")
        return NSTemporaryDirectory().appending(filename)
    }
    
    func startRecording(){
        var  temporaryPath = createRadomFileName()
        let fileManager = FileManager()
        while fileManager.fileExists(atPath: temporaryPath){
            temporaryPath = createRadomFileName()
        }
        let videoURL = URL(fileURLWithPath: temporaryPath)
        self.videoOutput?.startRecording(toOutputFileURL: videoURL, recordingDelegate: self)
    }
    
    func stopRecording(){
        self.videoOutput?.stopRecording()
    }
    
    func playVideoAfterFinishedRecording(withVideoURL url: URL){
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        
        
        let fileManager = FileManager()
        do{
            try fileManager.removeItem(at: url)
            print("file removed")
        }catch let error as NSError{
            print(error.localizedDescription)
        }
    }
}

extension CaptureViewController: AVCaptureFileOutputRecordingDelegate{
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        if error == nil{
            let data = NSData(contentsOf: outputFileURL)
            self.playVideoAfterFinishedRecording(withVideoURL: outputFileURL)
        
            print("stop recording")
        }else{
           print(error.localizedDescription)
        }
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        print("start recording")
    }
}
