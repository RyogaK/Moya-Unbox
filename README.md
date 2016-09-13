Moya-Unbox
============
[![Carthage
compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

[Unbox](https://github.com/JohnSundell/Unbox) bindings for [Moya](https://github.com/Moya/Moya) for fabulous JSON serialization.
Supports [RxSwift](https://github.com/ReactiveX/RxSwift/) and [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa/) bindings as well.

# Installation

## Carthage

```ruby
github "RyogaK/Moya-Unbox"
```

# Usage

Create a `Class` or `Struct` which implements the `Unboxable` protocol.

```swift
import Foundation
import Unbox

struct Repository: Unboxable {

  let identifier: Int!
  let language: String?
  let url: String!
  
  init(unboxer: Unboxer) {
    identifier = unboxer.unbox("id")
    language = unboxer.unbox("language")
    url = unboxer.unbox("url")
  }
}
```

## 1. Without RxSwift


```swift
GitHubProvider.request(.UserRepositories(username), completion: { result in

    var success = true
    var message = "Unable to fetch from GitHub"

    switch result {
    case let .Success(response):
        do {
            if let repos = try response.mapArray(Repository.self) {
              self.repos = repos
            } else {
              success = false
            }
        } catch {
            success = false
        }
        self.tableView.reloadData()
    case let .Failure(error):
        guard let error = error as? CustomStringConvertible else {
            break
        }
        message = error.description
        success = false
    }
})

```

## 2. With RxSwift

```swift
GitHubProvider.request(.UserRepositories(username))
  .mapArray(Repository.self)
  .subscribe { event -> Void in
    switch event {
    case .Next(let repos):
      self.repos = repos
    case .Error(let error):
      print(error)
    default:
      break
    }
  }.addDisposableTo(disposeBag)
```

# Contributing

Feel free to make issues and pull requests!

# License

MIT
