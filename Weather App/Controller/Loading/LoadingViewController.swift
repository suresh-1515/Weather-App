//
//  LoadingViewController.swift
//  MyWeatherApp
//
//  Created by Suresh on 28/03/23.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController{
    
    //MARK: - IBOutlets
    
    //MARK: - vars/lets
    private var animationView: LottieAnimationView?
    private var viewModel = LoadingViewModel()
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        animationView = .init(name: "sunLoad")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 2
        view.addSubview(animationView!)
    }

    //MARK: - flow func
    private func bind() {
        viewModel.showLoading = {
            DispatchQueue.main.async {
                self.animationView!.play()
            }
        }
        viewModel.hideLoading = {
            DispatchQueue.main.async {
                self.animationView!.stop()
            }
        }
        viewModel.showError = {
            let alert = UIAlertController(title: "Error Occured", message: "An error occured, please try after sometime", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                self.viewModel.loadWeatherController?()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        viewModel.loadStartController = {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: Constants.startViewController) as? StartViewController else { return }
            self.navigationController?.pushViewController(controller, animated: false)
        }
        viewModel.loadWeatherController = {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: Constants.weatherViewController) as? WeatherViewController else { return }
            controller.viewModel.weather = self.viewModel.weather

            self.navigationController?.pushViewController(controller, animated: true)
        }
        viewModel.checkFirstStart()
    }
}


