register_command('donorprefix', array(
    'description': 'Manage your donor prefix/suffix.',
    'aliases': array('donorsuffix'),
    'usage': colorize('&cThis command has been removed. Please use /ncperks instead.'),
    'permission': 'nc.title.donor1',
    'noPermMsg': colorize('&cInsufficient permissions. You must be at least a tier 1 donor to use this command.'),
    'executor': closure(@alias, @sender, @args) {
        return(false);
    }
));
