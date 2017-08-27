require "common"
require "config"
require(interface_name)


function check_path(path)
    f = io.open(path)
    if f == nil then
        os.execute("mkdir -p "..path)
    else
        f:close()
    end
    return true
end

check_path(log_path)

local function _cal_(file_Path,Cal_Tab)
    saveStrToFile(file_Path,"calibration "..board_name.." "..Cal_Tab[1]..step_unit.."~"..Cal_Tab[2]..step_unit.."\n")
    local tab_standard = {}
    local tab_target = {}
    final_result = "PASS"
    for step=Cal_Tab[1],Cal_Tab[2],Cal_Tab[3] do
        result = "PASS"
        set_step(step)
        print("--->step is :"..step)
        cal_delay(100) 

        local v_standard = tonumber(get_one_standard_vaule())
        local v_target = tonumber(get_one_target_vaule())
        print("--->v_standard is :"..v_standard.."--->v_target is :"..v_target)        
        table.insert(tab_standard,v_standard)
        table.insert(tab_target,v_target)

        local diff = (v_target - v_standard)
        local precision = diff/v_standard*1000
        local result_max = v_standard*(1+precision_percent) + precision_deviance
        local result_min = v_standard*(1-precision_percent) - precision_deviance
        if result_max < v_target or result_min > v_target then
            result ="FAIL"
            get_result = result
        end  
        saveStrToFile(file_Path,tostring(step)..","..tostring(v_target)..","..tostring(v_standard)..","..tostring(diff)..","..tostring(precision)..","..result_min..","..result_max..","..tostring(result).."\n")
    end

    local _k,_b = Linear_Fit(tab_target,tab_standard)
    if _k<k_limit[1] or _k>k_limit[2] then result = "--FAIL--".."fac_k is ".._k end
    return _k,_b

end


local function _check_(file_Path,Cal_Tab,factor,offset)
    saveStrToFile(file_Path,"check "..board_name.." "..Cal_Tab[1]..step_unit.."~"..Cal_Tab[2]..step_unit.."\n")
	-- local tab_standard = {}
	-- local tab_target = {}
	get_result = "PASS"
	for step=Cal_Tab[1],Cal_Tab[2],Cal_Tab[3] do
		result = "PASS"
		set_step(step)
		print("--->step is :"..step)
		cal_delay(100)

		local v_standard = get_one_standard_vaule()
        local v_target = get_one_target_vaule()
        local v_target_cal = v_target*factor + offset
        print("--->v_standard is :"..v_standard.."--->v_target is :"..v_target)
        
        -- table.insert(tab_standard,v_standard)
        -- table.insert(tab_target,v_target)

        local diff = (v_target - v_standard)
        local precision = diff/v_standard*1000
        local result_max = v_standard*(1+precision_percent) + precision_deviance
        local result_min = v_standard*(1-precision_percent) - precision_deviance
        if result_max < v_target_cal or result_min > v_target_cal then
            result ="FAIL"
            get_result = result
        end  
        saveStrToFile(file_Path,tostring(step)..","..tostring(v_target)..","..tostring(v_target_cal)..","..tostring(v_standard)..","..tostring(diff)..","..tostring(precision)..","..result_min..","..result_max..","..tostring(result).."\n")
    end

    -- local _k,_b = Linear_Fit(tab_target,tab_standard)
    -- if _k<0.95 or _k>1.05 then result = "--FAIL--".."fac_k is ".._k end
    return get_result
end

function save_log_by_station(log_path,name,sn,station_name,id)
    
end

function save_log_by_board_name(name_str)
    local time_stamp = os.date("%Y-%m-%d_%H_%M_%S", os.time())
    local path_by_board_name = log_path..board_name..'/'
    check_path(path_by_board_name)
    local csv_by_board_name = path_by_board_name..board_name..'_'..board_sn..'_'..name_str..'_'..time_stamp..'.csv'
    os.execute("touch "..csv_by_board_name)
    return csv_by_board_name    
end
-----------cal test --------
 -- local my_log_path = save_log_by_board_name("cal")
-- saveStrToFile(my_log_path,"Setting Step,Board meas raw data,Instrumental mesa data,Board meas after cal - Instrumental meas, permillage(‰),lower_limit,upper_limit,pass/fail\n")
-- local tab1 = {1,6,1}
-- cal_init()
-- k,b = _cal_(my_log_path,tab1,1,0)
-- print("kkk is "..k..",bbb is "..b)

-----------check test ---------

local my_log_path = save_log_by_board_name("check")
saveStrToFile(my_log_path,"Setting Step,Board meas raw data,Board meas data after cal,Instrumental mesa data,Board meas after cal - Instrumental meas, permillage(‰),lower_limit,upper_limit,pass/fail\n")
local tab1 = {1,6,1}
-- saveStrToFile(my_log_path,"calibration "..board_name.." "..tab1[1]..step_unit.."~"..tab1[2]..step_unit.."\n")
cal_init()
_check_(my_log_path,tab1,1.0001,1.02)
-- print("kkk is "..k..",bbb is "..b)

