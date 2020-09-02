//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map(Locale.init)
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try font.validate()
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.entitlements` struct is generated, and contains static references to 1 properties.
  struct entitlements {
    static let apsEnvironment = infoPlistString(path: [], key: "aps-environment") ?? "development"

    fileprivate init() {}
  }

  /// This `R.file` struct is generated, and contains static references to 4 files.
  struct file {
    /// Resource file `FangZhengMiaoWu.ttf`.
    static let fangZhengMiaoWuTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "FangZhengMiaoWu", pathExtension: "ttf")
    /// Resource file `ModuleArr.plist`.
    static let moduleArrPlist = Rswift.FileResource(bundle: R.hostingBundle, name: "ModuleArr", pathExtension: "plist")
    /// Resource file `TreeResource.json`.
    static let treeResourceJson = Rswift.FileResource(bundle: R.hostingBundle, name: "TreeResource", pathExtension: "json")
    /// Resource file `addImage.png`.
    static let addImagePng = Rswift.FileResource(bundle: R.hostingBundle, name: "addImage", pathExtension: "png")

    /// `bundle.url(forResource: "FangZhengMiaoWu", withExtension: "ttf")`
    static func fangZhengMiaoWuTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.fangZhengMiaoWuTtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "ModuleArr", withExtension: "plist")`
    static func moduleArrPlist(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.moduleArrPlist
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "TreeResource", withExtension: "json")`
    static func treeResourceJson(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.treeResourceJson
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "addImage", withExtension: "png")`
    static func addImagePng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.addImagePng
      return fileResource.bundle.url(forResource: fileResource)
    }

    fileprivate init() {}
  }

  /// This `R.font` struct is generated, and contains static references to 1 fonts.
  struct font: Rswift.Validatable {
    /// Font `FZMWJW--GB1-0`.
    static let fzmwjwgb10 = Rswift.FontResource(fontName: "FZMWJW--GB1-0")

    /// `UIFont(name: "FZMWJW--GB1-0", size: ...)`
    static func fzmwjwgb10(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: fzmwjwgb10, size: size)
    }

    static func validate() throws {
      if R.font.fzmwjwgb10(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'FZMWJW--GB1-0' could not be loaded, is 'FangZhengMiaoWu.ttf' added to the UIAppFonts array in this targets Info.plist?") }
    }

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 39 images.
  struct image {
    /// Image `add-white`.
    static let addWhite = Rswift.ImageResource(bundle: R.hostingBundle, name: "add-white")
    /// Image `addImage`.
    static let addImage = Rswift.ImageResource(bundle: R.hostingBundle, name: "addImage")
    /// Image `add`.
    static let add = Rswift.ImageResource(bundle: R.hostingBundle, name: "add")
    /// Image `audio_bgm_4`.
    static let audio_bgm_4 = Rswift.ImageResource(bundle: R.hostingBundle, name: "audio_bgm_4")
    /// Image `com_arrow_vc_back`.
    static let com_arrow_vc_back = Rswift.ImageResource(bundle: R.hostingBundle, name: "com_arrow_vc_back")
    /// Image `demoList_tab_selected`.
    static let demoList_tab_selected = Rswift.ImageResource(bundle: R.hostingBundle, name: "demoList_tab_selected")
    /// Image `demoList_tab`.
    static let demoList_tab = Rswift.ImageResource(bundle: R.hostingBundle, name: "demoList_tab")
    /// Image `header_bg_message`.
    static let header_bg_message = Rswift.ImageResource(bundle: R.hostingBundle, name: "header_bg_message")
    /// Image `home_button_bmfw`.
    static let home_button_bmfw = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_button_bmfw")
    /// Image `home_button_jmsc`.
    static let home_button_jmsc = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_button_jmsc")
    /// Image `home_button_mlxc`.
    static let home_button_mlxc = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_button_mlxc")
    /// Image `home_button_myzq`.
    static let home_button_myzq = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_button_myzq")
    /// Image `home_button_nczg`.
    static let home_button_nczg = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_button_nczg")
    /// Image `home_button_nyjs`.
    static let home_button_nyjs = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_button_nyjs")
    /// Image `home_button_nyq`.
    static let home_button_nyq = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_button_nyq")
    /// Image `home_button_schq`.
    static let home_button_schq = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_button_schq")
    /// Image `home_button_shop`.
    static let home_button_shop = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_button_shop")
    /// Image `home_button_xsp`.
    static let home_button_xsp = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_button_xsp")
    /// Image `home_button_xwzc`.
    static let home_button_xwzc = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_button_xwzc")
    /// Image `home_tab_selected`.
    static let home_tab_selected = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_tab_selected")
    /// Image `home_tab`.
    static let home_tab = Rswift.ImageResource(bundle: R.hostingBundle, name: "home_tab")
    /// Image `menuItem`.
    static let menuItem = Rswift.ImageResource(bundle: R.hostingBundle, name: "menuItem")
    /// Image `message`.
    static let message = Rswift.ImageResource(bundle: R.hostingBundle, name: "message")
    /// Image `mine_tab_selected`.
    static let mine_tab_selected = Rswift.ImageResource(bundle: R.hostingBundle, name: "mine_tab_selected")
    /// Image `mine_tab`.
    static let mine_tab = Rswift.ImageResource(bundle: R.hostingBundle, name: "mine_tab")
    /// Image `right_menu_QR_white`.
    static let right_menu_QR_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "right_menu_QR_white")
    /// Image `right_menu_QR`.
    static let right_menu_QR = Rswift.ImageResource(bundle: R.hostingBundle, name: "right_menu_QR")
    /// Image `right_menu_addFri_white`.
    static let right_menu_addFri_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "right_menu_addFri_white")
    /// Image `right_menu_addFri`.
    static let right_menu_addFri = Rswift.ImageResource(bundle: R.hostingBundle, name: "right_menu_addFri")
    /// Image `right_menu_facetoface_white`.
    static let right_menu_facetoface_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "right_menu_facetoface_white")
    /// Image `right_menu_facetoface`.
    static let right_menu_facetoface = Rswift.ImageResource(bundle: R.hostingBundle, name: "right_menu_facetoface")
    /// Image `right_menu_multichat_white`.
    static let right_menu_multichat_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "right_menu_multichat_white")
    /// Image `right_menu_multichat`.
    static let right_menu_multichat = Rswift.ImageResource(bundle: R.hostingBundle, name: "right_menu_multichat")
    /// Image `right_menu_payMoney_white`.
    static let right_menu_payMoney_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "right_menu_payMoney_white")
    /// Image `right_menu_payMoney`.
    static let right_menu_payMoney = Rswift.ImageResource(bundle: R.hostingBundle, name: "right_menu_payMoney")
    /// Image `right_menu_sendvideo_white`.
    static let right_menu_sendvideo_white = Rswift.ImageResource(bundle: R.hostingBundle, name: "right_menu_sendvideo_white")
    /// Image `right_menu_sendvideo`.
    static let right_menu_sendvideo = Rswift.ImageResource(bundle: R.hostingBundle, name: "right_menu_sendvideo")
    /// Image `scan`.
    static let scan = Rswift.ImageResource(bundle: R.hostingBundle, name: "scan")
    /// Image `search`.
    static let search = Rswift.ImageResource(bundle: R.hostingBundle, name: "search")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "add", bundle: ..., traitCollection: ...)`
    static func add(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.add, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "add-white", bundle: ..., traitCollection: ...)`
    static func addWhite(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.addWhite, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "addImage", bundle: ..., traitCollection: ...)`
    static func addImage(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.addImage, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "audio_bgm_4", bundle: ..., traitCollection: ...)`
    static func audio_bgm_4(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.audio_bgm_4, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "com_arrow_vc_back", bundle: ..., traitCollection: ...)`
    static func com_arrow_vc_back(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.com_arrow_vc_back, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "demoList_tab", bundle: ..., traitCollection: ...)`
    static func demoList_tab(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.demoList_tab, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "demoList_tab_selected", bundle: ..., traitCollection: ...)`
    static func demoList_tab_selected(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.demoList_tab_selected, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "header_bg_message", bundle: ..., traitCollection: ...)`
    static func header_bg_message(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.header_bg_message, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_button_bmfw", bundle: ..., traitCollection: ...)`
    static func home_button_bmfw(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_button_bmfw, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_button_jmsc", bundle: ..., traitCollection: ...)`
    static func home_button_jmsc(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_button_jmsc, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_button_mlxc", bundle: ..., traitCollection: ...)`
    static func home_button_mlxc(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_button_mlxc, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_button_myzq", bundle: ..., traitCollection: ...)`
    static func home_button_myzq(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_button_myzq, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_button_nczg", bundle: ..., traitCollection: ...)`
    static func home_button_nczg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_button_nczg, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_button_nyjs", bundle: ..., traitCollection: ...)`
    static func home_button_nyjs(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_button_nyjs, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_button_nyq", bundle: ..., traitCollection: ...)`
    static func home_button_nyq(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_button_nyq, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_button_schq", bundle: ..., traitCollection: ...)`
    static func home_button_schq(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_button_schq, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_button_shop", bundle: ..., traitCollection: ...)`
    static func home_button_shop(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_button_shop, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_button_xsp", bundle: ..., traitCollection: ...)`
    static func home_button_xsp(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_button_xsp, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_button_xwzc", bundle: ..., traitCollection: ...)`
    static func home_button_xwzc(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_button_xwzc, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_tab", bundle: ..., traitCollection: ...)`
    static func home_tab(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_tab, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "home_tab_selected", bundle: ..., traitCollection: ...)`
    static func home_tab_selected(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.home_tab_selected, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "menuItem", bundle: ..., traitCollection: ...)`
    static func menuItem(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.menuItem, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "message", bundle: ..., traitCollection: ...)`
    static func message(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.message, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mine_tab", bundle: ..., traitCollection: ...)`
    static func mine_tab(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mine_tab, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "mine_tab_selected", bundle: ..., traitCollection: ...)`
    static func mine_tab_selected(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.mine_tab_selected, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "right_menu_QR", bundle: ..., traitCollection: ...)`
    static func right_menu_QR(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.right_menu_QR, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "right_menu_QR_white", bundle: ..., traitCollection: ...)`
    static func right_menu_QR_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.right_menu_QR_white, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "right_menu_addFri", bundle: ..., traitCollection: ...)`
    static func right_menu_addFri(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.right_menu_addFri, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "right_menu_addFri_white", bundle: ..., traitCollection: ...)`
    static func right_menu_addFri_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.right_menu_addFri_white, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "right_menu_facetoface", bundle: ..., traitCollection: ...)`
    static func right_menu_facetoface(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.right_menu_facetoface, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "right_menu_facetoface_white", bundle: ..., traitCollection: ...)`
    static func right_menu_facetoface_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.right_menu_facetoface_white, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "right_menu_multichat", bundle: ..., traitCollection: ...)`
    static func right_menu_multichat(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.right_menu_multichat, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "right_menu_multichat_white", bundle: ..., traitCollection: ...)`
    static func right_menu_multichat_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.right_menu_multichat_white, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "right_menu_payMoney", bundle: ..., traitCollection: ...)`
    static func right_menu_payMoney(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.right_menu_payMoney, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "right_menu_payMoney_white", bundle: ..., traitCollection: ...)`
    static func right_menu_payMoney_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.right_menu_payMoney_white, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "right_menu_sendvideo", bundle: ..., traitCollection: ...)`
    static func right_menu_sendvideo(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.right_menu_sendvideo, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "right_menu_sendvideo_white", bundle: ..., traitCollection: ...)`
    static func right_menu_sendvideo_white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.right_menu_sendvideo_white, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "scan", bundle: ..., traitCollection: ...)`
    static func scan(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.scan, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "search", bundle: ..., traitCollection: ...)`
    static func search(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.search, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.string` struct is generated, and contains static references to 1 localization tables.
  struct string {
    /// This `R.string.localizable` struct is generated, and contains static references to 1 localization keys.
    struct localizable {
      /// en translation: menu
      ///
      /// Locales: en, zh-Hans
      static let menu = Rswift.StringResource(key: "menu", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "zh-Hans"], comment: nil)

      /// en translation: menu
      ///
      /// Locales: en, zh-Hans
      static func menu(preferredLanguages: [String]? = nil) -> String {
        guard let preferredLanguages = preferredLanguages else {
          return NSLocalizedString("menu", bundle: hostingBundle, comment: "")
        }

        guard let (_, bundle) = localeBundle(tableName: "Localizable", preferredLanguages: preferredLanguages) else {
          return "menu"
        }

        return NSLocalizedString("menu", bundle: bundle, comment: "")
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
