
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

local function readStrFromFile(filepath)
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

