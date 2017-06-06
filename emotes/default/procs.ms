# Returns list of emotes and associated data
proc _ncemotes_get_emotes(){
    @emotes = associative_array();
    @emotes['bow'] = array(
        'permnode': 'ncemotes.standard',
        'format': 'bows');
    @emotes['cough'] = array(
        'permnode': 'ncemotes.standard',
        'format': 'coughs');

    return(@emotes);
}
