# MyLOSTARK Readme
![Static Badge](https://img.shields.io/badge/Swift-5.8.1-orange) ![Static Badge](https://img.shields.io/badge/platform-iOS-orange) ![Static Badge](https://img.shields.io/badge/target-16.4-orange)
## 개요
**LOSTARK API를 활용해 `로아와`, `클로아`와 같은 사이트에서 제공하는 서비스를 앱으로 제작했습니다.**

**앱 디자인은 사이트와 OP.GG를 참고했습니다.**
## 타임라인
**2023.07.17 ~ 2023.10.08**

**2023.07**
- Main View 구현
- Network Service 구현 및 테스트 코드 작성

**2023.08**
- Content Reward View 구현
- Notice View 구현
- Search View 구현

**2023.09**
- MVVM + Clean Architecture 적용
- CoreData 구현

**2023.10**
- Profile View 구현

## 실행 화면
### Main View


| Main | Content Reward | Notice |
| -------- | -------- | -------- |
|![MainView](https://github.com/Hugh-github/iOS-MyLOSTARK/assets/102569735/2a66ddfc-1dd2-4a47-95d8-c46cadfcc5b8)|![CalendarView](https://github.com/Hugh-github/iOS-MyLOSTARK/assets/102569735/2f189aff-8114-4c73-9754-2f9fdf4d5dfb)|![NoticeView](https://github.com/Hugh-github/iOS-MyLOSTARK/assets/102569735/b324a924-46ef-4570-a00c-c7baf8dbe141)|


### Profile


| 검색 | 최근 검색어 | 즐겨찾는 캐릭터 |
| -------- | -------- | -------- |
|![SearchView](https://github.com/Hugh-github/iOS-MyLOSTARK/assets/102569735/0e99beab-79c6-4f14-836b-ae56f5fa43dd)|![ProfileView](https://github.com/Hugh-github/iOS-MyLOSTARK/assets/102569735/965304bd-0aeb-410a-9044-8142e3f5e4e8)|![BookmarkCell](https://github.com/Hugh-github/iOS-MyLOSTARK/assets/102569735/54eb7524-8f1c-4665-a925-9c2dbbbb13ee)|



### Bookmark Action



| Case 1 |Case 2 |Case 3 |
| -------- | -------- | -------- |
|![BookmarkInterAction1](https://github.com/Hugh-github/iOS-MyLOSTARK/assets/102569735/5cc5c245-c31d-412e-ba72-bcc90c8e890a)|![BookmarkInterAction2](https://github.com/Hugh-github/iOS-MyLOSTARK/assets/102569735/72647c8f-b2b8-4d30-b12b-3626ca4c5e82)|![BookmarkInterAction3](https://github.com/Hugh-github/iOS-MyLOSTARK/assets/102569735/f424cc4b-641e-40ae-a911-a3a11f753c2c)
|


## MVVM + Clean Architecture
Clean Architecture를 적용한 이유는 Bookmark 정보를 동기화 시키기 위해 변경사항을 Repository에서 계속 업데이트하고 있습니다.

반복되는 비즈니스 로직을 UseCase를 통해 정리하고 필요한 로직들을 추상화해 관리하고 있습니다.

#### UML
![image](https://github.com/Hugh-github/iOS-MyLOSTARK/assets/102569735/2d1ac5c9-10e6-43e2-90d8-994b4fe5f50c)

#### Layer 설계 시 중요하게 생각한 Point
> **Data Layer** : Data Source + API + Repository Implementations
+ Data Source를 사용하기 위한 CRUD 메서드 구현
+ 여러 곳에서 동일한 데이터를 가지고 사용해야 하는 경우 Repository 내부에 데이터의 변경 사항을 업데이트 (ex. Bookmark)

> **Domain Layer** : Repository Interface + Use Case
+ Use Case에서 Repository를 직접 참조하지 않고 상의 모듈을 통한 의존성 역전을 위해 Repository Interface 구현
+ Use Case는 각각의 View에서 공통으로 사용되는 로직을 먼저 분리하고 나머지 로직에 대해서는 각각의 Entity에 대한 Use Case 객체 구현

> **Presentation Layer** : ViewModel + Mapper + View
+ Domain Layer에서 Entity를 변화시키지 않고 ViewModel에서 Entity를 편하게 사용하기 위해 Mapper 타입 구현


## Builder 패턴 구현
SwiftUI의 ViewBuilder에서 아이디어를 얻어 패턴 적용

Builder Deirector를 별도로 구현해 각 View에서 사용되는 Layout을 관리

+ 패턴 적용 전
```swift
let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0))
let item = NSCollectionLayoutItem(layoutSize: itemSize)

let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.26))
let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: item)

let section =  NSCollectionLayoutSection(group: group)
```


+ 패턴 적용 후
```swift
let section = builder
    .setItem(width: .fractionalWidth(0.33), height: .fractionalHeight(1.0))
    .setGroup(width: .fractionalWidth(1.0), height: .fractionalHeight(0.26), direction: .horizontal)
    .getSectionLayout()
```
