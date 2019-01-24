include('../procs.ms');

bind('discord_message_received', array('priority': 'high'), array('channel': 'server'), @event,
    broadcast(concat(colorize(concat('&7{&3D&7} [G] &2', @event['nickname'], '&7: ')), @event['message']));
)

bind('discord_message_received', array('priority': 'high'), array('channel': 'staff'), @event,
    @channels = _ncchat_get_channels();
    @recipients = _ncchat_get_players_with_permission(@channels['Staff']['perm']);

    foreach(@recipient in @recipients) {
        tmsg(@recipient, concat(colorize(concat('&7{&3D&7} &a[S] &2', @event['nickname'], '&a: ')), @event['message']));
    }
)
