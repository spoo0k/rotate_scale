import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    visible: true
    width: 800
    height: 600

    Item {
        id: container
        anchors.centerIn: parent
        transform: [
            Matrix4x4 {
                id: rootMatrixTransform
                matrix: Qt.matrix4x4()
            }
        ]


        Rectangle {
            id: rect
            width: 200
            height: 150
            color: "lightblue"
            border.color: "blue"
            border.width: 2

            property real x_scale: 1.0
            property real y_scale: 1.0
            property real rotation_angle: 0

            transform: [
                Matrix4x4 {
                    id: matrixTransform
                    matrix: Qt.matrix4x4()
                }
            ]

            CustomBT {
                id: handleTL
                z: 2
                x: -width / 2
                y: -height / 2

                onPositionChanged: (start_pos, target_pos) => {
                    const rect_tl = rect.mapToItem(rect.parent, 0, 0)
                    const rect_tr = rect.mapToItem(rect.parent, rect.width, 0)
                    const rect_br = rect.mapToItem(rect.parent, rect.width, rect.height)
                    const rect_scaled_width = Math.hypot(Math.abs(rect_tl.x - rect_tr.x), Math.abs(rect_tl.y - rect_tr.y))
                    const rect_scaled_height = Math.hypot(Math.abs(rect_tr.x - rect_br.x), Math.abs(rect_tr.y - rect_br.y))

                    const pos = mapToItem(rect, target_pos.x, target_pos.y)

                    let new_x_scale = (rect_scaled_width - (pos.x - start_pos.x)) / rect_scaled_width
                    let new_y_scale = (rect_scaled_height - (pos.y - start_pos.y)) / rect_scaled_height

                    rect.x_scale = rect.x_scale * new_x_scale
                    rect.y_scale = rect.y_scale * new_y_scale
                    updateScale(0)
                }
            }

            CustomBT {
                id: handleTR
                z: 2
                x: rect.width - width / 2
                y: -height / 2

                onPositionChanged: (start_pos, target_pos) => {
                    const rect_tl = rect.mapToItem(rect.parent, 0, 0)
                    const rect_tr = rect.mapToItem(rect.parent, rect.width, 0)
                    const rect_br = rect.mapToItem(rect.parent, rect.width, rect.height)
                    const rect_scaled_width = Math.hypot(Math.abs(rect_tl.x - rect_tr.x), Math.abs(rect_tl.y - rect_tr.y))
                    const rect_scaled_height = Math.hypot(Math.abs(rect_tr.x - rect_br.x), Math.abs(rect_tr.y - rect_br.y))

                    const pos = mapToItem(rect, target_pos.x, target_pos.y)

                    let new_x_scale = (rect_scaled_width + (pos.x - start_pos.x)) / rect_scaled_width
                    let new_y_scale = (rect_scaled_height - (pos.y - start_pos.y)) / rect_scaled_height

                    rect.x_scale = rect.x_scale * new_x_scale
                    rect.y_scale = rect.y_scale * new_y_scale
                    updateScale(1)
                }
            }


            CustomBT {
                id: handleBR
                z: 2
                x: rect.width - width / 2
                y: rect.height - height / 2

                onPositionChanged: (start_pos, target_pos) => {
                    const rect_tl = rect.mapToItem(rect.parent, 0, 0)
                    const rect_tr = rect.mapToItem(rect.parent, rect.width, 0)
                    const rect_br = rect.mapToItem(rect.parent, rect.width, rect.height)
                    const rect_scaled_width = Math.hypot(Math.abs(rect_tl.x - rect_tr.x), Math.abs(rect_tl.y - rect_tr.y))
                    const rect_scaled_height = Math.hypot(Math.abs(rect_tr.x - rect_br.x), Math.abs(rect_tr.y - rect_br.y))

                    const pos = mapToItem(rect, target_pos.x, target_pos.y)

                    let new_x_scale = (rect_scaled_width + (pos.x - start_pos.x)) / rect_scaled_width
                    let new_y_scale = (rect_scaled_height + (pos.y - start_pos.y)) / rect_scaled_height

                    rect.x_scale = rect.x_scale * new_x_scale
                    rect.y_scale = rect.y_scale * new_y_scale
                    updateScale(2)
                }
            }

            CustomBT {
                id: handleBL
                z: 2
                x: - width / 2
                y: rect.height - height / 2

                onPositionChanged: (start_pos, target_pos) => {
                    const rect_tl = rect.mapToItem(rect.parent, 0, 0)
                    const rect_tr = rect.mapToItem(rect.parent, rect.width, 0)
                    const rect_br = rect.mapToItem(rect.parent, rect.width, rect.height)
                    const rect_scaled_width = Math.hypot(Math.abs(rect_tl.x - rect_tr.x), Math.abs(rect_tl.y - rect_tr.y))
                    const rect_scaled_height = Math.hypot(Math.abs(rect_tr.x - rect_br.x), Math.abs(rect_tr.y - rect_br.y))

                    const pos = mapToItem(rect, target_pos.x, target_pos.y)

                    let new_x_scale = (rect_scaled_width - (pos.x - start_pos.x)) / rect_scaled_width
                    let new_y_scale = (rect_scaled_height + (pos.y - start_pos.y)) / rect_scaled_height

                    rect.x_scale = rect.x_scale * new_x_scale
                    rect.y_scale = rect.y_scale * new_y_scale
                    updateScale(3)
                }
            }

            Rectangle {
                id: handleRotate
                width: 16
                height: 16
                radius: 8
                color: "green"
                border.color: "black"
                z: 10

                x: rect.width / 2 - width / 2
                y: rect.height / 2 - height / 2

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        rect.rotation_angle = (rect.rotation_angle + 10) % 360
                        updateRotation()
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "⟳"
                    font.pixelSize: 12
                    color: "white"
                }
            }
        }
    }

    function updateRotation() {
        let m = Qt.matrix4x4()
        let pos = Qt.vector3d(rootMatrixTransform.matrix.column(3).x, rootMatrixTransform.matrix.column(3).y, rootMatrixTransform.matrix.column(3).z)
        let angle = rect.rotation_angle

        let rect_cent = rect.mapToItem(rect.parent, rect.width / 2, rect.height / 2)
        let pivotRotate = Qt.vector3d(rect_cent.x, rect_cent.y, 0)
        m.translate(pos)
        m.rotate(angle - 10, Qt.vector3d(0, 0, 1))

        m.translate(pivotRotate)
        m.rotate(10, Qt.vector3d(0, 0, 1))
        m.translate(Qt.vector3d(-pivotRotate.x, -pivotRotate.y, 0))

        rootMatrixTransform.matrix = m
    }

    function updateScale(idx) {
        let m = Qt.matrix4x4()

        let sx = rect.x_scale
        let sy = rect.y_scale

        let pivotScale = Qt.vector3d(0, 0, 0)

        let tl = rect.mapToItem(rect.parent, 0, 0)
        let br = rect.mapToItem(rect.parent, rect.width, rect.height)

        if (idx === 0) {
            m.translate(Qt.vector3d(br.x - rect.width, br.y - rect.height, 0))
            pivotScale = Qt.vector3d(rect.width, rect.height, 0)
        } else if (idx === 1) {
            m.translate(Qt.vector3d(tl.x, br.y - rect.height, 0))
            pivotScale = Qt.vector3d(0, rect.height, 0)
        } else if (idx === 2) {
            m.translate(Qt.vector3d(tl.x, tl.y, 0))
            pivotScale = Qt.vector3d(0, 0, 0)
        } else if (idx === 3) {
            m.translate(Qt.vector3d(br.x - rect.width, tl.y, 0))
            pivotScale = Qt.vector3d(rect.width, 0, 0)
        }

        m.translate(pivotScale)
        m.scale(sx, sy, 1)
        m.translate(Qt.vector3d(-pivotScale.x, -pivotScale.y, 0))
        matrixTransform.matrix = m
    }


    component CustomBT: Rectangle {
        id: __custom_bt

        signal positionChanged(point start_pos, point target_pos)

        width: 14
        height: 14
        radius: 7
        color: "red"
        border.color: "black"

        MouseArea {
            anchors.fill: parent
            property point startMousePos

            onPressed: { this.startMousePos = mapToItem(rect, mouseX, mouseY)}
            onPositionChanged: { __custom_bt.positionChanged(this.startMousePos, Qt.point(mouseX, mouseY)); }
        }
    }
}