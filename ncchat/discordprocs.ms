# return server id
proc _discord_get_server_id(){
    return('324961595732131840')
}

# return bot token
proc _discord_get_bot_token(){
    @path = '../../../../bottoken.txt'

    return(read(@path))
}
