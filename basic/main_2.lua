-- If need to run code in constantly,
-- then inside the main func place infinite loop,
-- but in order to be able to stop the script it is 
-- done like this:

IS_RUN = true

function main()
	while IS_RUN do

		-- HERE YOUR CODE.

		sleep(1);  -- MANDATORY!!! This is a 1 millisecond pause,
		-- otherwise the script will be highly loading the processor.
		-- The consequences: stopping such script, QUIK can emergency
		-- complete its work.
	end
end

function onStop()
	IS_RUN = false
end
-- onStop() calls automatically when user press 'Stop' script button or
-- closes the QUIK;
-- Inside this func you could place your code which will be performed upon
-- completion of the script.
-- In this case on finishing of this script the var IS_RUN is assigned to 'false',
-- after that the while loop inside the main() stops running and the script stops executing.
--
-- IMPORTANT. Do not place in onStop() code that needs more than 5 seconds to complete.
-- onStop() execution time is limited to 5 seconds.
