import UIKit
import GoogleMobileAds
import LBTATools

class NativeListItemView: NativeAdView {
    
    let adTag: UILabel = UILabel(text: "AD", font: .systemFont(ofSize: 11, weight: .semibold), textColor: .white, textAlignment: .center)
    let headlineLabel = UILabel(text: "", font: .systemFont(ofSize: 15, weight: .medium), textColor: .label)
    let iconImageView = UIImageView()
    let bodyLabel = UILabel(text: "", font: .systemFont(ofSize: 14, weight: .regular), textColor: .secondaryLabel)
    let starRatingImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        self.headlineView = headlineLabel
        self.iconView = iconImageView
        self.bodyView = bodyLabel
        
        adTag.withWidth(20)
        adTag.backgroundColor = .blue
        adTag.layer.cornerRadius = 2
        adTag.clipsToBounds = true
        
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor, multiplier: 1).isActive = true
        iconImageView.clipsToBounds = true
        
        headlineLabel.numberOfLines = 1
        headlineLabel.lineBreakMode = .byTruncatingTail
        
        bodyLabel.numberOfLines = 2
        bodyLabel.lineBreakMode = .byWordWrapping
        
        let headerStack = hstack(adTag, headlineLabel, spacing: 4)
        let leftStack = stack(headerStack, bodyLabel, spacing: 8)
        
        hstack(iconImageView, leftStack, spacing: 8, alignment: .center)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
