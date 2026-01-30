import qs.modules.common

import QtQuick
import M3Shapes

MaterialShape {
    id: shape

    property bool animate: true

    shape: getRandomShape()
    animationDuration: 500
    color: Appearance.player.myBackground

    function getRandomShape() {
        const index = Math.floor(Math.random() * shape.shapes.length);
        return shapes[index];
    }
    property var shapes: [MaterialShape.Circle, MaterialShape.Square, MaterialShape.Slanted, MaterialShape.Arch, MaterialShape.Fan, MaterialShape.Arrow, MaterialShape.SemiCircle, MaterialShape.Oval, MaterialShape.Pill, MaterialShape.Triangle, MaterialShape.Diamond, MaterialShape.ClamShell, MaterialShape.Pentagon, MaterialShape.Gem, MaterialShape.Sunny, MaterialShape.VerySunny, MaterialShape.Cookie4Sided, MaterialShape.Cookie6Sided, MaterialShape.Cookie7Sided, MaterialShape.Cookie9Sided, MaterialShape.Cookie12Sided, MaterialShape.Ghostish, MaterialShape.Clover4Leaf, MaterialShape.Clover8Leaf, MaterialShape.Burst, MaterialShape.SoftBurst, MaterialShape.Boom, MaterialShape.SoftBoom, MaterialShape.Flower, MaterialShape.Puffy, MaterialShape.PuffyDiamond, MaterialShape.PixelCircle, MaterialShape.PixelTriangle, MaterialShape.Bun, MaterialShape.Heart,]

    Timer {
        interval: 2000    // change every 1 second
        running: shape.animate
        repeat: true
        onTriggered: {
            const newShape = shape.getRandomShape();
            if (newShape)
                shape.shape = newShape;
        }
    }
}
