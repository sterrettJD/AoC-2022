file = "Day-6-test.txt"

f = open(file)


function find_packet_start(line)
    # create a sliding window along the line
    for i in 1:length(line)-3
        start = i
        stop = i+3
        # if there are 4 unique characters in our window, 
        # break and return the index
        if length(unique(line[start:stop]))==4
            println("SIGNAL after ", stop)
            return stop
        end
    end
end

for line in readlines(f)
    packet_start = find_packet_start(line)
end

close(f)