import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.plasma.plasmoid 2.0
import "." as Components

PlasmoidItem {
    id: root

    property string sourceLanguage: "en"
    property string targetLanguage: "pt"
    property string inputText: ""
    property string translatedText: ""
    property bool loading: false

    function translateRequest() {
        root.loading = true
        root.translatedText = ""
        var xhr = new XMLHttpRequest()
        var url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl="
            + encodeURIComponent(root.sourceLanguage)
            + "&tl=" + encodeURIComponent(root.targetLanguage)
            + "&dt=t&q=" + encodeURIComponent(root.inputText)

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                root.loading = false
                if (xhr.status === 200) {
                    try {
                        var result = JSON.parse(xhr.responseText)
                        root.translatedText = result[0][0][0]
                    } catch (e) {
                        root.translatedText = "Error parsing translation."
                    }
                } else {
                    root.translatedText = "Translation failed."
                }
            }
        }
        xhr.open("GET", url)
        xhr.send()
    }

    fullRepresentation: ColumnLayout {
        Layout.preferredWidth: 400
        Layout.minimumWidth: 300
        Layout.minimumHeight: 300
        anchors.centerIn: parent
        spacing: 10
        anchors.margins: 10
        Keys.forwardTo: inputArea


        Components.LanguageSelector {
            Layout.preferredHeight: 60
            Layout.alignment: Qt.AlignTop
            id: langSelector
            sourceLanguage: root.sourceLanguage
            targetLanguage: root.targetLanguage
            onSelectedLanguagesChanged: (src, tgt) => {
                root.sourceLanguage = src
                root.targetLanguage = tgt
            }
        }

        QQC2.TextArea {
            id: inputArea
            Layout.fillWidth: true
            Layout.preferredHeight: 65
            wrapMode: Text.Wrap
            placeholderText: "Type text to translate..."
            text: root.inputText
            onTextChanged: root.inputText = text

            Keys.onPressed: {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    root.translateRequest()
                    event.accepted = true // it avoid a new line insertion
                }
            }
        }

        QQC2.Button {
            Layout.alignment: Qt.AlignRight
            text: "Translate"
            enabled: !root.loading && root.inputText.length > 0
            onClicked: {
                root.translateRequest()
            }
        }

        QQC2.TextArea {
            Layout.fillWidth: true
            Layout.preferredHeight: 65
            wrapMode: Text.Wrap
            readOnly: true
            placeholderText: "Translation will appear here."
            text: root.translatedText
        }
    }
}