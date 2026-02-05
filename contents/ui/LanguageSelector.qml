import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15

Item {
    id: languageSelector

    property string sourceLanguage: "en"
    property string targetLanguage: "pt"
    property string storedSource: ""
    property var languages: [
        { name: "English", code: "en" },
        { name: "Portuguese", code: "pt" },
        { name: "Spanish", code: "es" },
        { name: "Chinese", code: "zh" },
        { name: "Japanese", code: "ja" },
        { name: "German", code: "de" },
        { name: "Arabic", code: "ar" },
        { name: "Hindi", code: "hi" }
    ]

    signal selectedLanguagesChanged(string source, string target)

    RowLayout {
        spacing: 65

        ColumnLayout {
            spacing: 5

            RowLayout {
                QQC2.Label { text: "Source Language:" }
                QQC2.ComboBox {
                    id: sourceLanguageCombo
                    model: languageSelector.languages
                    textRole: "name"
                    currentIndex: languageSelector.languages.findIndex(function(lang) { return lang.code === languageSelector.sourceLanguage })
                    onCurrentIndexChanged: {
                        languageSelector.sourceLanguage = languageSelector.languages[currentIndex].code
                        languageSelector.selectedLanguagesChanged(languageSelector.sourceLanguage, languageSelector.targetLanguage)
                    }
                }
            }

            RowLayout {
                QQC2.Label { text: "Target Language:" }
                QQC2.ComboBox {
                    id: targetLanguageCombo
                    model: languageSelector.languages
                    textRole: "name"
                    currentIndex: languageSelector.languages.findIndex(function(lang) { return lang.code === languageSelector.targetLanguage })
                    onCurrentIndexChanged: {
                        languageSelector.targetLanguage = languageSelector.languages[currentIndex].code
                        languageSelector.selectedLanguagesChanged(languageSelector.sourceLanguage, languageSelector.targetLanguage)
                    }
                }
            }
        }

        QQC2.Button {
            text: "Change"
            onClicked: {
                languageSelector.storedSource = languageSelector.sourceLanguage
                languageSelector.sourceLanguage = languageSelector.targetLanguage
                languageSelector.targetLanguage = languageSelector.storedSource
                languageSelector.selectedLanguagesChanged(languageSelector.sourceLanguage, languageSelector.targetLanguage)
            }
        }
    }
}