import sys
import os
import json
import subprocess
import shlex
import logging
import os.path
from os import path
from subprocess import Popen, PIPE
import re
from gi.repository import Gio
from gi.repository import GLib



import gettext
t = gettext.translation('indicator-upower', fallback=True, localedir='/opt/click.ubuntu.com/indicator.upower.ernesst/current/share/locale/')  # TODO don't hardcode this
_ = t.gettext

BUS_NAME = "com.ernesst.indicator.upower"
BUS_OBJECT_PATH = "/com/ernesst/indicator/upower"
BUS_OBJECT_PATH_PHONE = BUS_OBJECT_PATH + "/phone"

logger = logging.getLogger()
handler = logging.StreamHandler()
formatter = logging.Formatter('%(asctime)s %(name)-12s %(levelname)-8s %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(logging.DEBUG)

class UpowerIndicator(object):
    ROOT_ACTION = 'root'
    CURRENT_ACTION = 'open-current-app'
    FORECAST_ACTION = 'open-forecast-app'
    SETTINGS_ACTION = 'settings'
    MAIN_SECTION = 0

    config_file = "/home/phablet/.config/indicator.upower.ernesst/config.json"  # TODO don't hardcode this
    config_file_device = "/opt/click.ubuntu.com/indicator.upower.ernesst/current/indicator/devices.json"  # TODO don't hardcode this
    charging_enabled_FILE = path.exists("/sys/class/power_supply/battery/charging_enabled")
    refresh_sec = 60
    threshold_Charging = 80
    Repeat_Alarm_setting = 0
    Stop_Charging = 0

    def __init__(self, bus):
#        self.get_phone()
        self.bus = bus
        self.action_group = Gio.SimpleActionGroup()
        self.menu = Gio.Menu()
        self.sub_menu = Gio.Menu()
        self.BATT_update = ''
        self.BATT_status = ''
        self.BATT_Volt = ''
        self.BATT_NRJ = ''
        self.BATT_current_print = ''
        self.BATT_current = ''
        self.BATT_temp_print = ''
        self.BATT_Time_Empt_print = ''
        self.BATT_Time_Full_print = ''
        self.BATT_Time_print = ''
        self.phone_current_file = ''
        self.phone_current_unit = ''
        self.Alarm_tobeperformed = 1
        self.device_name = ''
        self.PUSH_Notification = 0
        self.log_charging_message = ''
        self.charging_enabled_FILE = path.exists("/sys/class/power_supply/battery/charging_enabled")
        self.get_config()
        self.get_config_device()
        logger.debug("Repeat notification status: " + str(self.Repeat_Alarm_setting))
        logger.debug("Threshold status: " + str(self.threshold_Charging))
        logger.debug("Refresh timing: " + str(self.refresh_sec))
        logger.debug("Stopping battery charging if threshold reached: " + str(self.Stop_Charging))
        logger.debug("Push notification status: " + str(self.PUSH_Notification))

    def get_config(self):
        with open(self.config_file) as f:
            config_json = {}
            try:
                config_json = json.load(f)
            except:
                logger.warning('Failed to load the config file: {}'.format(str(sys.exc_info()[1])))

            if 'refresh_sec' in config_json and config_json['refresh_sec'].strip().isnumeric():
                self.refresh_sec = int(config_json['refresh_sec'].strip())
            if 'threshold_Charging' in config_json and config_json['threshold_Charging'].strip().isnumeric():
                self.threshold_Charging = int(config_json['threshold_Charging'].strip())
            if 'repeat_alarm' in config_json and config_json['repeat_alarm'].strip().isnumeric():
                self.Repeat_Alarm_setting = int(config_json['repeat_alarm'].strip())
            if 'Stop_Charging' in config_json and config_json['Stop_Charging'].strip().isnumeric():
                self.Stop_Charging = int(config_json['Stop_Charging'].strip())
            if 'PUSH_Notification' in config_json and config_json['PUSH_Notification'].strip().isnumeric():
                self.PUSH_Notification = int(config_json['PUSH_Notification'].strip())



    def get_config_device(self):
        ### check for Battery_charging file
        with open(self.config_file) as f:
            config_json = {}
            try:
                config_json = json.load(f)
            except:
                logger.warning('Failed to load the config file: {}'.format(str(sys.exc_info()[1])))
            if self.charging_enabled_FILE is True:
                logger.debug("File charging_enabled found")
                config_json.update({"chargingFILE":"1"})
                with open(self.config_file, "w") as f:
                    json.dump(config_json, f)
                f.close()
            else:
                logger.debug("No file charging_enabled found")
        ### check for device
        with open(self.config_file) as f:
            config_json = {}
            try:
                config_json = json.load(f)
            except:
                logger.warning('Failed to load the config file: {}'.format(str(sys.exc_info()[1])))
            print(config_json)
            if 'device' in config_json and config_json['device'].strip():
                self.device_name = config_json['device'].strip()
                self.read_device_config()
            else:
                if path.exists("/system/build.prop"):
                    build_prop_file = open("/system/build.prop")
                    for line in build_prop_file:
                        if re.search("ro.product.device", line):
           #                 print(line)
                            try:
                                device = line.split("=")[1]
                                device = device.rstrip()
                                self.device_name = device
                                logger.debug("Device found: "+ self.device_name)
                                config_json.update({"device":self.device_name})
                                with open(self.config_file, "w") as f:
                                    json.dump(config_json, f)
                                self.read_device_config()
                                f.close()

                            except:
                                logger.warning('Failed to read device name: {}'.format(str(sys.exc_info()[1])))

    def read_device_config(self):
        with open(self.config_file_device) as f:
            config_json_device = {}
            try:
                config_json_device = json.load(f)
                self.phone_current_file = config_json_device[self.device_name]["src"]
                self.phone_current_unit = config_json_device[self.device_name]["current_units"]
#                print(config_json_device)
                if self.phone_current_file != '':
                    logger.debug("Battery current information file found: " + self.phone_current_file)
                else:
                    logger.debug("No Battery current information file found")
                logger.debug("Battery current units found: " + self.phone_current_unit)
            except:
                logger.warning('Failed to load the device config file: {}'.format(str(sys.exc_info()[1])))



    def settings_action_activated(self, action, data):
        logger.debug('settings_action_activated')
        # For some reason ubuntu-app-launch hangs without the version, so let cmake set it for us
        subprocess.Popen(shlex.split('ubuntu-app-launch indicator.upower.ernesst_indicator-upower_0.1'))

    def _battery_action(self):
    ## Define a buffer to reinitialize notification status
        if self.Repeat_Alarm_setting != 1 and self.BATT_Per < 0.8 * self.threshold_Charging :
            self.Alarm_tobeperformed = 1

    ## Push PUSH_Notification
        if self.PUSH_Notification == 1 and self.BATT_Per >= self.threshold_Charging and self.BATT_status == "charging" and self.Alarm_tobeperformed == 1 :
            json_bat = "\'\"{\\\"message\\\": \\\"foobar\\\", \\\"notification\\\":{\\\"card\\\": {\\\"summary\\\": \\\"" + self.BATT_Per_print + "\\\", \\\"body\\\": \\\"" + "Please disconnect your charger" + "\\\", \\\"popup\\\": true, \\\"persist\\\": true}, \\\"sound\\\": true, \\\"vibrate\\\": {\\\"pattern\\\": [200, 100], \\\"duration\\\": 200,\\\"repeat\\\": 2 }}}\"\'"
            subprocess.Popen("/usr/bin/gdbus call --session --dest com.ubuntu.Postal --object-path /com/ubuntu/Postal/indicator_2eupower_2eernesst --method com.ubuntu.Postal.Post indicator.upower.ernesst_indicator-upower " +  json_bat, shell=True)
            logger.debug("Notification sent for" + self.BATT_Per_print)
            self.Alarm_tobeperformed = 0

    ## Stop charging
        if self.Stop_Charging == 1 and self.charging_enabled_FILE == 1 and self.BATT_Per >= self.threshold_Charging and self.BATT_status == "charging":
            subprocess.Popen("echo \"0\" > /sys/class/power_supply/battery/charging_enabled", shell=True)
            logger.debug("Battery threshold " + str(self.threshold_Charging) + "% reached, stop charging, will be re-enable @ " + str(0.9 * self.threshold_Charging) + "%")
            self.log_charging_message = 1

    ## Restart charging
        if self.BATT_Per < 0.9 * self.threshold_Charging and self.charging_enabled_FILE == 1 and self.log_charging_message == 1:
            subprocess.Popen("echo \"1\" > /sys/class/power_supply/battery/charging_enabled", shell=True)
            logger.debug("Charging authorized")
            self.log_charging_message = 0

    ## Repeat alarm, set 1 to Alarm_tobeperformed trigger
        if self.Repeat_Alarm_setting == 1 :
            self.Alarm_tobeperformed = 1





    def _setup_actions(self):
        root_action = Gio.SimpleAction.new_stateful(self.ROOT_ACTION, None, self.root_state())
        self.action_group.insert(root_action)


        settings_action = Gio.SimpleAction.new(self.SETTINGS_ACTION, None)
        settings_action.connect('activate', self.settings_action_activated)
        self.action_group.insert(settings_action)

    def _create_section(self):
        BATT_info_list = []
        BATT_info_list = self.battery_query()
        #print(BATT_info_list)
        section = Gio.Menu()
        settings_menu_item = Gio.MenuItem.new(_('Upower\'s Battery Information: '))
        section.append_item(settings_menu_item)
        for word in BATT_info_list:
            #print(word)
            settings_menu_item = Gio.MenuItem.new(word)
            section.append_item(settings_menu_item)
        self._battery_action()

#        settings_menu_item = Gio.MenuItem.new(_('Battery Settings'), 'indicator.{}'.format(self.SETTINGS_ACTION))
#        section.append_item(settings_menu_item)
        return section

    def _setup_menu(self):
        self.sub_menu.insert_section(self.MAIN_SECTION, 'Upower', self._create_section())

        root_menu_item = Gio.MenuItem.new('Upower', 'indicator.{}'.format(self.ROOT_ACTION))
        root_menu_item.set_attribute_value('x-canonical-type', GLib.Variant.new_string('com.canonical.indicator.root'))
        root_menu_item.set_submenu(self.sub_menu)
        self.menu.append_item(root_menu_item)

    def _update_menu(self):
        self.sub_menu.remove(self.MAIN_SECTION)
        self.sub_menu.insert_section(self.MAIN_SECTION, 'Upower', self._create_section())
        return True  # Make sure we keep running the timeout


    def run(self):
        self._setup_actions()
        self._setup_menu()


        self.bus.export_action_group(BUS_OBJECT_PATH, self.action_group)
        self.menu_export = self.bus.export_menu_model(BUS_OBJECT_PATH_PHONE, self.menu)

        GLib.timeout_add_seconds(self.refresh_sec, self._update_menu)
        self._update_menu()

    def root_state(self):
        vardict = GLib.VariantDict.new()
        vardict.insert_value('visible', GLib.Variant.new_boolean(True))
        vardict.insert_value('title', GLib.Variant.new_string(_('Upower')))

        #temperature = str(self.current_temperature) + '°'
        #temperature = str(76) + '°'
        #if self.error:
        #    temperature = ''

        #vardict.insert_value('label', GLib.Variant.new_string(temperature))
        icon = Gio.ThemedIcon.new("weather-chance-of-storm")
        #icon = Gio.ThemedIcon.new(unity_battery_plugged)
        vardict.insert_value('icon', icon.serialize())

        return vardict.end()

    def battery_query(self):
        process = Popen(["upower", "-i", "/org/freedesktop/UPower/devices/battery_battery"], shell=False, stdout=PIPE)
        stdout = process.communicate()
        stdout = stdout[0].decode('UTF-8').split("\n")
        BATT_info_list = []
        #print("****")
        for element in stdout:
#        print(element)
            if re.search("voltage:", element):
                self.BATT_Volt = element.split()[1]
                #            print(element.split())
                self.BATT_Volt_print = "Voltage: " + str(self.BATT_Volt) + "V"
         #       print(self.BATT_Volt_print)
            if re.search("energy-rate:", element):
                self.BATT_NRJ = element.split()[1]
                #            print(element.split()[1])
         #       print("Battery NRJ: " + str(self.BATT_NRJ) + "W")
            if re.search("percentage:", element):
                self.BATT_Per = element.split()[1]
                self.BATT_Per = int(self.BATT_Per[:-1])
                self.BATT_Per_print = "Charge: " + str(self.BATT_Per) + "%"
         #       print(self.BATT_Per_print)
            if re.search("temperature", element):
                self.BATT_temp = float(element.split()[1])
                self.BATT_temp_print = "Temperature: " + str(self.BATT_temp) + " C"
         #       print(self.BATT_temp_print)
            if re.search("time to empty", element):
                self.BATT_Time_Empt = element.split("       ")[1]
                self.BATT_Time_Empt_print = "Remaining life time: " + str(self.BATT_Time_Empt)
         #       print(self.BATT_Time_Empt_print)
            if re.search("time to full", element):
                self.BATT_Time_Full = element.split("       ")[1]
                self.BATT_Time_Full_print = "Remaining charging time: " + str(self.BATT_Time_Full)
         #       print(self.BATT_Time_Full_print)
            if re.search("state", element):
                self.BATT_status = element.split()[1]
                self.BATT_status_print = "Status: " + str(self.BATT_status)
         #       print(self.BATT_status_print )
            if re.search("updated", element):
                self.BATT_update = element.split("              ")[1]
         #       print("Update: " + str(self.BATT_update))
            if self.phone_current_file == '':
                if self.BATT_Volt and self.BATT_NRJ:
                    self.BATT_current = round((float(self.BATT_NRJ) / float(self.BATT_Volt))*1000)
            else:
                logger.debug("0 " + str(self.phone_current_file))
                if path.exists(self.phone_current_file):
                    F = open(self.phone_current_file,'r')
                    Current_data = F.read().split()
                    self.BATT_current = Current_data[0]
                    logger.debug("1 " + str(self.BATT_current))
                    F.close()
            if self.BATT_current:
                if self.phone_current_unit == "uA":
                    self.BATT_current = round(float(self.BATT_current) /1000)
                if self.phone_current_unit == "mA":
                    self.BATT_current = round(float(self.BATT_current))
                self.BATT_current_print = "Current: " + str(self.BATT_current) + " mA"
            #print(self.BATT_current_print)

        if self.BATT_status == "charging" :
            if self.BATT_Time_Full_print:
                self.BATT_Time_print = self.BATT_Time_Full_print
        else:
            if self.BATT_Time_Empt_print:
                self.BATT_Time_print = self.BATT_Time_Empt_print
        #print("****")
        process.kill()

        #print(Commande)
        if self.BATT_update:
            BATT_info_list.append(self.BATT_update)
        if self.BATT_status_print:
            BATT_info_list.append(self.BATT_status_print)
        if self.BATT_current_print:
            BATT_info_list.append(self.BATT_current_print)
        if self.BATT_temp_print:
            BATT_info_list.append(self.BATT_temp_print)
        if self.BATT_Per_print:
            BATT_info_list.append(self.BATT_Per_print)
        if self.BATT_Volt_print:
            BATT_info_list.append(self.BATT_Volt_print)
        if self.BATT_Time_print:
            BATT_info_list.append(self.BATT_Time_print)
        #print(BATT_info_list)
        return BATT_info_list

if __name__ == '__main__':
    bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)
    proxy = Gio.DBusProxy.new_sync(bus, 0, None, 'org.freedesktop.DBus', '/org/freedesktop/DBus', 'org.freedesktop.DBus', None)
    result = proxy.RequestName('(su)', BUS_NAME, 0x4)
    if result != 1:
        logger.critical('Error: Bus name is already taken')
        sys.exit(1)

    wi = UpowerIndicator(bus)
    wi.run()
    logger.debug('Upower Indicator startup completed')
    GLib.MainLoop().run()