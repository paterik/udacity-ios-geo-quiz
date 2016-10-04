//
//  QuizViewController.swift
//  GeoQuiz
//
//  Created by Jarrod Parkes on 6/21/16.
//  Additions by Patrick Paechnatz on 10/04/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

//
// MARK: - QuizViewController: UIViewController
//
class QuizViewController: UIViewController {
  
    //
    // MARK: Outlets
    //
    @IBOutlet weak var flagButton1: UIButton!
    @IBOutlet weak var flagButton2: UIButton!
    @IBOutlet weak var flagButton3: UIButton!
    @IBOutlet weak var repeatPhraseButton: UIButton!
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackViewRow1: UIStackView!
    @IBOutlet weak var innerStackViewRow2: UIStackView!
    @IBOutlet weak var innerStackViewRow3: UIStackView!
    @IBOutlet weak var innerStackViewRow4: UIStackView!
  
    //
    // MARK: Properties
    //
    var languageChoices = [Country]()
    var lastRandomLanguageID = -1
    var selectedRow = -1
    var correctButtonTag = -1
    var currentState: QuizState = .NoQuestionUpYet
    var spokenText = ""
    var bcpCode = ""
    
    let speechSynth = AVSpeechSynthesizer()
    let quizNodes: [[String : AnyObject]]  = [
        ["name": "Czech", "bcp47Code": "cs-CZ", "textToRead": "Učení je celoživotní výkon.", "flagImageName": "czechFlag"],
        ["name": "Danish", "bcp47Code": "da-DK", "textToRead": "Læring er en livslang stræben.", "flagImageName": "denmarkFlag"],
        ["name": "German", "bcp47Code": "de-DE", "textToRead": "Lernen ist eine lebenslange Reise.", "flagImageName": "germanyFlag"],
        ["name": "Spanish", "bcp47Code": "es-ES", "textToRead": "El aprendizaje es una búsqueda que dura toda la vida.", "flagImageName": "spainFlag"],
        ["name": "French", "bcp47Code": "fr-FR", "textToRead": "L'apprentissage est une longue quête de la vie.", "flagImageName": "franceFlag"],
        ["name": "Polish", "bcp47Code": "pl-PL", "textToRead": "Uczenie się przez całe życie pościg.", "flagImageName": "polandFlag"],
        ["name": "English", "bcp47Code": "en-US", "textToRead": "Learning is a life long pursuit.", "flagImageName": "unitedStatesFlag"],
        ["name": "Portuguese", "bcp47Code": "pt-BR", "textToRead": "A aprendizagem é um longa busca que dura toda a vida.", "flagImageName": "brazilFlag"],
    ]
    
    //
    // MARK: Life Cycle
    //
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        resetButtonToState(.NoQuestionUpYet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLanguages()
    }
    
    //
    // MARK: Actions
    //
    @IBAction func hearPhrase(sender: UIButton) {
        // This function runs to code for when the button says "Hear Phrase" or when it says Stop.
        // The first check is to see if we are speaking, in which case the button would have been labeled STOP
        // If iOS is currently speaking we tell it to stop and reset the buttons
        if currentState == .PlayingAudio {
            stopAudio()
            resetButtonToState(.ReadyToSpeak)
        } else if currentState == .NoQuestionUpYet {
            // no Question so choose a language and question
            chooseNewLanguageAndSetupButtons()
            speak(spokenText, languageCode: bcpCode)
        } else if currentState == .QuestionDisplayed || currentState == .ReadyToSpeak {
            // Flags are up so just replay the audio
            speak(spokenText, languageCode: bcpCode)
        }
    }

    @IBAction func flagButtonPressed(sender: UIButton) {
        if (sender.tag == correctButtonTag) {
            displayAlert("Correct", messageText: "Right on!")
        } else {
            displayAlert("Incorrect", messageText: "Nope. try again")
        }
    }
}
