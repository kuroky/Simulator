import Foundation

typealias JSONDictionary = [String: AnyObject]
typealias JSONArray = [JSONDictionary]

extension Dictionary {
    
    /// 获取字符串对象
    ///
    /// - Parameter name: key
    /// - Returns: 对应字符串value
    func string(_ name: String) -> String {
        if let name = name as? Key {
            return self[name] as? String ?? ""
        }
        
        return ""
    }
    
    /// 获取bool值
    ///
    /// - Parameter key: key
    /// - Returns: 对应bool值
    func boolValue(_ key: String) -> Bool {
        if let key = key as? Key {
            return self[key] as? Bool ?? false
        }
        return false
    }
}


extension NSDictionary {

  func string(_ name: String) -> String {
    return self[name] as? String ?? ""
  }
}
