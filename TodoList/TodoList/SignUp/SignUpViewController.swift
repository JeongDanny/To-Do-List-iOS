//
//  SignUpViewController.swift
//  TodoList
//
//  Created by paytalab on 2021/08/03.
//

import UIKit
import RxSwift

class SignUpViewController: UIViewController {
    static func newInstance(viewModel: SignUpViewModel) -> SignUpViewController {
        let vc = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        vc.viewModel = viewModel
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    private let dimmedView = UIView()
    private let hiLabel = UILabel(text: "👋", font: .systemFont(ofSize: 56))
    
    private let disposeBag = DisposeBag()
    private var viewModel: SignUpViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHiAnimation()
        startButton.setBackgroundColor(.black, for: .normal)
        startButton.setBackgroundColor(.gray, for: .disabled)
        startButton.setTitleColor(.white, for: .normal)
        startButton.setTitleColor(.lightGray, for: .disabled)
        startButton.layer.cornerRadius = startButton.frame.height / 2
        startButton.clipsToBounds = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: { [weak self] in
            self?.showHiAnimation()
        })
        
        disposeBag.insert(
            nameTextField.rx.text
                .observe(on: MainScheduler.instance)
                .bind(to: viewModel.input.nameText),
            viewModel.output.startButtonEnabled
                .observe(on: MainScheduler.instance)
                .bind(to: startButton.rx.isEnabled),
            startButton.rx.tap
                .observe(on: MainScheduler.instance)
                .bind(onNext: { [weak self] in
                    self?.indicatorView.startAnimating()
                    self?.viewModel.start(userName: self?.nameTextField.text ?? "") {
                        self?.indicatorView.stopAnimating()
                        self?.dismiss(animated: true)
                    }
                })
        )
    }
    
    private func setupHiAnimation() {
        dimmedView.backgroundColor = .white
        view.addSubview(dimmedView)
        dimmedView.addSubview(hiLabel)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        hiLabel.translatesAutoresizingMaskIntoConstraints = false
        [dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
         dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         hiLabel.centerYAnchor.constraint(equalTo: dimmedView.centerYAnchor),
         hiLabel.centerXAnchor.constraint(equalTo: dimmedView.centerXAnchor)]
            .forEach({ $0.isActive = true })
    }
    
    private func showHiAnimation() {
        // wiggle
        let wiggleAnimation = CAKeyframeAnimation(keyPath: "transform")
        wiggleAnimation.values = [NSValue(caTransform3D: CATransform3DMakeRotation(0.1, 0, 0, 1)),
                                   NSValue(caTransform3D: CATransform3DMakeRotation(-0.1, 0, 0, 1))]
        wiggleAnimation.autoreverses = true
        wiggleAnimation.duration = 0.2
        wiggleAnimation.repeatCount = 10
        hiLabel.layer.add(wiggleAnimation, forKey: "transform")
        
        // disappear
        UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseInOut, animations: { [weak self] in
            self?.dimmedView.alpha = 0
            self?.dimmedView.layoutIfNeeded()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
