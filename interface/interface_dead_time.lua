----------------require  list -------------------------------
local arm_com = require(CONFIG.ARM_CONSOLE)     -- arm extension
local keysight_34465a= require(CONFIG.KEYSIGHT_34465A_CONSOLE)
local power_b2902a= require(CONFIG.POWER_2902A_CONSOLE)
local time_utils = require("utils.time_utils")
--------------------------------------------------------------
log_path                                = '/vault/Intelli_Log/CAL_LOG/'
channel_name                            =  'slot_'..tostring(CONFIG.ID+1)
board_name                              = 'Dead_Time_Relay_Board'
board_sn                                =  RL_SN
system_id                               = '021'
station_name                            = 'FCT'
precision_percent                       = 0.0015
precision_deviance                      = 1
k_limit                                 = {0.95,1.05}                   
step_unit                               = 'mV'
meas_unit                               = 'mV'
-----------------------------------------------------
print('-----require the Dead Time Realy Board Calibration interface------')

function cal_delay(sm)
    time_utils.delay(sm)
    return true 
end

function get_one_standard_vaule()
    local ret = keysight_34465a._34465A_Send_Cmd_("MEAS:VOLT:DC?")      --gpib usb
    print("--------------ret-------------"..ret)
    local ret = string.match(tostring(ret),"([+-]?%d+.%d+E[+-]%d+)")
    return ret*1000
end

function get_one_target_vaule()
    local retArm_24ADC = arm_com._ARM_Send_Cmd_("spi adc read(A)")
    local delimt_24ADC = "ACK%s*%((.-)%s*mV"
    local retArm_24ADC = tonumber(string.match(retArm_24ADC,delimt_24ADC))
    return retArm_24ADC
end

function cal_init()
    print("init")
    power_b2902a._Send_Cmd_("OUTPut:STATe 1")
    power_b2902a._Send_Cmd_(":CHAN1:VOLT 0")
end
function cal_end()
    arm_com._ARM_Send_Cmd_("eload cc output(-c,on, 0mA)")
end

function save_coeff(k,r)
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
function read_coeff()
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
function set_step(v)
    power_b2902a._Send_Cmd_(":CHAN1:VOLT " ..tostring(tonumber(v)/1000))
    cal_delay(100)
    return 0
end
 




