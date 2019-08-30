import Cocoa

class Device {

  let name: String
  let udid: String
  let osInfo: String
  let isOpen: Bool
  let isAvailable: Bool

  var applications: [Application] = []
  var appGroups: [AppGroup] = []
  var media: [Media] = []

  // MARK: - Init

  init(osInfo: String, json: JSONDictionary) {
    self.name = json.string("name")
    self.udid = json.string("udid")
    self.isAvailable = json.boolValue("isAvailable")
    self.isOpen = json.string("state").contains("Booted")
    self.osInfo = osInfo
    self.applications = Application.load(location)
    self.appGroups = AppGroup.load(location)
    self.media = Media.load(location)
  }

  var location: URL {
    return Path.devices.appendingPathComponent("\(udid)")
  }

  var os: OS {
    return OS(rawValue: osInfo.components(separatedBy: " ").first ?? "") ?? .unknown
  }

  var version: String {
    return osInfo.components(separatedBy: " ").last ?? ""
  }

  var hasContent: Bool {
    return !applications.isEmpty
  }

  // MARK: - Load

  static func load() -> [Device] {
    let string = Task.output(launchPath: "/usr/bin/xcrun", arguments: ["simctl", "list", "-j", "devices"],
                             directoryPath: Path.devices)

    guard let data = string.data(using: String.Encoding.utf8),
      let jsonObject = ((try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary) as JSONDictionary??),
      let json = jsonObject
      else { return [] }

    return parse(json)
  }

  fileprivate static func parse(_ json: JSONDictionary) -> [Device] {
    guard let jsonDic = json["devices"] as? JSONDictionary else {
        return []
    }
    
    var devices: [Device] = []
    jsonDic.forEach({ (key, value) in
        (value as? JSONArray)?.forEach({ deviceJson in
            let device = Device(osInfo: key.remove("com.apple.CoreSimulator.SimRuntime."),
                                json: deviceJson)
            devices.append(device)
        })
    })
    
    let iphones = devices.filter({ device -> Bool in
        if device.hasContent && device.isAvailable && device.name.lowercased().range(of: "iphone") != nil {
            return true
        }
        return false
    })
    
    let sorteds = iphones.sorted(by: { (device1, device2) -> Bool in
        return device1.osInfo.compare(device2.osInfo) == .orderedAscending
    })
    
    return sorteds;
  }
}
