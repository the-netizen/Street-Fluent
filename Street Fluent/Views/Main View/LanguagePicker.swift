import SwiftUI

// Toolbar button showing current language flag.
// Tapping opens a dropdown to switch languages.
struct LanguagePickerButton: View {
    var settings: AppSettings
    
    var body: some View {
        Menu {
            ForEach(TargetLanguage.allCases) { language in
                Button {
                    settings.selectedLanguage = language
                } label: {
                    HStack {
                        Text(language.flag)
                        if settings.selectedLanguage == language {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            // Flag only — clean and simple
            HStack(spacing: 2) {
                Text(settings.selectedLanguage.flag)
                    .font(.title2)
                Image(systemName: "chevron.down")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
            }
        }
    }
}

#Preview {
    LanguagePickerButton(settings: AppSettings.shared)
}
