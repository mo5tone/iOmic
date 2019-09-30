//
//  SourceTableViewCell.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class SourceTableViewCell: UITableViewCell {
    // MARK: - Instance properties

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var versionLabel: UILabel!
    @IBOutlet private var flagImageView: UIImageView!
    @IBOutlet private var switcher: UISwitch!
    private var source: Source = .dongmanzhijia

    // MARK: - Public instance methods

    func setup(with source: Source) {
        self.source = source
        nameLabel.text = source.name
        versionLabel.text = "Version: \(source.version)"
        switcher.isOn = source.available
    }

    // MARK: - Overrides

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none

        nameLabel.font = .preferredFont(forTextStyle: .subheadline)
        versionLabel.font = .preferredFont(forTextStyle: .caption2)
        flagImageView.tintColor = UIColor.flat.onTint
        switcher.addTarget(self, action: #selector(valueChanged(on:)), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        flagImageView.isHidden = !selected
    }

    // MARK: - Private instance methods

    @objc private func valueChanged(on sender: UISwitch) {
        KeyValues.shared.set(souce: source, available: sender.isOn)
    }
}
