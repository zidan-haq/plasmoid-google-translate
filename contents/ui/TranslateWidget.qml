import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15

Item {
    id: translateWidget
    width: 500
    height: 350

    property string sourceLanguage: "en"
    property string targetLanguage: "pt"
    property string translatedText: ""

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        QQC2.TextField {
            id: inputField
            placeholderText: "Enter text to translate"
            Layout.fillWidth: true
            onTextChanged: {
                if (text.length > 0) {
                    translateText(text);
                } else {
                    translatedText = "";
                }
            }
        }

        QQC2.Label {
            id: outputText
            text: translatedText
            wrapMode: QQC2.Label.Wrap
            Layout.fillWidth: true
        }

        LanguageSelector {
            id: languageSelector
            onSelectedLanguagesChanged: {
                sourceLanguage = languageSelector.sourceLanguage;
                targetLanguage = languageSelector.targetLanguage;
            }
        }
    }

    function translateText(text) {
        var url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl="
            + encodeURIComponent(sourceLanguage)
            + "&tl=" + encodeURIComponent(targetLanguage)
            + "&dt=t&q=" + encodeURIComponent(text);

        var xhr = new XMLHttpRequest();
        xhr.open("GET", url);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    try {
                        var result = JSON.parse(xhr.responseText);
                        translatedText = result[0][0][0];
                    } catch (e) {
                        translatedText = "Error parsing translation.";
                    }
                } else {
                    translatedText = "Error: " + xhr.statusText;
                }
            }
        };
        xhr.send();
    }
}