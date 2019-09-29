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
    @IBOutlet private var switcher: UISwitch!

    // MARK: - Public instance methods

    func setup(with source: Source) {
        nameLabel.text = source.name
        versionLabel.text = "Version: xxx"
        switcher.isOn = source.available
        _ = switcher.rx.isOn.takeUntil(rx.deallocated).subscribe(onNext: { KeyValues.shared.set(souce: source, available: $0) })
    }

    // MARK: - Overrides

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none

        nameLabel.font = .preferredFont(forTextStyle: .subheadline)
        versionLabel.font = .preferredFont(forTextStyle: .caption2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
