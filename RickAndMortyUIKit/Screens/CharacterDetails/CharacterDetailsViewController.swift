//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import UIKit

final class CharacterDetailsViewController: UIViewController {
    private let viewModel: CharacterDetailsViewModelProtocol

    private lazy var imageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private var imageFetchTask: Task<(), Never>?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: CharacterDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        setupUI()
    }

    private func loadData() {
        Task {
            do {
                try await viewModel.loadData()
                DispatchQueue.main.async {  [weak self] in
                    self?.configure()
                }
            } catch {
                // ...
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        imageFetchTask?.cancel()
        super.viewDidDisappear(animated)
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(imageView)
        view.addSubview(titleLabel)

        [imageView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32),

            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    private func configure() {
        titleLabel.text = viewModel.name


        imageFetchTask = Task {
            do {
                let imageData = try await viewModel.getImage()

                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.imageView.image = UIImage(data: imageData)
                }
            } catch {
                // ...
            }
        }
    }
}
