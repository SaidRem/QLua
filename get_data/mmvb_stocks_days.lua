-- Get price data by days from Quik terminal.

IS_RUN = true

STOCK_CODES = {"SBER","GAZP","LKOH","GMKN","ALRS","NLMK","ROSN","RUAL","PLZL","VTBR",
               "YNDX","TATN","FIVE","POLY","CHMF","AFKS","MOEX","NVTK","AFLT","SNGS",
	       "MAGN","OZON","IRAO","SBERP","TCSG","SNGSP","MGNT","MTSS","MAIL","SIBN",
	       "TATNP","PHOR","TRNFP","CBOM","RTKM","HYDR","RASP","POGR","FEES","MVID",
	       "FLOT","DSKY","OGKB","RSTI","UPRO","ENPG","PIKK","BANEP",}
PERIOD = INTERVAL_D1
correct_time = 3  -- Correct for MSC time.
filename = "E:\\data"  -- Storage folder for all data.
BARS = 250

function strText(i)
    -- Add "0" to the beginnig of the number.
    -- Return str.
    local m = tostring(i)
    local mLen = string.len(i)

    if mLen == 1 then
        res = "0" .. m
    else res = m
    end
    return res
end

function main()
    for i = 1, #STOCK_CODES do
        BARS = 250
        instrument = STOCK_CODES[i]
        out_file = io.open(filename.."\\"..STOCK_CODES[i]..".csv", "w")
        -- out_file_info = io.open(filename.."\\"..STOCK_CODES[i].."_info.csv", "w")
        -- info_table = getSecurityInfo("TQBR", STOCK_CODES[i])
        ds = CreateDataSource("TQBR", instrument, PERIOD)
        ds:SetEmptyCallback()
        -- ds:SetUpdateCallback(NewChartData)

        local Size = ds:Size()
        local x = 0
        if Size == 0 then  -- If data is not ready then wait in the loop.
            while x < 10 and Size == 0 do
                Size = ds:Size()
                x = x + 1
                -- message('Waiting for '..instrument)
                sleep(250)  -- Wait for data.
            end
        end

        if BARS > Size then
            BARS = Size - 1
        end

        for i = Size - BARS, Size, 1 do
            local O = ds:O(i)
            local H = ds:H(i)
            local L = ds:L(i)
            local C = ds:C(i)
            local V = ds:V(i)
            local T = ds:T(i)
            sTime = os.time(T)
            datetime = os.date("!*t", sTime)
                
            out_file:write(instrument..","..tostring(PERIOD)..","..tostring(datetime.year)..tostring(strText(datetime.month))
                           ..tostring(strText(datetime.day))..","..tostring(strText(datetime.hour + correct_time))
                           ..tostring(strText(datetime.min))..tostring(strText(datetime.sec))..","..tostring(O)..","
                           ..tostring(H)..","..tostring(L)..","..tostring(C)..","..tostring(V).."\n")
            out_file:flush()  -- Write data to the file.

        end

        out_file:close()
        ds:Close()
        sleep(20)  -- stop for 0.02 sec
    end

end
