import Foundation
public enum FlagsKitResources {
    
    @inlinable
    public static func imageData(named name: String, ext: String = "png") -> Data? {
        guard let url = Bundle.currentModule.url(forResource: name, withExtension: ext) else { return nil }
        return try? Data(contentsOf: url, options: [.mappedIfSafe])
    }

    /// Raccourci pratique : code pays -> Data (normalise en lowercase).
    @inlinable
    public static func imageData(forCountryCode code: String, ext: String = "png") -> Data? {
        imageData(named: code.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), ext: ext)
    }
}
