import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

MainView {
    id: root
    objectName: "mainView"

    applicationName: "deer-danger.wolf-deer-snake-inc"

    // ── Suru / Ubuntu Touch design tokens ──────────────────────────────────
    readonly property color suruAubergine:   '#A8005C'   // brighter, more vivid magenta
    readonly property color suruOrange:      "#E95420"   // unchanged — strong identity color
    readonly property color nlBlue:          "#1A4DB3"   // lighter, readable on dark bg
    readonly property color nlBlueDark:      "#0E306E"   // slightly warmer dark
    readonly property color alertOrange:     '#F0622A'   // renamed: it was never amber
    readonly property color alertOrangeBg:   '#3D2410'   // truer to the orange family
    readonly property color cardBg:          '#1C1C1E'   // warm near-black (iOS-style)
    readonly property color pageBg:          '#111113'   // off-black, avoids pure black harshness
    readonly property color divider:         '#2A2A2D'   // slightly more visible
    readonly property color textPrimary:     '#F0EEE9'   // warm white — less retinal glare
    readonly property color textSecondary:   "#8C8A86"   // passes WCAG AA on #1C1C1E
    readonly property color textMuted:       "#B0AEA9"   // warm tint, stays subtle

    width:  units.gu(46)
    height: units.gu(80)
    backgroundColor: pageBg

    ListModel { id: dangerModel }
    ListModel { id: filteredModel }

    Component.onCompleted: loadJson()

    function loadJson() {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var arr = JSON.parse(xhr.responseText)
                dangerModel.clear()
                for (var i = 0; i < arr.length; i++) {
                    dangerModel.append(arr[i])
                }
                applyFilter("")
            }
        }
        xhr.open("GET", Qt.resolvedUrl("dangers.json"))
        xhr.send()
    }

    function applyFilter(term) {
        filteredModel.clear()
        var t = term.toLowerCase().trim()
        for (var i = 0; i < dangerModel.count; i++) {
            var item = dangerModel.get(i)
            if (t === ""
                    || item.name.toLowerCase().indexOf(t) !== -1
                    || item.severity.toLowerCase().indexOf(t) !== -1) {
                filteredModel.append(item)
            }
        }
    }

    PageStack {
        id: pageStack
        Component.onCompleted: pageStack.push(mainPage)

        // ── MAIN LIST PAGE ────────────────────────────────────────────────
        Page {
            id: mainPage

            header: PageHeader {
                contents: Item {
                    anchors.fill: parent

                    RowLayout {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left:           parent.left
                        anchors.leftMargin:     units.gu(1)
                        spacing: units.gu(1.2)

                        Rectangle {
                            width:  units.gu(3.6)
                            height: units.gu(3.6)
                            radius: units.gu(0.5)
                            color:  root.suruOrange

                            Icon {
                                anchors.centerIn: parent
                                name:   "security-alert"
                                width:  units.gu(2.2)
                                height: units.gu(2.2)
                                color:  "white"
                            }
                        }

                        ColumnLayout {
                            spacing: 0
                            Label {
                                text:               "CRISIS DECK"
                                color:              "white"
                                font.bold:          true
                                font.pixelSize:     units.gu(2.2)
                                font.letterSpacing: units.gu(0.12)
                            }
                            Label {
                                text:           "NL-Alert Emergency Protocols"
                                color:          Qt.rgba(1, 1, 1, 0.58)
                                font.pixelSize: units.gu(1.3)
                            }
                        }
                    }
                }

                StyleHints {
                    backgroundColor: root.nlBlueDark
                    titleColor:      "white"
                    dividerColor:    Qt.rgba(1, 1, 1, 0.10)
                }
            }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // ── Search bar ────────────────────────────────────────────
                Rectangle {
                    Layout.fillWidth: true
                    height: units.gu(7)
                    color:  root.nlBlue

                    RowLayout {
                        anchors.fill:         parent
                        anchors.leftMargin:   units.gu(1.5)
                        anchors.rightMargin:  units.gu(1.5)
                        anchors.topMargin:    units.gu(0.9)
                        anchors.bottomMargin: units.gu(0.9)
                        spacing: units.gu(1)

                        Rectangle {
                            width:  units.gu(4)
                            height: units.gu(4)
                            radius: units.gu(0.5)
                            color:  Qt.rgba(1, 1, 1, 0.14)

                            Icon {
                                anchors.centerIn: parent
                                name:   "find"
                                width:  units.gu(2.2)
                                height: units.gu(2.2)
                                color:  "white"
                            }
                        }

                        // TextField wrapped in Item — avoids TextFieldStyle
                        Item {
                            Layout.fillWidth:  true
                            Layout.fillHeight: true

                            Rectangle {
                                anchors.fill:  parent
                                radius:        units.gu(0.5)
                                color:         "white"
                                border.color:  root.divider
                                border.width:  1
                            }

                            TextField {
                                id: searchBox
                                anchors.fill:    parent
                                placeholderText: "Search " + dangerModel.count + " protocols…"
                                hasClearButton:  true
                                color:           root.textPrimary
                                font.pixelSize:  units.gu(1.75)
                                onTextChanged:   applyFilter(text)
                            }
                        }
                    }
                }

                // ── Status ribbon ─────────────────────────────────────────
                Rectangle {
                    Layout.fillWidth: true
                    height: units.gu(4.5)
                    color:  root.alertAmberBg

                    Rectangle {
                        anchors.top: parent.top
                        width:  parent.width
                        height: units.gu(0.28)
                        color:  root.alertAmber
                    }
                    Rectangle {
                        anchors.bottom: parent.bottom
                        width:  parent.width
                        height: units.gu(0.1)
                        color:  root.divider
                    }

                    RowLayout {
                        anchors.fill:         parent
                        anchors.leftMargin:   units.gu(1.5)
                        anchors.rightMargin:  units.gu(1.5)
                        spacing: units.gu(0.9)

                        Rectangle {
                            width:  units.gu(0.85)
                            height: units.gu(0.85)
                            radius: width / 2
                            color:  root.alertAmber

                            SequentialAnimation on opacity {
                                loops: Animation.Infinite
                                NumberAnimation { to: 0.25; duration: 900 }
                                NumberAnimation { to: 1.00; duration: 900 }
                            }
                        }

                        Label {
                            Layout.fillWidth: true
                            text: filteredModel.count > 0
                                  ? filteredModel.count + " protocols ready — tap any card for action steps"
                                  : "No matching protocols found"
                            font.bold:  true
                            fontSize:   "Small"
                            color:      "#5A4200"
                            elide:      Text.ElideRight
                        }
                    }
                }

                // ── Protocol list ─────────────────────────────────────────
                ListView {
                    id: protocolList
                    Layout.fillWidth:  true
                    Layout.fillHeight: true
                    model: filteredModel
                    clip:  true
                    spacing: 0

                    Item {
                        anchors.centerIn: parent
                        width:   parent.width
                        height:  units.gu(18)
                        visible: protocolList.count === 0

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: units.gu(0.8)

                            Icon {
                                Layout.alignment: Qt.AlignHCenter
                                name:   "find"
                                width:  units.gu(4.5)
                                height: units.gu(4.5)
                                color:  root.textMuted
                            }
                            Label {
                                Layout.alignment: Qt.AlignHCenter
                                text:           "No matching protocols"
                                color:          root.textMuted
                                font.pixelSize: units.gu(1.75)
                            }
                            Label {
                                Layout.alignment: Qt.AlignHCenter
                                text:           "Try a different keyword"
                                color:          root.textMuted
                                font.pixelSize: units.gu(1.4)
                                font.italic:    true
                            }
                        }
                    }

                    delegate: Item {
                        width:  ListView.view.width
                        height: units.gu(9.5)

                        Rectangle {
                            anchors.fill:         parent
                            anchors.leftMargin:   units.gu(1.5)
                            anchors.rightMargin:  units.gu(1.5)
                            anchors.topMargin:    units.gu(0.45)
                            anchors.bottomMargin: units.gu(0.45)
                            color:   root.cardBg
                            radius:  units.gu(0.8)
                            border.color: root.divider
                            border.width: 1

                            Rectangle {
                                anchors.left:         parent.left
                                anchors.top:          parent.top
                                anchors.bottom:       parent.bottom
                                anchors.topMargin:    units.gu(0.6)
                                anchors.bottomMargin: units.gu(0.6)
                                width:  units.gu(0.5)
                                radius: units.gu(0.25)
                                color:  model.colorCode
                            }

                            RowLayout {
                                anchors.fill:         parent
                                anchors.leftMargin:   units.gu(1.5)
                                anchors.rightMargin:  units.gu(1.2)
                                anchors.topMargin:    units.gu(1.0)
                                anchors.bottomMargin: units.gu(1.0)
                                spacing: units.gu(1.4)

                                Rectangle {
                                    width:  units.gu(4.5)
                                    height: units.gu(4.5)
                                    radius: units.gu(0.65)
                                    color: {
                                        var r = parseInt(model.colorCode.slice(1,3), 16) / 255
                                        var g = parseInt(model.colorCode.slice(3,5), 16) / 255
                                        var b = parseInt(model.colorCode.slice(5,7), 16) / 255
                                        return Qt.rgba(r, g, b, 0.09)
                                    }

                                    Icon {
                                        anchors.centerIn: parent
                                        name:   model.iconName
                                        width:  units.gu(2.7)
                                        height: units.gu(2.7)
                                        color:  model.colorCode
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: units.gu(0.35)

                                    Label {
                                        Layout.fillWidth: true
                                        text:           model.name
                                        font.bold:      true
                                        font.pixelSize: units.gu(1.9)
                                        color:          root.textPrimary
                                        elide:          Text.ElideRight
                                    }

                                    Rectangle {
                                        width:  pill.implicitWidth + units.gu(1.4)
                                        height: units.gu(2.05)
                                        radius: units.gu(1.0)
                                        color: {
                                            var r = parseInt(model.colorCode.slice(1,3), 16) / 255
                                            var g = parseInt(model.colorCode.slice(3,5), 16) / 255
                                            var b = parseInt(model.colorCode.slice(5,7), 16) / 255
                                            return Qt.rgba(r, g, b, 0.10)
                                        }

                                        Label {
                                            id: pill
                                            anchors.centerIn:   parent
                                            text:               model.severity
                                            font.bold:          true
                                            font.pixelSize:     units.gu(1.2)
                                            font.letterSpacing: units.gu(0.04)
                                            color:              model.colorCode
                                        }
                                    }
                                }

                                Label {
                                    text:           "›"
                                    font.pixelSize: units.gu(3)
                                    color:          root.textMuted
                                }
                            }

                            MouseArea {
                                anchors.fill: parent

                                Rectangle {
                                    anchors.fill: parent
                                    radius:  parent.parent.radius
                                    color:   Qt.rgba(0, 0, 0, 0.055)
                                    visible: parent.pressed
                                }

                                onClicked: {
                                    pageStack.push(detailPage, {
                                        dangerName:    model.name,
                                        dangerAdvice:  model.advice,
                                        severityText:  model.severity,
                                        severityColor: model.colorCode,
                                        iconLabel:     model.iconName
                                    })
                                }
                            }
                        }
                    }

                    footer: Item { height: units.gu(1.5) }
                }
            }
        }

        // ── DETAIL PAGE ───────────────────────────────────────────────────
        Component {
            id: detailPage

            Page {
                property string dangerName
                property string dangerAdvice
                property string severityText
                property string severityColor
                property string iconLabel

                header: PageHeader {
                    title: dangerName
                    StyleHints {
                        backgroundColor: root.suruAubergine
                        titleColor:      "white"
                        dividerColor:    Qt.rgba(1, 1, 1, 0.12)
                    }
                }

                Flickable {
                    anchors.fill: parent
                    contentHeight: detailCol.implicitHeight + units.gu(5)
                    clip: true

                    ColumnLayout {
                        id: detailCol
                        anchors.left:       parent.left
                        anchors.right:      parent.right
                        anchors.top:        parent.top
                        anchors.margins:    units.gu(1.8)
                        anchors.topMargin:  units.gu(5)
                        spacing: units.gu(1.8)

                        // ── Hero banner ───────────────────────────────────
                        Rectangle {
                            Layout.fillWidth: true
                            height: units.gu(12)
                            radius: units.gu(1)
                            color:  severityColor
                            clip:   true

                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.00) }
                                    GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.30) }
                                }
                            }

                            Rectangle {
                                width:  units.gu(14)
                                height: units.gu(14)
                                radius: units.gu(7)
                                color:  Qt.rgba(1, 1, 1, 0.09)
                                anchors.right:        parent.right
                                anchors.bottom:       parent.bottom
                                anchors.rightMargin:  -units.gu(3)
                                anchors.bottomMargin: -units.gu(3)
                            }

                            RowLayout {
                                anchors.fill:    parent
                                anchors.margins: units.gu(1.8)
                                spacing: units.gu(1.4)

                                Icon {
                                    name:             iconLabel
                                    width:            units.gu(4.5)
                                    height:           units.gu(4.5)
                                    color:            "white"
                                    Layout.alignment: Qt.AlignVCenter
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: units.gu(0.5)

                                    Label {
                                        Layout.fillWidth: true
                                        text:           dangerName
                                        color:          "white"
                                        font.bold:      true
                                        font.pixelSize: units.gu(2.1)
                                        wrapMode:       Text.Wrap
                                    }

                                    Rectangle {
                                        width:  capLabel.implicitWidth + units.gu(1.6)
                                        height: units.gu(2.2)
                                        radius: units.gu(1.1)
                                        color:  Qt.rgba(1, 1, 1, 0.22)

                                        Label {
                                            id: capLabel
                                            anchors.centerIn:   parent
                                            text:               severityText
                                            color:              "white"
                                            font.bold:          true
                                            font.pixelSize:     units.gu(1.25)
                                            font.letterSpacing: units.gu(0.06)
                                        }
                                    }
                                }
                            }
                        }

                        // ── Section header ────────────────────────────────
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: units.gu(0.9)

                            Rectangle {
                                width:  units.gu(0.4)
                                height: units.gu(2.2)
                                radius: units.gu(0.2)
                                color:  root.nlBlue
                            }
                            Label {
                                text:               "FIELD PROTOCOLS"
                                font.bold:          true
                                font.pixelSize:     units.gu(1.5)
                                font.letterSpacing: units.gu(0.10)
                                color:              root.nlBlue
                            }
                        }

                        // ── Step cards ────────────────────────────────────
                        Repeater {
                            model: {
                                var blocks = dangerAdvice.split("\n\n")
                                return blocks.filter(function(b) {
                                    return b.trim() !== ""
                                })
                            }

                            delegate: Rectangle {
                                Layout.fillWidth: true
                                height:       stepRow.implicitHeight + units.gu(2.4)
                                color:        root.cardBg
                                radius:       units.gu(0.75)
                                border.color: root.divider
                                border.width: 1

                                property var    lines:    modelData.split("\n")
                                property string stepHead: lines[0].replace(/^\d+\.\s*/, "")
                                property string stepBody: lines.slice(1).join(" ").trim()

                                RowLayout {
                                    id: stepRow
                                    anchors.left:    parent.left
                                    anchors.right:   parent.right
                                    anchors.top:     parent.top
                                    anchors.margins: units.gu(1.5)
                                    spacing: units.gu(1.2)

                                    Rectangle {
                                        width:            units.gu(2.9)
                                        height:           units.gu(2.9)
                                        radius:           units.gu(1.45)
                                        color:            root.nlBlue
                                        Layout.alignment: Qt.AlignTop

                                        Label {
                                            anchors.centerIn: parent
                                            text:           index + 1
                                            color:          "white"
                                            font.bold:      true
                                            font.pixelSize: units.gu(1.4)
                                        }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: units.gu(0.35)

                                        Label {
                                            Layout.fillWidth: true
                                            text:           stepHead
                                            font.bold:      true
                                            font.pixelSize: units.gu(1.7)
                                            color:          root.textPrimary
                                            wrapMode:       Text.Wrap
                                        }

                                        Label {
                                            Layout.fillWidth: true
                                            text:           stepBody
                                            visible:        stepBody !== ""
                                            font.pixelSize: units.gu(1.5)
                                            color:          root.textSecondary
                                            wrapMode:       Text.Wrap
                                            lineHeight:     1.4
                                        }
                                    }
                                }
                            }
                        }

                        // ── Footer ────────────────────────────────────────
                        Label {
                            Layout.fillWidth: true
                            text:                "Source: NL-Alert Civil Emergency Protocols"
                            color:               root.textMuted
                            font.pixelSize:      units.gu(1.3)
                            font.italic:         true
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}