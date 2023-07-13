//
//  ViewController.swift
//  multimedia-homeworks
//
//  Created by Евгения Шевякова on 08.07.2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "play.fill"), for: .normal)
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "stop.fill"), for: .normal)
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "backward.end.fill"), for: .normal)
        button.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "forward.end.fill"), for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var soundNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .light)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var player = AVAudioPlayer()
    
    private var trackNames = [
        "Show_Must_Go_On",
        "Bohemian_Rhapsody",
        "I_Want_To_Break_Free",
        "We_Are_The_Champions",
        "We_Will_Rock_You",
    ]
    private var currentTrack: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        view.addSubview(playButton)
        view.addSubview(stopButton)
        view.addSubview(soundNameLabel)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            soundNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            soundNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            soundNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            playButton.heightAnchor.constraint(equalToConstant: 100),
            playButton.widthAnchor.constraint(equalToConstant: 100),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            
            stopButton.heightAnchor.constraint(equalTo: playButton.heightAnchor),
            stopButton.widthAnchor.constraint(equalTo: playButton.widthAnchor),
            stopButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
            
            previousButton.heightAnchor.constraint(equalTo: playButton.heightAnchor),
            previousButton.widthAnchor.constraint(equalTo: playButton.widthAnchor),
            previousButton.centerXAnchor.constraint(equalTo: playButton.centerXAnchor),
            previousButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor, constant: 80),
            
            nextButton.heightAnchor.constraint(equalTo: playButton.heightAnchor),
            nextButton.widthAnchor.constraint(equalTo: playButton.widthAnchor),
            nextButton.centerXAnchor.constraint(equalTo: stopButton.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: stopButton.centerYAnchor, constant: 80),
        ])
        setupPlayer()
    }
    
    @objc func playButtonTapped() {
        if player.isPlaying {
            player.stop()
            playButton.setImage(.init(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            playButton.setImage(.init(systemName: "pause.fill"), for: .normal)
            soundNameLabel.text = trackNames[currentTrack]
        }
    }

    @objc func stopButtonTapped() {
        player.stop()
        player.currentTime = 0
        playButton.setImage(.init(systemName: "play.fill"), for: .normal)
    }
    
    @objc func previousButtonTapped() {
        currentTrack -= 1
        if currentTrack < 0 {
            currentTrack = trackNames.count - 1
        }
        setupPlayer()
        player.play()
    }
    
    @objc func nextButtonTapped() {
        currentTrack += 1
        if currentTrack > trackNames.count - 1 {
            currentTrack = 0
        }
        setupPlayer()
        player.play()
    }
    
    private func setupPlayer() {
        do {
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: trackNames[currentTrack], ofType: "mp3")!))
            player.delegate = self
            player.prepareToPlay()
            soundNameLabel.text = trackNames[currentTrack]
        }
        catch {
            print(error)
        }
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        currentTrack += 1 % trackNames.count
    }
}

