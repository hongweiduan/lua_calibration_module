cal = require("functions.lua_calibration_module.calibration")
-- require "common"
cal_module = {}
setting_name = "functions.lua_calibration_module.interface.interface_dead_time"
function saveCfgToFile(filepath, str)--保存文件
    local file=io.open(filepath,"w")
    file:write(str)
    file:close()
end
saveCfgToFile("/tmp/cal_config",setting_name)
function cal_module.volt_0_1000_test_1( sequence )
    local Curr_Cal_Tab={10,1010,50}
    cal_coeff_address = '0x00'
    local name_str = "cal_test"
    cal.check_with_head(Curr_Cal_Tab,name_str)    
end
return cal_module
-- local name_str = "check"
-- cal.check_with_head(tab,name_str)
-- cal.check_with_head()

-- setting_name = "interface.interface_2"
-- saveCfgToFile("cal_config",setting_name)
-- cal.check_with_head('check')