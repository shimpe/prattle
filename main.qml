import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Prattle: simple MaryTTS frontend")

    property bool allReady : false
    property int checkInterval: 500

    ListModel {
        id: voices
    }

    function getVoices()
    {
        var http = new XMLHttpRequest();
        var url = "http://localhost:59125/voices";
        var params = "";
        http.open("POST", url, true);
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");
        http.onreadystatechange = function()
        {
            if (http.readyState == http.DONE)
            {
                if (http.status == 200)
                {
                    var listvoices = http.responseText.match(/[^\r\n]+/g);
                    voices.clear();
                    var arrayLength = listvoices.length;
                    for (var i = 0; i < arrayLength; i++) {
                        voices.append( { "text" : listvoices[i] } )
                    }
                }
                else
                {
                    versionLabel.text = "Error retreiving available voices from MaryTTS."
                }
            }
        }
        http.send(params);
    }

    function updateStatus()
    {
        var http = new XMLHttpRequest();
        var url = "http://localhost:59125/version";
        var params = "";
        http.open("POST", url, true);

        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function()
        { // Call a function when the state changes.
            if (http.readyState == http.DONE)
            {
                if (http.status == 200)
                {
                    versionLabel.text = http.responseText

                    if (!allReady)
                    {
                        getVoices();
                    }

                    allReady = true
                }
                else
                {
                    versionLabel.text = "<b>Error connecting to MaryTTS server at http://localhost:59125. Will retry in 500ms.</b>"
                    allReady = false
                }
            }
        }
        http.send(params);
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }


    Component {
        id: txtView

        TView {
            id: tView
            ready : allReady
            model: voices
            anchors.fill: parent
        }

    }

    StackView
    {
        id: sView
        initialItem: txtView

        anchors.fill: parent
    }

    statusBar: StatusBar {
        id: sBar
        RowLayout {
            Label { text: "Mary TTS server version: " }
            Label {
                id: versionLabel
                text: "None"
            }
        }

        Timer {
            interval: allReady ? 3000 : 500;
            running: true;
            repeat: true
            onTriggered: updateStatus();
        }

    }
}
