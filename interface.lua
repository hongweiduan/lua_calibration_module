require "test.test"
require "common"
----all same----
log_path								= '/vault/Intelli_L/CAL_LOG/'
---different for board----
interface_name 							= 'interface'
board_name								= 'Dead_Time_Relay_Board'
board_sn								= 'IN569EVTDT12345678'

precision_percent						= 0.0015
precision_deviance						= 1
k_limit									= {0.95,1.05}					

step_unit								= 'mV'
meas_unit								= 'mV'

-----------------------------------------------------
print('require the interface')
--before
function get_one_standard_vaule()
	--DO something
	local ret = it_bf_ag()
	return ret
end

function get_one_target_vaule()
	--DO something
	local ret = it_bf_adc()
	return ret
end

function cal_init()
	print("init")
end

-- function get_one_target_vaule()
-- 	--DO something
-- 	local ret = it_bf_adc()
-- 	return ret
-- end
function save_coeff(k,r)
    local str =string.format("%.5f",k)..","..string.format("%.5f",r)
	print(cal_coeff_address,str)
	local factor_path = factor_path..'_'..cal_coeff_address..'.txt'
	saveCfgToFile(factor_path,str)
	return true
end
function read_coeff()
	ret = readStrFromFile(factor_path..'_'..cal_coeff_address..'.txt')
    local k,r=string.match(ret,"(%d*%.?%d*)%s*,%s*([+-]?%d*%.?%d*)")
    return k,r	
end
function set_step(v)
	--DO something
	return true
end
 
function cal_delay(sm)
	--DO something
	os.execute("sleep "..(sm/1000))
	return true	
end



