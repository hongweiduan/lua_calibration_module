function get_bit(data,bit)
    if(bit == 0) then
        return math.mod(data,2)
    else
        return math.mod(math.floor((data/math.pow(2,bit))),2)
    end
end

local function Shift(NBits,Data,Flag,SBits)
    local NewData=0;
    if (Flag == "L") then --Left
        NewData = Data*(2^SBits);
    elseif (Flag == "R") then --Right
        NewData = math.floor(Data/(2^SBits));
    else
        assert(false,"Error Command!");
    end
    return NewData;
end

local function  RShift(Data,SBits)
    local NewData=0;
    NewData = math.floor(Data/(2^SBits));
    return NewData;
end

local function  LShift(Data,SBits)
    local NewData=0;
    NewData = Data*(2^SBits);
    return NewData;
end

local function  And(Bits,Data1,Data2)
    local NewData=0;
    local Temp = 2^Bits-1;
    
    if Temp < Data1 then
        assert(false,"Bits num too small!");
    end
    if Temp < Data2 then
        assert(false,"Bits num too small!");
    end
    for i=Bits-1,0,-1 do
        Temp=2^i;
        if Data1>=Temp then 
            Data1=Data1-Temp; 
            if Data2>=Temp then
                Data2=Data2-Temp; 
                NewData=NewData+Temp;
            end
        elseif Data2>=Temp then
            Data2=Data2-Temp;
        end
    end
    return NewData;
end

local function  Or(Bits,Data1,Data2)
    local NewData=0;
    local Flag=false;
    local Temp = 2^Bits-1;
    if Temp < Data1 then
        assert(false,"Bits num too small!");
    end
    if Temp < Data2 then
        assert(false,"Bits num too small!");
    end
    for i=Bits-1,0,-1 do
        Flag=false;
        Temp=2^i;
        if Data1>=Temp then 
            Data1=Data1-Temp; 
            Flag=true;  
        end
        if Data2>=Temp then
            Data2=Data2-Temp; 
            Flag=true;
        end
        if (Flag==true) then
            NewData=NewData+Temp;
        end
    end
    return NewData;
end

local function  Not(Bits,Data)
    local NewData;
    local Temp = 2^Bits-1;
    if Temp>= Data then
        NewData = 2^Bits-1-Data;
    else
        assert(false,"Bits num too small!");
    end
    return NewData;
end







