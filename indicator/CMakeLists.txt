configure_file(ernesst-indicator-upower.py ${CMAKE_CURRENT_BINARY_DIR}/ernesst-indicator-upower.py)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/ernesst-indicator-upower.py DESTINATION ${DATA_DIR}indicator)
install(FILES "ernesst-indicator-upower.conf" DESTINATION ${DATA_DIR}indicator)
install(FILES "install.sh" DESTINATION ${DATA_DIR}indicator)
install(FILES "com.ernesst.indicator.upower" DESTINATION ${DATA_DIR}indicator)
install(FILES "uninstall.sh" DESTINATION ${DATA_DIR}indicator)
