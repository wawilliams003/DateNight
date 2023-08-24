//
//  TextToSpeechViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 8/23/23.
//

import UIKit
import AVFAudio

class TextToSpeechViewController: UIViewController, AVSpeechSynthesizerDelegate {

    let synthesizer = AVSpeechSynthesizer()
    
    
    @IBOutlet weak var textLabel: UILabel!
    
    var textInfo: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AVSpeechSynthesisVoice.speechVoices()
        
        loadSpeech(text: textInfo!)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func loadSpeech(text: String) {
            textLabel.text = text
            synthesizer.delegate = self
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.4
            synthesizer.speak(utterance)
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
            mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.systemPink, range: characterRange)
        textLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        textLabel.attributedText = mutableAttributedString
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        textLabel.attributedText = NSAttributedString(string: utterance.speechString)
        dismiss(animated: true)
    }
    
    @IBAction func closeBtn() {
        dismiss(animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
