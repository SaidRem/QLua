

IS_RUN = true  -- Flag to support the script
DATA_CODES = {
    {"SiU1", "SPBFUT"},
    {"BRN1", "SPBFUT"},
    {"EDU1", "SPBFUT"},
    {"GDU1", "SPBFUT"},
}

INTERVAL = INTERVAL_M5
time_code = 3  -- MSC time.
save_to = "E:\\Trading"  -- Storage folder for data.
BARS = 100  -- Amount of bars to get from quik.

function add_zero(n)
    local num = tostring(n)
    local num_length = string.len(n)

    if num_len == 1 then
        res = "0" .. num
    else res = num
    end
    return res
end

function main()
    while IS_RUN do
        for i = 1, #DATA_CODES do
            instrument = DATA_CODES[i][1]
            out_file = io.open(save_to.."\\"..DATA_CODES[i][1]..".csv", "w")
            ds = CreateDataSource(DATA_CODES[i][1], instrument, INTERVAL)  -- Create data source.

            local Size = ds:Size()  -- Get total amount of bars in data source.
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
                ostime = os.time(T)
                datetime = os.date("!*t")

                out_file:write(instrument..","..tostring(PERIOD)..","..tostring(datetime.year)..tostring(add_zero(datetime.month))
                               ..tostring(add_zero(datetime.day))..","..tostring(add_zero(datetime.hour + time_code))
                               ..tostring(add_zero(datetime.min))..tostring(add_zero(datetime.sec))..","..tostring(O)..","
                               ..tostring(H)..","..tostring(L)..","..tostring(C)..","..tostring(V).."\n")
                out_file:flush()  -- Write data to the file.
            end

            out_file:close()
            ds:Close()
            sleep(1)
        end
        sleep(60000)  -- stop for 60 seconds.
    end
end

function OnStop()
    IS_RUN = false
end