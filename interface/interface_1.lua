require "test.test"

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
--after
-- function get_one_standard_vaule()
-- 	--DO something
-- 	local ret = it_bf_ag()
-- 	return ret
-- end

-- function get_one_target_vaule()
-- 	--DO something
-- 	local ret = it_bf_adc()
-- 	return ret
-- end

function set_step(v)
	--DO something
	return true
end
 
function cal_delay(sm)
	--DO something
	os.execute("sleep "..(sm/1000))
	return true	
end



