---------log_path------
log_path                                = '/vault/Intelli_Log/CAL_L/'
-----common-------
local function Sum_Average(d,d_len)
    local z=0;
    for i=1,d_len do
        z = z + d[i];
    end
    z = z/d_len;
    return z;
end

local function X_Y_By(m,n,d_len)
    local z=0;
    for i=1,d_len do
        z = z + m[i]*n[i];
    end
    return z;
end

local function Squre_sum(c,d_len)
    local z=0;
    for i=1,d_len do
        z = z + c[i]*c[i];
    end
    return z;
end


function Linear_Fit(X,Y)--Y=K*X+R
    -- if #X<2 or #Y<2 then
    --     assert(false,"nil table detected, pls check measure data tab")
    --     return 1.0,0.0
    -- end
    local K=0;               --拟合直线的斜率
    local R=0;               --拟合直线的截距
    local d_len=0
    if #X>=#Y then d_len=#Y
    elseif #X<#Y then d_len=#X
    end
    local x_sum_average= Sum_Average(X,d_len);
    local y_sum_average= Sum_Average(Y,d_len);
    local x_square_sum = Squre_sum(X,d_len);
    local x_multiply_y = X_Y_By(X,Y,d_len);
    K = ( x_multiply_y - d_len * x_sum_average * y_sum_average)/( x_square_sum - d_len * x_sum_average*x_sum_average );
    R = y_sum_average - K * x_sum_average;
    return K,R
end

function saveStrToFile(filepath, str)--保存文件
    local file=io.open(filepath,"a")
    file:write(str)
    file:close()
end

function saveCfgToFile(filepath, str)--保存文件
    local file=io.open(filepath,"w")
    file:write(str)
    file:close()
end
function readStrFromFile(filepath)
    local file=io.open(filepath,"r")
    if(file) then
        str = file:read("*a")
        file:close()
        return str
    else return nil
    end
end

local function tableToStr(aotable, aitable)--table转换为string
    local str = ""
    for i=1, #aotable do
        str = str..string.format("%s,%s\r\n",aotable[i], aitable[i])
    end
    return str
end

------------combine 2 tables--------
local function combine2Tables(table1, table2)--组合两数组
    local tmpTable = table1;
    for i,v in pairs(table2) do
        tmpTable[i] = v
    end
    return tmpTable
end

local function lua_string_split(str, split_char)
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end

    return sub_str_tab;
end

local function sub_table(par,num1,num2)    ----抓取num1到num2的table值，返回table
  local table={};
  local n=1;
  for i=num1,num2  do
    table[n]=par[i] 
    n=n+1
  end
  -- DbgOut(table);
 return table;
end
--------------
calibration_module = {}
function check_path(path)
    f = io.open(path)
    if f == nil then
        os.execute("mkdir -p "..path)
    else
        f:close()
    end
    return true
end

-- check_path(log_path)

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
    saveStrToFile(file_Path,board_name.." "..Cal_Tab[1]..step_unit.."~"..Cal_Tab[2]..step_unit.."factor:,"..string.format("%.5f",_k)..",offset:,"..string.format("%.5f",_b).."\n")
    if _k<k_limit[1] or _k>k_limit[2] then error("Unacceptable factor: calibration factor is ".._k) end
    save_coeff(_k,_b)
    return _k,_b

end


local function _check_(file_Path,Cal_Tab)
    factor,offset = read_coeff()
    saveStrToFile(file_Path,"check "..board_name.." "..Cal_Tab[1]..step_unit.."~"..Cal_Tab[2]..step_unit.."\n")
    saveStrToFile(file_Path,board_name.." "..Cal_Tab[1]..step_unit.."~"..Cal_Tab[2]..step_unit.."factor:,"..factor..",offset:,"..offset.."\n")
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

        local diff = (v_target_cal - v_standard)
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

local function save_log_by_station(name_str)
    local time_stamp = os.date("%Y-%m-%d_%H_%M_%S", os.time())
    local path_by_station_name = log_path..station_name..'_'..system_id..'/'..channel_name..'/'
    check_path(path_by_station_name)
    local csv_by_system_name = path_by_station_name..board_name..'_'..board_sn..'_'..name_str..'_'..time_stamp..'.csv'
    os.execute("touch "..csv_by_system_name)
    return csv_by_system_name
end

local function save_log_by_board_name(name_str)
    local time_stamp = os.date("%Y-%m-%d_%H_%M_%S", os.time())
    local path_by_board_name = log_path..board_name..'/'
    check_path(path_by_board_name)
    local csv_by_board_name = path_by_board_name..board_name..'_'..board_sn..'_'..name_str..'_'..time_stamp..'.csv'
    os.execute("touch "..csv_by_board_name)
    return csv_by_board_name    
end

local function require_config()
    cfg = readStrFromFile('cal_config')
    -- print(cfg)
    require(tostring(cfg))
    check_path(log_path)
end
-----------cal test --------
function calibration_module.cal_with_head(tab,file_name)
    require_config()
    my_log_path = ""
    if boardOrsystem == "board" then
        my_log_path = save_log_by_board_name(file_name)
    else
        my_log_path = save_log_by_station(file_name)
    end
    saveStrToFile(my_log_path,"Setting Step,Board meas raw data,Instrumental mesa data,Board meas after cal - Instrumental meas, permillage(‰),lower_limit,upper_limit,pass/fail\n")
    -- local tab1 = {1,6,1}
    cal_init()
    k,b = _cal_(my_log_path,tab)
    -- print("kkk is "..k..",bbb is "..b)
    return k,b
end

function calibration_module.cal_without_head(tab)
    -- require_config()
    -- if boardOrsystem == "board" then
    --     local my_log_path = save_log_by_board_name(file_name)
    -- else
    --     my_log_path = save_log_by_station(file_name)
    -- end
    -- saveStrToFile(my_log_path,"Setting Step,Board meas raw data,Instrumental mesa data,Board meas after cal - Instrumental meas, permillage(‰),lower_limit,upper_limit,pass/fail\n")
    -- local tab1 = {1,6,1}
    -- cal_init()
    k,b = _cal_(my_log_path,tab)
    -- print("kkk is "..k..",bbb is "..b)
    return k,b
end

-----------check test ---------
function calibration_module.check_with_head(tab,file_name)
    require_config()
    my_log_path = ""
    if boardOrsystem == "board" then
        local my_log_path = save_log_by_board_name(file_name)
    else
        my_log_path = save_log_by_station(file_name) 
    end   
    saveStrToFile(my_log_path,"Setting Step,Board meas raw data,Board meas data after cal,Instrumental mesa data,Board meas after cal - Instrumental meas, permillage(‰),lower_limit,upper_limit,pass/fail\n")
    -- local tab1 = {1,6,1}
    -- saveStrToFile(my_log_path,"calibration "..board_name.." "..tab1[1]..step_unit.."~"..tab1[2]..step_unit.."\n")
    cal_init()
    ret = _check_(my_log_path,tab,k,b)
    print("ret is "..ret)
    return ret
end

function calibration_module.check_without_head()
    -- require_config()
    -- if boardOrsystem == "board" then
    --     local my_log_path = save_log_by_board_name(file_name)
    -- else
    --     my_log_path = save_log_by_station(file_name) 
    -- end   
    -- saveStrToFile(my_log_path,"Setting Step,Board meas raw data,Board meas data after cal,Instrumental mesa data,Board meas after cal - Instrumental meas, permillage(‰),lower_limit,upper_limit,pass/fail\n")
    -- -- local tab1 = {1,6,1}
    -- -- saveStrToFile(my_log_path,"calibration "..board_name.." "..tab1[1]..step_unit.."~"..tab1[2]..step_unit.."\n")
    -- cal_init()
    ret = _check_(my_log_path,tab1,k,b)
    print("ret is "..ret)
    return ret
end

return calibration_module
