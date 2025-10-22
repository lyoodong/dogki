<img src="https://github.com/user-attachments/assets/e6361ecb-a3a6-4437-a4cb-49fdd36c061b" width="30%" align="center" />
<img src="https://github.com/user-attachments/assets/6fa80ab7-e4b4-44dc-9d13-2050b07ac813" width="30%" align="center" />
<img src="https://github.com/user-attachments/assets/37bb7044-e86a-4ec8-94e3-f26a5a411c78b" width="30%" align="center" />

# 독기: 수능 국어 독서(비문학) 기출문제


> 핵심 기능
- 연도, 영역 별 비문학 기출문제 필터
- PDFKit 프레임워크에 기반해 PDF **미리보기 뷰어** 제작
- GoogleAdMob Native 광고를 SwiftUI 프로젝트에 통합

---

> 기술 스택
- **언어**: Swift
- **프레임워크**: SwiftUI
- **Package Dependencies**: Firebase, GoogleMobileAds, LBTATools
---

> 서비스
- **최소 버전**: iOS 18.0
- **개발 인원**: 1인
- **개발 기간** : 2025.10.10.10 ~ 2025.10.17, 현재 지속적으로 서비스 운영 중
- **iOS 앱스토어:** [독기바로가기](https://apps.apple.com/kr/app/%EB%8F%85%EA%B8%B0-%EC%88%98%EB%8A%A5-%EA%B5%AD%EC%96%B4-%EB%8F%85%EC%84%9C-%EB%B9%84%EB%AC%B8%ED%95%99-%EA%B8%B0%EC%B6%9C%EB%AC%B8%EC%A0%9C/id6753966506)
---

### 트러블 슈팅

**SwiftUI 프로젝트에 AdMob Native 광고 통합**

**Issue**

- 최적의 사용자 경험을 위해, AdMob 기본 배너 광고는 지양
- 기존 UI와 조화를 이룰 수 있는 Native Ads 선택
- 최적의 eCPM을 위한 노출 전략이 필요

**Solution**

- 같은 `NativeAd` 데이터에 대해 다양한 형태의 UI를 탬플릿처럼 추가, 삭제할 수 있도록 `Factory 패턴`을 이용
- 최적의 eCPM을 위해 다음과 같은 전략을 사용함 
  1. 새로운 광고 로드 시 4개의 광고 호출해 캐싱 -> 광고 노출 가능성 증가
  2. 캐싱된 4개의 광고를 라운드 로빈 방식으로 최상단에 노출 -> 호출된 광고를 균형있게 노출
  3. 갱신 주기를 설정해 너무 자주 새로운 광고를 호출하지 않도록 처리 -> 과도한 재호출은 eCPM에 악영향 


**Result**

```swift
// NativeAdService

public func refreshAd() {
    let now = Date()

    // 3. 갱신 주기를 설정해 너무 자주 새로운 광고를 호출하지 않도록 처리
    if !cachedAds.isEmpty, let lastRequest = lastRequestTime, now.timeIntervalSince(lastRequest) < Double(requestInterval) {
        return
    }

    guard !isLoading else {
        return
    }

    isLoading = true
    lastRequestTime = now

    let adViewOptions = NativeAdViewAdOptions()
    adViewOptions.preferredAdChoicesPosition = .topRightCorner

    // 1. 4개의 광고 호출해 캐싱
    let multipleAdsAdLoaderOptions = MultipleAdsAdLoaderOptions()
    multipleAdsAdLoaderOptions.numberOfAds = numberOfAds
    
    adLoader = AdLoader(adUnitID: adUnitID, rootViewController: nil, adTypes: [.native], options: [adViewOptions, multipleAdsAdLoaderOptions])
    adLoader.delegate = self
    adLoader.load(Request())
}

```

```swift
// NativeAdService

public func refreshAdIndex() {
    // 캐싱된 4개의 광고를 라운드 로빈 방식으로 최상단에 노출
    guard cachedAds.count > 1 else { return }
    let first = cachedAds.removeFirst()
    cachedAds.append(first)
}
```
---

> 📒 커밋 메시지 형식

| 유형      | 설명                                                    | 예시                                |
|-----------|---------------------------------------------------------|-------------------------------------|
| FIX       | 버그 또는 오류 해결                                     | [FIX] #10 - 콜백 오류 수정            |
| ADD       | 새로운 코드, 라이브러리, 뷰, 또는 액티비티 추가        | [ADD] #11 - LoginActivity 추가         |
| FEAT      | 새로운 기능 구현                                        | [FEAT] #11 - Google 로그인 추가         |
| DEL       | 불필요한 코드 삭제                                      | [DEL] #12 - 불필요한 패키지 삭제        |
| REMOVE    | 파일 삭제                                               | [REMOVE] #12 - 중복 파일 삭제         |
| REFACTOR  | 내부 로직은 변경하지 않고 코드 개선 (세미콜론, 줄바꿈 포함) | [REFACTOR] #15 - MVP 아키텍처를 MVVM으로 변경 |
| CHORE     | 그 외의 작업 (버전 코드 수정, 패키지 구조 변경, 파일 이동 등) | [CHORE] #20 - 불필요한 패키지 삭제      |
| DESIGN    | 화면 디자인 수정                                         | [DESIGN] #30 - iPhone 12 레이아웃 조정  |
| COMMENT   | 필요한 주석 추가 또는 변경                               | [COMMENT] #30 - 메인 뷰컨 주석 추가     |
| DOCS      | README 또는 위키 등 문서 내용 추가 또는 변경            | [DOCS] #30 - README 내용 추가          |
| TEST      | 테스트 코드 추가                                        | [TEST] #30 - 로그인 토큰 테스트 코드 추가  |
