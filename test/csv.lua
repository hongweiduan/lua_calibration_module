
function split(str, reps)  
    local resultStrsList = {};  
    string.gsub(str, '[^' .. reps ..']+', function(w) table.insert(resultStrsList, w) end );  
    return resultStrsList;  
end  
  
--一行一行取用数据  
local function getRowContent(file)  
    local content;  
    local check = false  
    local count = 0  
    while true do  
        local t = file:read()  
        if not t then  
            if count == 0 then  
                check = true  
            end  
        break  
    end  
  
    if not content then  
        content = t  
    else  
        content = content..t  
    end  
  
    local i = 1  
    while true do    
        local index = string.find(t, "\"", i)    
        if not index then break end    
            i = index + 1    
            count = count + 1    
        end    
  
        if count % 2 == 0 then   
            check = true   
            break   
        end    
    end    
  
    if not check then    
        assert(1~=1)   
    end  
    --返回去掉空格的一行数据,还有方法没看明白，以后再修改  
    return content and (string.gsub(content, " ", ""))  
end  
  
function loadCsvFile(filePath)  
    -- 读取文件  
    local alls = {}  
    local file = io.open(filePath, "r")  
    while true do  
        local line = getRowContent(file)  
        if not line then  
            break  
        end  
        local line = string.gsub(line,"\r","")
        local line = string.gsub(line,"\n","")
        table.insert(alls, line)  
    end  
    --[[ 从第2行开始保存（第一行是标题，后面的行才是内容） 用二维数组保存：arr[ID][属性标题字符串] ]]  
    -- local titles = split(alls[0], ",")  
    -- local ID = 1  
    local arrs = {}  
    for i = 1, #alls, 1 do  
        -- 一行中，每一列的内容,第一位为ID  
        local content = split(alls[i], ",")  
        -- print(content[1])
        -- ID = tonumber(content[1])  
        --保存ID，以便遍历取用，原来遍历可以使用in pairs来执行，所以这个不需要了  
        --table.insert(arrs, i-1, ID)  
        -- arrs[ID] = {}  
        arrs[i]={}
        -- 以标题作为索引，保存每一列的内容，取值的时候这样取：arrs[1].Title  
        for j = 1, #content, 1 do  
            arrs[i][j] = content[j]  
        end  
    end  
    return arrs  
end 

function transposition_arrs( arrs )
    if type(arrs) ~= "table" or type(arrs[1]) ~= "table"  then error("function: transposition_arrs -->vaule error: accept a 2D array.") end
    row_nb = #arrs
    column = #(arrs[1])
    r_arrs = {}
    for i=1,tonumber(column) do
        r_arrs[i]={}
    end
    for r,row in ipairs(arrs) do
        for c,v in ipairs(row) do
            r_arrs[c][r] = v
        end
    end
    return r_arrs
end