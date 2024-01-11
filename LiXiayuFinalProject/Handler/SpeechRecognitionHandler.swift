//
//  SpeechRecognitionHandler.swift
//  LiXiayuFinalProject
//
//  Created by Shayet on 12/4/23.

import Foundation
import Speech

// The SpeechRecognizer class handles speech recognition functionality, converting speech to text
class SpeechRecognizer: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    // SFSpeechRecognizer instance to manage speech recognition
    private let speechRecognizer = SFSpeechRecognizer()
    // A request object that handles the speech recognition requests
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    // The recognition task where the speech recognition occurs
    private var recognitionTask: SFSpeechRecognitionTask?
    // The audio engine used to process the audio stream
    private let audioEngine = AVAudioEngine()

    // Published property that contains the transcribed text from speech
    @Published var transcribedText: String = ""
    // Published property to indicate whether recording is currently happening
    @Published var isRecording = false
    // Published property to indicate if speech recognition access is denied
    @Published var isSpeechRecognitionDenied = false

    override init() {
        super.init()
        // Set the delegate
        self.speechRecognizer?.delegate = self

        // Request authorization for speech recognition
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self.isSpeechRecognitionDenied = false
                default:
                    self.isSpeechRecognitionDenied = true
                }
            }
        }
    }

    // Function to start or stop transcribing speech
    func transcribe() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    // Function to start the recording and transcription process
    private func startRecording() {
        // If a recognition task is running, cancel it and start a new one
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        // Prepare the audio session for recording
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set up audio session.")
            return
        }

        // Initialize a recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        // Get the audio input node, configure the recognition request, and start the recognition task
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }

        // Configure the recognition request to report partial results
        recognitionRequest.shouldReportPartialResults = true

        // Start the recognition task with a completion handler to process the speech recognition results
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false

            if let result = result {
                // Update the transcribed text with the latest results
                self.transcribedText = result.bestTranscription.formattedString
                isFinal = result.isFinal // Update the isFinal flag based on the results.
            }

            // If an error occurs or the result is final, stop the audio engine and cleanup
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                self.isRecording = false // Update the recording state.
            }
        }

        // Set up the audio input node with a tap to forward audio frames to the recognition request
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        // Prepare and start the audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
            isRecording = true // Update the recording state to true
        } catch {
            print("Audio engine failed to start.") // Handle audio engine start failures
        }
    }

    // Function to stop the recording process and clean up
    private func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()

        // Clear out the recognition request and task
        recognitionRequest = nil
        recognitionTask = nil
        
        isRecording = false
    }
}
