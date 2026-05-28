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
        centeredText: qsTr("Instalando o SimpleArch")
    }

    Slide {
        centeredText: qsTr("Preparando KDE Plasma, Btrfs e snapshots")
    }

    Slide {
        centeredText: qsTr("Configurando o sistema para o primeiro boot")
    }

    function onActivate() {
        presentation.currentSlide = 0;
    }

    function onLeave() {
    }
}
