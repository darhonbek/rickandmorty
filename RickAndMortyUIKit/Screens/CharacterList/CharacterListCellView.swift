//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation
import UIKit

final class CharacterListCellView: UITableViewCell {
    var viewModel: CharacterListCellViewModelProtocol? {
        didSet {
            configure()
        }
    }

    private lazy var avatarImageView: UIImageView = {
        UIImageView()
    }()

    private lazy var titleLabel: UILabel = {
        UILabel()
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.cancelImageDownload()
    }

    private func setupSubviews() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(titleLabel)

        [avatarImageView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        avatarImageView.backgroundColor = .red

        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),

            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func configure() {
        guard let viewModel else { return }

        viewModel.getImage { [weak self] image in
            DispatchQueue.main.async {
                guard let self else { return }
                self.avatarImageView.image = image
            }
        }

        titleLabel.text = viewModel.name
    }
}
