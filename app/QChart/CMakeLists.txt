file(GLOB UI_QML_JS_FILES *.qml *.js)

# Make the files visible in the qtcreator tree
add_custom_target(weight-tracker_QChart_QMlFiles ALL SOURCES ${UI_QML_JS_FILES})

install(FILES ${UI_QML_JS_FILES} DESTINATION ${WEIGHT-TRACKER_DIR}/QChart)
