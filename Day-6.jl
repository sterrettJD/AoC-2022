file = "Day-6-data.txt"

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

function find_message_start(line)
    for i in 1:length(line)-13
        start = i
        stop = i+13
        # if there are 4 unique characters in our window, 
        # break and return the index
        if length(unique(line[start:stop]))==14
            println("MESSAGE after ", stop)
            return stop
        end
    end
end

for line in readlines(f)
    packet_start = find_packet_start(line)
    message_start = find_message_start(line)
end

close(f)