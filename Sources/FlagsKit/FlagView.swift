import SwiftUI
import Foundation

public extension Bundle {
    static var flagsKit: Bundle {
        return .module
    }
}

/// SwiftUI Flag view
///
/// Check init for more details on how to create a new flag view:
/// ``init(countryCode:style:contentMode:)``
///
/// Example:
///
/// ```swift
/// FlagView(countryCode: "US")
/// ```
public struct FlagView: View {

    private let countryCode: String
    private let style: Style
    private let contentMode: ContentMode

    /// Initaliser for FlagView
    /// - Parameters:
    ///   - countryCode: ``String`` ISO country code ("US" for example)
    ///   - style: ``Style`` image style
    ///   - contentMode: ``ContentMode`` content mode of the image
    public init(
        countryCode: String,
        style: Style = .default,
        contentMode: ContentMode = .fill
    ) {
        self.countryCode = countryCode.uppercased()
        self.style = style
        self.contentMode = contentMode
    }

    public var body: some View {
        switch style {
        case .default:
            Image(countryCode.lowercased(), bundle: .currentModule)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        case .circle:
            Image(countryCode.lowercased(), bundle: .currentModule)
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .clipShape(Circle())
        case .rounded(let radius):
            Color.clear
                .aspectRatio(contentMode: contentMode)
                .overlay(
                    Image(countryCode.lowercased(), bundle: .currentModule)
                        .resizable()
                        .scaledToFill()
                )
                .clipShape(RoundedRectangle(cornerRadius: radius))
        }
    }
}
#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

// MARK: - Public helpers to fetch platform images from the package bundle

public enum FlagImage {
    /// Normalise le code pays (ex: "FR" -> "fr")
    @inlinable
    private static func normalized(_ code: String) -> String {
        code.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    #if canImport(UIKit)
    /// UIImage pour iOS / tvOS / visionOS / macCatalyst
    @inlinable
    public static func uiImage(forCountryCode code: String) -> UIImage? {
        let name = normalized(code)
        // ✅ iOS: pas de `image(forResource:)` sur Bundle — on utilise l'API UIKit ci-dessous
        return UIImage(named: name, in: .currentModule, compatibleWith: nil)
    }
    #endif

    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    /// NSImage pour macOS (Catalyst utilise UIKit ci-dessus)
    @inlinable
    public static func nsImage(forCountryCode code: String) -> NSImage? {
        let name = normalized(code)
        // ✅ macOS: utiliser le bundle du package + image(forResource:)
        if let img = Bundle.currentModule.image(forResource: NSImage.Name(name)) {
            return img
        }
        // Anciennes surcharges prennent String ; on tente aussi la version String si dispo
        return Bundle.currentModule.image(forResource: name)
    }
    #endif
}

public extension FlagView {

    /// Style of the flag image
    enum Style {
        case `default`
        case circle
        case rounded(CGFloat)
    }
}

struct FlagView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            FlagView(countryCode: "US")
                .frame(width: 50, height: 50)
                .previewLayout(.sizeThatFits)
            FlagView(countryCode: "ro", style: .circle)
                .frame(width: 50, height: 50)
                .previewLayout(.sizeThatFits)
        }
    }
}
