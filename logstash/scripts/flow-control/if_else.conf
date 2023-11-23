input {
    stdin { }
}

filter {
    # if [message] Field contains "hello"
    # create a new Field [response] with "hello world"
    if "hello" in [message] {
        mutate {
            add_field => { "response" => "hello world" }
        }
    }
    # otherwise
    # create a new Field [response] with "bye world"
    else {
        mutate {
            add_field => { "response" => "bye world" }
        }
    }
}

output {
    stdout { codec => rubydebug }
}
