//
//  LoginVC.swift
//  ExtraaNumber
//
//  Created by sadman samee on 26/1/19.
//  Copyright © 2019 sadman samee. All rights reserved.
//

import SwiftValidator
import UIKit
import RxSwift
import RxCocoa

class LoginVC: BaseTableViewController {
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var txtFieldPassword: UITextField!
    @IBOutlet var txtFieldEmail: UITextField!
    
    weak var authCoordinatorDelegate: AuthCoordinatorDelegate?

    private let validator = Validator()
    private  lazy var viewModel: LogInVM = {
        LogInVM()
    }()
    
  private  var disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpValidator()
        setUI()
        bindViewModel()
    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        coordinator?.didFinishBuying()
//    }
    @IBAction func actionLogin(_: Any) {
        validator.validate(self)
    }

    @IBAction func actionSignUP(_: Any) {
        authCoordinatorDelegate?.signUp()
    }

   private func login() {
        viewModel.login()
    }

    private func setUI() {

    }
    
    private func setLoadingHud(visible: Bool) {
        if visible {
            AppHUD.showHUD()
        } else {
            AppHUD.hideHUD()
        }
    }


  private  func bindViewModel() {
        
        (txtFieldPassword.rx.text <-> viewModel.password).disposed(by: disposeBag)
        (txtFieldEmail.rx.text <-> viewModel.email).disposed(by: disposeBag)
        
        viewModel.isValid.map{ $0 }
            .bind(to: btnLogin.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
//        viewModel.onShowAlert.subscribe { (alertMessage) in
//                AppHUD.showErrorMessage(alertMessage.element?.message ?? "", title: alertMessage.element?.title ?? "")
//            }
//            .disposed(by: disposeBag)

//        viewModel.onShowingLoading.subscribe{ (isLoading) in
//            DispatchQueue.main.async {
//                guard let isLoading = isLoading.element else {
//                    return
//                }
//                if isLoading {
//                    AppHUD.showHUD()
//                } else {
//                    AppHUD.hideHUD()
//                }
//            }
//            }.disposed(by: disposeBag)
////
//
    viewModel
        .onShowAlert
        .map { [weak self] in AppHUD.showErrorMessage($0.message ?? "", title: $0.title ?? "")}
        .subscribe()
        .disposed(by: disposeBag)

    viewModel
        .onShowingLoading
        .map { [weak self] in self?.setLoadingHud(visible: $0) }
        .subscribe()
        .disposed(by: disposeBag)

    
    viewModel
        .onSuccess
        .map { _ in  self.authCoordinatorDelegate?.stop()}
        .subscribe()
        .disposed(by: disposeBag)
    
//        viewModel.onSuccess.subscribe{ (success) in
//            guard let success = success.element else {
//                return
//            }
//            self.goToRoot()
//        }.disposed(by: disposeBag)

    }
}

// MARK: ValidationDelegate Methods

extension LoginVC: ValidationDelegate {
    // Private method
   private func setUpValidator() {
        validator.registerField(txtFieldEmail, rules: [RequiredRule(), EmailRule(), MinLengthRule(length: 5)])
        validator.registerField(txtFieldPassword, rules: [RequiredRule(), MinLengthRule(length: 5)])
    }

    // ValidationDelegate methods
    func validationSuccessful() {
        login()
    }

    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
}
