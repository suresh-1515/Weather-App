//
//  StartViewController.swift
//  MyWeatherApp
//
//  Created by Suresh on 28/03/23.
//

import UIKit
import AVKit

class StartViewController: UIViewController{

    //MARK: - IBOutlets
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var privacyLabel: UILabel!
    
    //MARK: - vars/lets
    var viewModel = StartViewModel()
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.actualLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playVideoBackground()
        updateUI()
    }
    
    //MARK: - IBActions
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: Constants.weatherViewController) as? WeatherViewController else { return }
        
        viewModel.getWeather {
            controller.modalPresentationStyle = .fullScreen
            controller.viewModel.weather = self.viewModel.weather
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    //MARK: - flow func
    private func updateUI() {
        self.continueButton.addButtonRadius()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.greetingsLabel.text = "Welcome!".localize
        self.descriptionLabel.text = "The “YouWeather” app provides accurate forecast and weather alerts wherever you are. We must be allowed to use your Location Services.".localize
        self.continueButton.setTitle("Next".localize, for: .normal)
        self.privacyLabel.text = "We use and share the precise location of your device based оn our Privacy Policy".localize
    }
    
    //Background video
    @objc func playerItemDidReachEnd(notification: Notification) {
        let playerItem: AVPlayerItem = notification.object as! AVPlayerItem
        playerItem.seek(to: .zero, completionHandler: nil)
    }
    
    private func playVideoBackground() {
        guard let url = Bundle.main.url(forResource: "background", withExtension: "mp4") else { return }
        let player = AVPlayer(url: url)
        let videoLayer = AVPlayerLayer(player: player)
        
        videoLayer.videoGravity = .resizeAspectFill
        player.volume = 0
        player.actionAtItemEnd = .none
        videoLayer.frame = self.view.layer.bounds
        self.view.backgroundColor = .clear
        self.view.layer.insertSublayer(videoLayer, at: 0)
        NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerItemDidReachEnd(notification:)),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player.currentItem)
        player.play()
    }
    
}


