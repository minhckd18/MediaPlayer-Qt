import QtQuick 2.15
import QtTest 1.15
import "qrc:/Component"

Item {
    width: 800
    height: 600

    SwitchButton {
        id: myButton
        anchors.centerIn: parent
        icon_on: "qrc:/Image/shuffle.png"
        icon_off: "qrc:/Image/shuffle-1.png"
    }

    TestCase {
        name: "SwitchButton"
        when: windowShown

        function init() {
            myButton.status = 0  // Reset the button
        }

        function test_initial_state() {
            compare(myButton.status, 0, "Initial status should be 0 (Off)")
            compare(myButton.icon_on, "qrc:/Image/shuffle.png", "On icon path is correct")
            compare(myButton.icon_off, "qrc:/Image/shuffle-1.png", "Off icon path is correct")
        }

        function test_click_behavior() {
            // Test clicking to turn on
            mouseClick(myButton)
            compare(myButton.status, 1, "Status should be 1 (On) after first click")

            // Test clicking to turn off
            mouseClick(myButton)
            compare(myButton.status, 0, "Status should be 0 (Off) after second click")
        }

        function test_image_source() {
            compare(myButton.children[0].source, myButton.icon_off, "Initial image should be off icon")

            mouseClick(myButton)
            compare(myButton.children[0].source, myButton.icon_on, "Image should change to on icon after click")

            mouseClick(myButton)
            compare(myButton.children[0].source, myButton.icon_off, "Image should change back to off icon after second click")
        }
    }
}
