cal = require("calibration")
require "common"
--[[
setting_name = "interface.interface_1"
saveCfgToFile("cal_config",setting_name)
cal_tab = {1,6,1}
cal.cal_with_head(cal_tab)


setting_name = "interface.interface_2"
saveCfgToFile("cal_config",setting_name)
check_tab = {7,12,1}
cal.cal_without_head(check_tab)
--]]
setting_name = "interface"
saveCfgToFile("cal_config",setting_name)
cal_coeff_address="0x01"
cal_tab = {1,6,1}
cal.cal_with_head(cal_tab)
-- print_name()
