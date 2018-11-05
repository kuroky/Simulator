import Foundation

extension URL {

  var removeTrailingSlash: URL {
    guard absoluteString.hasSuffix("/") else { return self }
    
    let index = absoluteString.index(before: absoluteString.endIndex)
    let string = String(absoluteString[..<index])
    return URL(string: string)!
  }
}
