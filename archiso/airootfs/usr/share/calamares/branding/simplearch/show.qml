import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation
{
    id: presentation

    Timer {
        interval: 7000
        running: presentation.activatedInCalamares
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide {
        centeredText: qsTr("Installing SimpleArch")
    }

    Slide {
        centeredText: qsTr("Preparing KDE Plasma, Btrfs and snapshots")
    }

    Slide {
        centeredText: qsTr("Configuring the system for first boot")
    }

    function onActivate() {
        presentation.currentSlide = 0;
    }

    function onLeave() {
    }
}
