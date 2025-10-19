import SwiftUI
import GoogleMobileAds

//class NativeAdLoader: NSObject, NativeAdLoaderDelegate {
//    private var adLoader: AdLoader?
//    var didReceive: ((NativeAd) -> Void)?
//    var didFailToReceiveAdWithError: ((Error) -> Void)?
//    var adLoaderDidFinishLoading: (() -> Void)?
//    
//    init(adUnitID: String) {
//        super.init()
//        adLoader = AdLoader(adUnitID: adUnitID,
//                            rootViewController: nil,
//                            adTypes: [.native],
//                            options: nil)
//        adLoader?.delegate = self
//    }
//    
//    func loadAd() {
//        let request = Request()
//        adLoader?.load(request)
//    }
//    
//    //MARK: - NativeAdLoaderDelegate
//    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
//        didReceive?(nativeAd)
//    }
//    
//    // 권장 사항: AdLoader의 load()함수를 호출했다면, 아래의 콜백 응답을 받기 전에는 재요청 하지 마라
//    func adLoaderDidFinishLoading(_ adLoader: AdLoader) {
//        adLoaderDidFinishLoading?()
//    }
//    
//    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: any Error) {
//        didFailToReceiveAdWithError?(error)
//    }
//}
//
//struct NativeAdCard: UIViewRepresentable {
//    let adUnitID: String = "ca-app-pub-3940256099942544/3986624511" // 네이티브 테스트 단위
//    
//    func makeCoordinator() -> Coordinator { Coordinator() }
//    
//    func makeUIView(context: Context) -> NativeAdView {
//        // 1) 네이티브 광고 컨테이너 뷰 생성
//        let adView = NativeAdView()
//        adView.translatesAutoresizingMaskIntoConstraints = false
//        adView.backgroundColor = .secondarySystemBackground
//        adView.layer.cornerRadius = 12
//        adView.clipsToBounds = true
//        
//        // 2) 서브뷰(코드 생성)
//        let headlineLabel = UILabel()
//        headlineLabel.font = .preferredFont(forTextStyle: .headline)
//        headlineLabel.numberOfLines = 0
//        
//        let bodyLabel = UILabel()
//        bodyLabel.font = .preferredFont(forTextStyle: .subheadline)
//        bodyLabel.textColor = .secondaryLabel
//        bodyLabel.numberOfLines = 0
//        
//        let iconView = UIImageView()
//        iconView.contentMode = .scaleAspectFit
//        iconView.layer.cornerRadius = 8
//        iconView.clipsToBounds = true
//        iconView.setContentHuggingPriority(.required, for: .horizontal)
//        iconView.setContentHuggingPriority(.required, for: .vertical)
//        NSLayoutConstraint.activate([
//            iconView.widthAnchor.constraint(equalToConstant: 40),
//            iconView.heightAnchor.constraint(equalToConstant: 40)
//        ])
//        
//        let mediaView = MediaView()
//        mediaView.translatesAutoresizingMaskIntoConstraints = false
//        mediaView.clipsToBounds = true
//        
//        let ctaButton = UIButton(type: .system)
//        ctaButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
//        ctaButton.setTitleColor(.white, for: .normal)
//        ctaButton.backgroundColor = .systemBlue
//        ctaButton.layer.cornerRadius = 8
//        ctaButton.isUserInteractionEnabled = false // SDK가 클릭 추적
//        
//        let adBadge = UILabel()
//        adBadge.text = "광고"
//        adBadge.font = .systemFont(ofSize: 11, weight: .semibold)
//        adBadge.textColor = .white
//        adBadge.backgroundColor = .systemGray
//        adBadge.layer.cornerRadius = 4
//        adBadge.clipsToBounds = true
//        adBadge.textAlignment = .center
//        adBadge.setContentHuggingPriority(.required, for: .horizontal)
//        adBadge.setContentCompressionResistancePriority(.required, for: .horizontal)
//        adBadge.translatesAutoresizingMaskIntoConstraints = false
//        
//        // 3) 계층 & 레이아웃
//        let topRow = UIStackView(arrangedSubviews: [iconView, headlineLabel, adBadge])
//        topRow.axis = .horizontal
//        topRow.alignment = .center
//        topRow.spacing = 8
//        
//        let vstack = UIStackView(arrangedSubviews: [topRow, bodyLabel, mediaView, ctaButton])
//        vstack.axis = .vertical
//        vstack.spacing = 8
//        vstack.translatesAutoresizingMaskIntoConstraints = false
//        
//        adView.addSubview(vstack)
//        
//        NSLayoutConstraint.activate([
//            vstack.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 12),
//            vstack.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -12),
//            vstack.topAnchor.constraint(equalTo: adView.topAnchor, constant: 12),
//            vstack.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: -12),
//            mediaView.heightAnchor.constraint(greaterThanOrEqualToConstant: 160),
//            adBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 28),
//            adBadge.heightAnchor.constraint(equalToConstant: 18)
//        ])
//        
//        // 4) 매핑 (필수/옵션 자산)
//        adView.headlineView = headlineLabel        // 필수
//        adView.bodyView = bodyLabel                // 옵션
//        adView.iconView = iconView                 // 옵션
//        adView.mediaView = mediaView               // 권장
//        adView.callToActionView = ctaButton        // 권장
////        adView.adBadgeView = adBadge               // “광고” 표기
//        
//        // 5) 로드 시작
//        context.coordinator.install(into: adView, adUnitID: adUnitID)
//        return adView
//    }
//    
//    func updateUIView(_ uiView: NativeAdView, context: Context) {
//        // 필요 시 갱신 로직(현재 없음)
//    }
//    
//    class Coordinator: NSObject, NativeAdLoaderDelegate, VideoControllerDelegate, NativeAdDelegate {
//        private var loader: AdLoader?
//        private weak var adView: NativeAdView?
//        
//        func install(into adView: NativeAdView, adUnitID: String) {
//            self.adView = adView
//            
//            loader = AdLoader(
//                adUnitID: adUnitID,
//                rootViewController: nil,
//                adTypes: [.native],
//                options: nil
//            )
//            loader?.delegate = self
//            loader?.load(Request())
//        }
//        
//        // MARK: NativeAdLoaderDelegate
//        func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
//            guard let adView = adView else { return }
//            
//            // delegate 연결 (클릭/노출 이벤트 콜백을 위해)
//            nativeAd.delegate = self
//            
//            // 필수 자산
//            (adView.headlineView as? UILabel)?.text = nativeAd.headline
//            adView.mediaView?.mediaContent = nativeAd.mediaContent
//            
//            // 비디오 유무에 따라 처리
//            let mediaContent = nativeAd.mediaContent
//            if mediaContent.hasVideoContent {
//                mediaContent.videoController.delegate = self
//            }
//            
//            // 미디어 비율에 맞춰 높이 조정(권장)
//            if let mediaView = adView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
//                mediaView.removeConstraints(mediaView.constraints)
//                // 폭:높이 = aspectRatio (GMA 샘플과 동일 논리)
//                let aspect = nativeAd.mediaContent.aspectRatio
//                mediaView.translatesAutoresizingMaskIntoConstraints = false
//                NSLayoutConstraint.activate([
//                    mediaView.heightAnchor.constraint(equalTo: mediaView.widthAnchor, multiplier: 1.0 / CGFloat(max(0.1, aspect)))
//                ])
//            }
//            
//            // 선택 자산 (nil이면 숨김)
//            if let body = nativeAd.body, let bodyLabel = adView.bodyView as? UILabel {
//                bodyLabel.text = body
//                bodyLabel.isHidden = false
//            } else {
//                adView.bodyView?.isHidden = true
//            }
//            
//            if let icon = nativeAd.icon?.image, let iconImageView = adView.iconView as? UIImageView {
//                iconImageView.image = icon
//                iconImageView.isHidden = false
//            } else {
//                adView.iconView?.isHidden = true
//            }
//            
//            if let cta = nativeAd.callToAction, let btn = adView.callToActionView as? UIButton {
//                btn.setTitle(cta, for: .normal)
//                btn.isHidden = false
//                btn.isUserInteractionEnabled = false // SDK가 터치 처리
//            } else {
//                adView.callToActionView?.isHidden = true
//            }
//            
//            // 광고 객체 연결 (필수: 클릭/노출 처리)
//            adView.nativeAd = nativeAd
//        }
//        
//        func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
//            print("❌ Native load failed:", error.localizedDescription)
//        }
//        
//        func adLoaderDidFinishLoading(_ adLoader: AdLoader) {
//            // 필요 시 추가 로직
//        }
//        
//        // MARK: VideoControllerDelegate
//        func videoControllerDidEndVideoPlayback(_ videoController: VideoController) {
//            // 필요 시 영상 종료 처리
//        }
//        
//        // MARK: NativeAdDelegate
//        func nativeAdDidRecordImpression(_ nativeAd: NativeAd) { }
//        func nativeAdDidRecordClick(_ nativeAd: NativeAd) { }
//        func nativeAdWillPresentScreen(_ nativeAd: NativeAd) { }
//        func nativeAdWillDismissScreen(_ nativeAd: NativeAd) { }
//        func nativeAdDidDismissScreen(_ nativeAd: NativeAd) { }
//        func nativeAdWillLeaveApplication(_ nativeAd: NativeAd) { }
//    }
//}
