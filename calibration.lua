require "common"
require "interface"


local function _cal_and_check(Cal_Tab,factor,offset,calOrCheck)
	local tab_standard = {}
	local tab_target = {}
	get_result = ""
	for step=Cal_Tab[1],Cal_Tab[2],Cal_Tab[3] do
		result = "PASS"
		get_step(step)
		-- print("--->step is :"..step)
		cal_delay(100)

		local v_standard = get_one_standard_vaule()
        local v_target = get_one_target_vaule()
        print("--->v_standard is :"..v_standard.."--->v_target is :"..v_target)
        
        table.insert(tab_standard,v_standard)
        table.insert(tab_target,v_target)

        local diff = (v_target - v_standard)
        local perm = diff/v_standard*1000

    end

    local _k,_b = Linear_Fit(tab_target,tab_standard)
    if _k<0.95 or _k>1.05 then result = "--FAIL--".."fac_k is ".._k end
    return _k,_b

end

-----------
local tab1 = {1,6,1}
k,b = _cal_and_check(tab1,1,0,"cal")
print("kkk is "..k..",bbb is "..b)
-----------


--[[

function cal_module.volt_0_1000_calibration_1(sequence)
	local date2 = os.date("%Y-%m-%d_%H_%M_%S", os.time())
    file_Path="/vault/Intelli_log/"..EL_SN.."_CAL_LOG/DeadTime_cal_test_"..tostring(RL_SN).."_"..tostring(CONFIG.ID).."_"..tostring(date2)..".csv"
    WriteFile_2(file_Path,"calibration dead time 0mV~1000mV\n")
    WriteFile_2(file_Path,"setting Vol,24 ADC Read raw, 24 ADC read for factor:1 and offset:0, Aglient Read,24 ADC Read - Aglient Read, permillage(‰),lower_limit,upper_limit,pass/fail\n\n")
	local Curr_Cal_Tab={1100,10,50} --mV
    power_b2902a._Send_Cmd_("OUTPut:STATe 1")
  	power_b2902a._Send_Cmd_(":CHAN1:VOLT 0")
    local fac_k,fac_r=Measure_By_Agilent_PowerSupply(file_Path,Curr_Cal_Tab,1,0,1,"cal")
    print("------>fac_k"..tostring(fac_k)..",fac_r:"..tostring(fac_r))
    local str=string.format("%.5f",tonumber(fac_k))..","..string.format("%.5f",tonumber(fac_r))
    print("------>k_b_1_str:"..tostring(str))
    WriteStrToARMForRelay(tostring(str),"0x00")
    local log1="\"writecoeff1:"..tostring(str).."\""
    WriteFile_2(file_Path,"0~1000mV :"..log1.."\n")
    if get_result =="FAIL" then
       return false
    else
       return true
    end
end

--]]