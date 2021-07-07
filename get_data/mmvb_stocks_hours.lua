-- Get price data from Quik terminal
IS_RUN = true

STOCK_CODES = {"SBER","GAZP","LKOH","GMKN","ALRS","NLMK","ROSN","RUAL","PLZL","VTBR",
               "YNDX","TATN","FIVE","POLY","CHMF","AFKS","MOEX","NVTK","AFLT","SNGS",
	       "MAGN","OZON","IRAO","SBERP","TCSG","SNGSP","MGNT","MTSS","MAIL","SIBN",
	       "TATNP","PHOR","TRNFP","CBOM","RTKM","HYDR","RASP","POGR","FEES","MVID",
	       "FLOT","DSKY","OGKB","RSTI","UPRO","ENPG","PIKK","BANEP",}

PERIOD = INTERVAL_H1
correct_time = 3 -- Correct time to MSC time.
filename = "E:\\data"  -- Storage folder for all data from quik.
BARS = 2160

function strText(i)
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
        BARS = 2160
        instrument = STOCK_CODES[i]
        out_file = io.open(filename.."\\"..STOCK_CODES[i]..".csv", "w")
        ds = CreateDataSource("TQBR", instrument, PERIOD)
        ds:SetEmptyCallback()

        local Size = ds:Size()
        local x = 0
        if Size == 0 then  -- If the data is not ready then wait in the loop.
            while x < 10 and Size == 0 do
                Size = ds:Size()
                x = x + 1
                -- message('Waiting for '..instrument)
                sleep(250)
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
