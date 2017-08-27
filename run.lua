cal = require("calibration")
require "common"
setting_name = "interface.interface_1"
saveCfgToFile("cal_config",setting_name)
cal.cal_with_head()


setting_name = "interface.interface_2"
saveCfgToFile("cal_config",setting_name)
cal.check_with_head()