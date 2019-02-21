//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Geek on 11/27/18.
//  Copyright © 2018 Geek. All rights reserved.
//
import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{
    
    var audioRecorder : AVAudioRecorder!
   
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let modelName = UIDevice()
//        if(modelName.name == "iPhone SE"){
//        let horizontalConstraint = NSLayoutConstraint(item: recordButton, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
//        let verticalConstraint = NSLayoutConstraint(item: recordButton, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 160)
//         NSLayoutConstraint.activate([horizontalConstraint,verticalConstraint])
//    }
        stopRecordingButton.isEnabled = false
    }
    @IBAction func recordAudio(_ sender: AnyObject) {
        configureUI(recording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord)), mode:.default)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(recording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    func configureUI(recording: Bool){
        recordingLabel.text = recording ? "Recording in Progress" : "Tap to Record"
        stopRecordingButton.isEnabled = recording
        recordButton.isEnabled = !recording
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        flag ? performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url) : print("recording was not successful")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard segue.identifier == "stopRecording" else { return }
        guard let playSoundsVC = segue.destination as? PlaySoundsViewController else { return }
        guard let recordedAudioURL = sender as? URL else { return }
        playSoundsVC.recordedAudioURL = recordedAudioURL
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
