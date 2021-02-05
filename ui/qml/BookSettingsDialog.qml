/* Copyright 2021 Emanuele Sorce - emanuele.sorce@hotmail.com
 *
 * This file is part of Beru and is distributed under the terms of
 * the GPL. See the file COPYING for full details.
 * 
 * This file is part of Sturm Reader and is distributed under the terms of
 * the GPL. See the file COPYING for full details.
 */

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Dialog {
	id: stylesDialog
	property real labelwidth: width * 0.3
	visible: false
	
	x: Math.round((bookPage.width - width) / 2)
	y: Math.round((bookPage.height - height) / 2)
	width: Math.min(bookPage.width, Math.max(bookPage.width * 0.5, scaling.dp(450)))
	height: Math.min(bookPage.height*0.9, stylesFlickable.contentHeight + stylesToolbar.height + scaling.dp(50))
	
	modal: true
	
	header: ToolBar {
		id: stylesToolbar
		width: parent.width
		RowLayout {
			anchors.fill: parent
			Label {
				text: gettext.tr("Book Settings")
				font.pixelSize: headerTextSize()
				elide: Label.ElideRight
				horizontalAlignment: Qt.AlignHCenter
				verticalAlignment: Qt.AlignVCenter
				Layout.fillWidth: true
			}
			
			BusyIndicator {
				width: height
				height: scaling.dp(25)
				Layout.rightMargin: scaling.dp(0)
				opacity: loadingIndicator.opacity
				running: opacity != 0
			}
		}
	}
	
	Flickable {
		id: stylesFlickable
		
		clip: true
		boundsBehavior: Flickable.OvershootBounds
		
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		width: parent.width
		contentWidth: parent.width
		contentHeight: settingsColumn.height
		
		ScrollBar.vertical: ScrollBar { }
		
		Column {
			id: settingsColumn
			width: parent.width
			anchors.centerIn: parent.center
			
			spacing: scaling.dp(20)
			
			// This background is specific to comicBooks
			Row {
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width * 0.9
				visible: pictureBook
				
				Label {
					/*/ Prefer string of < 16 characters /*/
					text: gettext.tr("Background color")
					verticalAlignment: Text.AlignVCenter
					wrapMode: Text.Wrap
					width: stylesDialog.labelwidth
					height: fontSelector.height
				}
				
				ComboBox {
					id: comicColorSelector
					displayText: comicStyleModel.get(currentIndex).stext
					width: parent.width - stylesDialog.labelwidth
					model: ListModel {
						id: comicStyleModel
						ListElement {
							stext: "White"
							back: "white"
							comboboxback: "white"
							comboboxfore: "black"
						}
						ListElement {
							stext: "Light"
							back: "url(.background_paper@30.png)"
							comboboxback: "#dddddd"
							comboboxfore: "#222222"
						}
						ListElement {
							stext: "Dark"
							back: "url(.background_paper_invert@30.png)"
							comboboxback: "#222222"
							comboboxfore: "#dddddd"
						}
						ListElement {
							stext: "Black"
							back: "black"
							comboboxback: "black"
							comboboxfore: "white"
						}
					}
					onCurrentIndexChanged: {
						bookStyles.pdfBackground = styleModel.get(currentIndex).back
					}
					delegate: ItemDelegate {
						highlighted: colorSelector.highlightedIndex === index
						width: parent.width
						contentItem: Label {
							text: stext
							color: comboboxfore
						}
						background: Rectangle {
							color: comboboxback
						}
					}
				}
			}
			
			Row {
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width * 0.9
				visible: !pictureBook
				
				Label {
					/*/ Prefer string of < 16 characters /*/
					text: gettext.tr("Color scheme")
					verticalAlignment: Text.AlignVCenter
					wrapMode: Text.Wrap
					width: stylesDialog.labelwidth
					height: fontSelector.height
				}
				
				ComboBox {
					id: colorSelector
					displayText: styleModel.get(currentIndex).stext
					width: parent.width - stylesDialog.labelwidth
					model: ListModel {
						id: styleModel
						ListElement {
							stext: "Black on White"
							back: "white"
							fore: "black"
							comboboxback: "white"
							comboboxfore: "black"
						}
						ListElement {
							stext: "Dark on Texture"
							back: "url(.background_paper@30.png)"
							fore: "#222"
							comboboxback: "#dddddd"
							comboboxfore: "#222222"
						}
						ListElement {
							stext: "Light on Texture"
							back: "url(.background_paper_invert@30.png)"
							fore: "#999"
							comboboxback: "#222222"
							comboboxfore: "#dddddd"
						}
						ListElement {
							stext: "White on Black"
							back: "black"
							fore: "white"
							comboboxback: "black"
							comboboxfore: "white"
						}
					}
					onCurrentIndexChanged: {
						bookStyles.textColor = styleModel.get(currentIndex).fore
						bookStyles.background = styleModel.get(currentIndex).back
					}
					delegate: ItemDelegate {
						highlighted: colorSelector.highlightedIndex === index
						width: parent.width
						contentItem: Label {
							text: stext
							color: comboboxfore
						}
						background: Rectangle {
							color: comboboxback
						}
					}
				}
			}
			
			Row {
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width * 0.9
				visible: pictureBook
				Label {
					/*/ Prefer string of < 16 characters /*/
					text: gettext.tr("Quality")
					verticalAlignment: Text.AlignVCenter
					wrapMode: Text.Wrap
					width: stylesDialog.labelwidth
					height: qualitySlider.height
				}

				Slider {
					id: qualitySlider
					width: parent.width - stylesDialog.labelwidth
					from: 0.4
					to: 1.6
					stepSize: 0.3
					snapMode: Slider.SnapAlways
					onMoved: bookStyles.pdfQuality = value
				}
			}
			
			Row {
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width * 0.9
				visible: !pictureBook
				
				Label {
					/*/ Prefer string of < 16 characters /*/
					text: gettext.tr("Font")
					verticalAlignment: Text.AlignVCenter
					wrapMode: Text.Wrap
					width: stylesDialog.labelwidth
					height: fontSelector.height
				}
				
				ComboBox {
					id: fontSelector
					onCurrentIndexChanged: bookStyles.fontFamily = model[currentIndex]
					displayText: (model[currentIndex] == "Default") ? gettext.tr("Default Font") : model[currentIndex]
					width: parent.width - stylesDialog.labelwidth
					
					model: fontLister.fontList
					
					delegate: ItemDelegate {
						highlighted: fontSelector.highlightedIndex === index
						width: parent.width
						contentItem: Label {
							verticalAlignment: Text.AlignVCenter
							text: (modelData == "Default") ? gettext.tr("Default Font") : modelData
							font.family: modelData
						}
					}
				}
			}

			Row {
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width * 0.9
				visible: !pictureBook
				Label {
					/*/ Prefer string of < 16 characters /*/
					text: gettext.tr("Font Scaling")
					verticalAlignment: Text.AlignVCenter
					wrapMode: Text.Wrap
					width: stylesDialog.labelwidth
					height: fontScaleSlider.height
				}

				Slider {
					id: fontScaleSlider
					width: parent.width - stylesDialog.labelwidth
					from: 0.5
					to: 4
					stepSize: 0.25
					snapMode: Slider.SnapAlways
					onMoved: bookStyles.fontScale = value
				}
			}

			Row {
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width * 0.9
				visible: !pictureBook
				Label {
					/*/ Prefer string of < 16 characters /*/
					text: gettext.tr("Line Height")
					verticalAlignment: Text.AlignVCenter
					wrapMode: Text.Wrap
					width: stylesDialog.labelwidth
					height: lineHeightSlider.height
				}

				Slider {
					id: lineHeightSlider
					width: parent.width - stylesDialog.labelwidth
					from: 0.8
					to: 2
					stepSize: 0.2
					snapMode: Slider.SnapAlways
					onMoved: bookStyles.lineHeight = value
				}
			}

			Row {
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width * 0.9
				visible: !pictureBook
				Label {
					/*/ Prefer string of < 16 characters /*/
					text: gettext.tr("Margins")
					verticalAlignment: Text.AlignVCenter
					wrapMode: Text.Wrap
					width: stylesDialog.labelwidth
					height: marginSlider.height
				}

				Slider {
					id: marginSlider
					width: parent.width - stylesDialog.labelwidth
					from: 0
					to: 24
					stepSize: 2
					snapMode: Slider.SnapAlways
					function formatValue(v) { return Math.round(v) + "%" }
					onValueChanged: bookStyles.margin = value
				}
			}

			Button {
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width * 0.8
				/*/ Prefer < 16 characters /*/
				text: gettext.tr("Make Default")
				enabled: !bookStyles.atdefault
				onClicked: bookStyles.saveAsDefault()
			}
			Button {
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width * 0.8
				/*/ Prefer < 16 characters /*/
				text: gettext.tr("Load Defaults")
				enabled: !bookStyles.atdefault
				onClicked: bookStyles.resetToDefaults()
			}
			
			Button {
				anchors.horizontalCenter: parent.horizontalCenter
				width: parent.width * 0.8
				text: gettext.tr("Close")
				highlighted: true
				onClicked: stylesDialog.close()
			}
		}
	}
	
	onOpened: {
		if (bookStyles.loading == false)
			setValues()
	}
		
	function setValues() {
		for (var i=0; i<styleModel.count; i++) {
			if (styleModel.get(i).fore == bookStyles.textColor) {
				colorSelector.currentIndex = i
				break
			}
		}
		for (var i=0; i<comicStyleModel.count; i++) {
			if (comicStyleModel.get(i).back == bookStyles.pdfBackground) {
				comicColorSelector.currentIndex = i
				break
			}
		}
		fontSelector.currentIndex = fontSelector.model.indexOf(bookStyles.fontFamily)
		fontScaleSlider.value = bookStyles.fontScale
		lineHeightSlider.value = bookStyles.lineHeight
		marginSlider.value = bookStyles.margin
		qualitySlider.value = bookStyles.pdfQuality
	}
	Component.onCompleted: {
		setValues()
	}
}
