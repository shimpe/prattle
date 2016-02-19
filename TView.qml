import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
    id: it
    property bool ready : false;
    property ListModel model : {}

    GridLayout {
        id: grid
        rows: 5
        columns: 1
        anchors.fill: parent
        ComboBox {
            id: voiceSelector
            enabled: it.ready
            model: it.model
            Layout.fillWidth: true
        }

        TextArea {
            id: textInput
            focus: true
            enabled: it.ready
            text: "Good morning world!"
            Layout.fillWidth: true
            Layout.fillHeight: true

            Keys.onReturnPressed:
            {
                var voicetxt = voiceSelector.currentText;
                var voicetxt_els = voicetxt.split(" ");
                var voice = voicetxt_els[0];
                var locale = voicetxt_els[1];
                if (event.modifiers == Qt.ControlModifier)
                {
                    MaryTTS.synthesize(textInput.text, voice, locale, false);
                    textInput.text = ""
                    event.accepted = true
                }
                else if (event.modifiers == Qt.AltModifier)
                {
                    MaryTTS.synthesize("", voice, locale, true);
                    event.accepted = true
                }
                else
                {
                    event.accepted = false
                }
            }
            Keys.onEscapePressed:
            {
                MaryTTS.stopSound();
                event.accepted = true
            }
        }


        RowLayout {
            id: buttons

            Button {
                id: sayButton
                text: "Say and clear (Ctrl+Enter)"
                Layout.fillWidth: false
                enabled: it.ready

                onClicked: {
                    var voicetxt = voiceSelector.currentText;
                    var voicetxt_els = voicetxt.split(" ");
                    var voice = voicetxt_els[0];
                    var locale = voicetxt_els[1];
                    MaryTTS.synthesize(textInput.text, voice, locale, false);
                    textInput.text = ""
                }
            }

            Button {
                id: sayCBButton
                text: "Say what's in the clipboard (Alt+Enter)"
                Layout.fillWidth: false
                enabled: it.ready

                onClicked: {
                    var voicetxt = voiceSelector.currentText;
                    var voicetxt_els = voicetxt.split(" ");
                    var voice = voicetxt_els[0];
                    var locale = voicetxt_els[1];
                    MaryTTS.synthesize(textInput.text, voice, locale, true);
                }
            }

            Button {
                id: stopSoundButton
                text: "Abort sound (Esc)"
                Layout.fillWidth: false
                enabled: it.ready

                onClicked: {
                    MaryTTS.stopSound();
                }
            }
        }
    }
}

