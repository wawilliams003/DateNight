//
//  CustomToastView.swift
//  DateNight
//
//  Created by Wayne Williams on 5/4/23.
//

import UIKit
import Toast
import AVFoundation

class CustomToastView: UIView, AVSpeechSynthesizerDelegate {

    let synthesizer = AVSpeechSynthesizer()
    
    
    @IBOutlet weak var textLabel: UILabel!
    
    
    
    
    @IBAction func cancel() {
        
        
    }
    
    
    func loadSpeech(text: String) {
            textLabel.text = text
            synthesizer.delegate = self
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5
            synthesizer.speak(utterance)
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
            mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.systemPink, range: characterRange)
        textLabel.font = UIFont.systemFont(ofSize: 35, weight: .medium)
        textLabel.attributedText = mutableAttributedString
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        textLabel.attributedText = NSAttributedString(string: utterance.speechString)
        
    }

}



