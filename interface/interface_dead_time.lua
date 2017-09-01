----------------require  list -------------------------------
local arm_com = require(CONFIG.ARM_CONSOLE)     -- arm extension
local keysight_34465a= require(CONFIG.KEYSIGHT_34465A_CONSOLE)
local power_b2902a= require(CONFIG.POWER_2902A_CONSOLE)
local time_utils = require("utils.time_utils")
----------------config   list ----------------------------------------
log_path                                = '/vault/Intelli_Log/CAL_LOG/'
channel_name                            =  'slot_'..tostring(CONFIG.ID+1)
board_name                              = 'Dead_Time_Relay_Board'
boardOrsystem                           = 'system'
board_sn                                =  RL_SN
system_id                               = '021'
station_name                            = 'FCT'
precision_percent                       = 0.0015
precision_deviance                      = 1
k_limit                                 = {0.95,1.05}                   
step_unit                               = 'mV'
meas_unit                               = 'mV'
----------------------interface  functions -------------------------------
print('-----require the Dead Time Realy Board Calibration interface------')
--------------------下列函数会在calibration.lua中调用,修改函数名时请对应修改calibration.lua的函数----------------
function cal_delay(sm) --用于设置delay 时间单位为ms,暂时未使用到该函数.
    time_utils.delay(sm)
    return true 
end

function get_one_standard_vaule() --用于获得万用表等仪器测试的标准值,通常返回值换算为mV;mA便于csv中的显示.
    local ret = keysight_34465a._34465A_Send_Cmd_("MEAS:VOLT:DC?")      --gpib usb
    local ret = string.match(tostring(ret),"([+-]?%d+.%d+E[+-]%d+)")
    return ret*1000
end

function get_one_target_vaule() --用于获得需要校准的adc等板卡的测试值,通常返回值换算为mV;mA,与万用表参考值单位保持一致.
    local retArm_24ADC = arm_com._ARM_Send_Cmd_("spi adc read(A)")
    local delimt_24ADC = "ACK%s*%((.-)%s*mV"
    if times_for_24ADC ==nil then times_for_24ADC =1 end
    local retArm_24ADC = tonumber(string.match(retArm_24ADC,delimt_24ADC))*times_for_24ADC
    return retArm_24ADC
end

function cal_init() --用于每次校准前的复位动作,通常为设置输出为0等.
    print("init")
    power_b2902a._Send_Cmd_("OUTPut:STATe 1")
    power_b2902a._Send_Cmd_(":CHAN1:VOLT 0")
end
function cal_end() --用于每次校准之后的复位.
    power_b2902a._Send_Cmd_("OUTPut:STATe 0")
    power_b2902a._Send_Cmd_(":CHAN1:VOLT 0")
end

function save_coeff(k,r) --用于保存系数到eeprom中,需要使用全局变量在将run_dead_time中的不同分段的储存地址传入.
    local str =string.format("%.5f",k)..","..string.format("%.5f",r)
    str = string.sub(tostring(str).."0000000000000",0,16)    --len 15 
    print(cal_coeff_address,str)
    local strARM = "eeprom string write(relay,at04,"..cal_coeff_address..",\""..str.."\""..")"
    local ret = arm_com._ARM_Send_Cmd_(strARM)
    time_utils.delay(2000)
    if ret == nil then
        return -1
    elseif string.match(ret,"DONE") then
        return 0
    else return -2 end
    return 0
end
function read_coeff() --用于读取eeprom中的系数,需要使用全局变量在将run_dead_time中的不同分段的储存地址传入.
    local cmd = "eeprom string read(relay,at04,"..cal_coeff_address..",16)"
    local ret= arm_com._ARM_Send_Cmd_(cmd)
    print("----->ret:"..ret)
    local factor,offset=string.match(ret,"ACK%(%\"%s*(%d*%.?%d*)%s*,%s*([+-]?%d*%.?%d*)")
    if(factor==nil) then
        factor=1
    end
    if(offset==nil) then
        offset=0
    end
    return tonumber(factor),tonumber(offset)  
end
function set_step(v) --用于设置校准步长
    power_b2902a._Send_Cmd_(":CHAN1:VOLT " ..tostring(tonumber(v)/1000))
    time_utils.delay(100)
    return 0
end
---------------------------------------------------------------------------------- 




