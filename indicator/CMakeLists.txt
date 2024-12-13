configure_file(ernesst-indicator-upower.py ${CMAKE_CURRENT_BINARY_DIR}/ernesst-indicator-upower.py)
configure_file(number.py ${CMAKE_CURRENT_BINARY_DIR}/number.py)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/ernesst-indicator-upower.py DESTINATION ${DATA_DIR}indicator)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/number.py DESTINATION ${DATA_DIR}indicator)

install(FILES "indicator-upower.service" DESTINATION ${DATA_DIR}indicator)
install(FILES "install.sh" DESTINATION ${DATA_DIR}indicator)
install(FILES "upower.indicator" DESTINATION ${DATA_DIR}indicator)
install(FILES "uninstall.sh" DESTINATION ${DATA_DIR}indicator)
install(FILES "devices.json" DESTINATION ${DATA_DIR}indicator)