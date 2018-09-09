bind('discord_message_received', array('priority': 'high'), array('channel': 'server'), @event,
    broadcast(concat(colorize(concat('&7{&3D&7} [G] &2', @event['nickname'], '&7: ')), @event['message']))
)
