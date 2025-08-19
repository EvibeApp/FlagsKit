import Foundation

// Marqueur privé pour d'éventuels fallback (rarement utile avec SPM)
private final class _FlagsKitBundleMarker {}

public enum FlagsKitResources {
    /// Bundle contenant les PNG du package.
    public static let bundle: Bundle = {
        #if SWIFT_PACKAGE
        // ✅ .module n'est visible QUE depuis le package (pas depuis l'app)
        return .module
        #else
        // Fallback si jamais FlagsKit était intégré autrement
        return Bundle(for: _FlagsKitBundleMarker.self)
        #endif
    }()

    /// Récupère les Data d'une image du package (par défaut un PNG).
    /// - Parameters:
    ///   - name: nom du fichier SANS extension (ex: "us", "fr")
    ///   - ext: extension (par défaut "png")
    /// - Returns: Data du fichier ou nil si absente.
    @inlinable
    public static func imageData(named name: String, ext: String = "png") -> Data? {
        guard let url = bundle.url(forResource: name, withExtension: ext) else { return nil }
        return try? Data(contentsOf: url, options: [.mappedIfSafe])
    }

    /// Raccourci pratique : code pays -> Data (normalise en lowercase).
    @inlinable
    public static func imageData(forCountryCode code: String, ext: String = "png") -> Data? {
        imageData(named: code.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), ext: ext)
    }
}
