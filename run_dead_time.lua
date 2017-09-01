--------------------------调用calibration.lua-------------
cal = require("functions.lua_calibration_module.calibration")
setting_name = "functions.lua_calibration_module.interface.interface_dead_time"
function saveCfgToFile(filepath, str)--保存文件
    local file=io.open(filepath,"w")
    file:write(str)
    file:close()
end
saveCfgToFile("/tmp/cal_config",setting_name)
------------------cal_module-----------------------------
cal_module = {}
---------------calibration.lua的函数------------------
--[[
    check_with_head(cal_tab,name_str) return pass/fail
    check_without_head(cal_tab) return pass/fail
    --------
    cal_tab 用于传入校准分段表格,按照start,end,step的顺序传入
    name_str 用于区分标识产生的log文件
    会返回根据设置精度check的最终结果

    cal_with_head(cal_tab,name_str) return k,b
    cal_without_head(cal_tab) return k,b
    cal_tab 用于传入校准分段表格,按照start,end,step的顺序传入
    name_str 用于区分标识产生的log文件
    会返回校准之后的k,b值

]]--
----------------------------------------------------
----------------------------------------------------

-------用于function_table中直接使用的函数-------
function cal_module.volt_0_1000_test_1( sequence )
    local Curr_Cal_Tab={10,1010,50} --校准分段设置 start,end,step
    local name_str = "check"
    cal_coeff_address = '0x00'  --系数储存开始地址,
    times_for_24ADC = 1 --24位ADC读数需乘的系数.
    return cal.check_with_head(Curr_Cal_Tab,name_str) --校准check函数 
end
function cal_module.volt_1000_3000_test_1( sequence )
    local Curr_Cal_Tab={1000,3000,200}
    local name_str = "check"
    times_for_24ADC = 1
    return cal.check_without_head(Curr_Cal_Tab)    
end
function cal_module.volt_3000_5000_test( sequence )
    local Curr_Cal_Tab={3100,5000,200}
    cal_coeff_address = '0x20'
    times_for_24ADC = 347/47
    return cal.check_without_head(Curr_Cal_Tab)    
end
function cal_module.volt_5000_21000_test( sequence )
    local Curr_Cal_Tab={5000,21000,1000}
    cal_coeff_address = '0x30'
    times_for_24ADC = 347/47
    return cal.check_without_head(Curr_Cal_Tab)    
end
return cal_module