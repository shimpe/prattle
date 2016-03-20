import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
    id: configView

    property string currentURL;
    signal backClicked;
    signal urlChanged(string URL);
    Layout.fillWidth: true

    ColumnLayout {
        Layout.fillWidth: true

        Button {
            id: returnButton
            text: "<<< Back"
            onClicked :
            {
                configView.urlChanged(textEdit.text);
                configView.backClicked();
            }

        }

       GridLayout {
            id: configGrid
            rows: 1
            columns: 2
            Layout.fillWidth:  true
            Layout.preferredWidth: 500

            Text {
                text : "MaryTTS server location http://"
                Layout.fillWidth: false
            }

            TextField {
                id: textEdit
                text: configView.currentURL;
                focus: true
                Keys.onReturnPressed: configView.urlChanged(textEdit.text)
                Layout.fillWidth: true
            }

       }
    }

}
