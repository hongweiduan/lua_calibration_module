cal = require("calibration")
require "common"
setting_name = "interface"
saveCfgToFile("cal_config",setting_name)
local tab = {1,6,1}
local name_str = "cal"
cal_coeff_address = '0x01'
cal.check_with_head(tab,name_str)
-- cal.check_with_head()

-- setting_name = "interface.interface_2"
-- saveCfgToFile("cal_config",setting_name)
-- cal.check_with_head('check')