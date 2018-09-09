include('discordprocs.ms')

# announcement upon recompile
broadcast(colorize('&cA reload of the chat code has reset your current chat channel to Global.'), 'nc.title.semimod');


# connect to discord server
@serverid = _discord_get_server_id()
@bottoken = _discord_get_bot_token()

discord_connect(@bottoken, @serverid)
