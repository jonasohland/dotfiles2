function dev00
    ssh dev00 -t docker exec -it $argv[1] /bin/bash
end
