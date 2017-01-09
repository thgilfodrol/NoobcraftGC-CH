proc _announcer_get_broadcasts(){
    @bd = array();
    @bd[] = array(closure(){ broadcast(colorize()); }, 1); # base format: closure containing broadcast or tellraw, followed by weight of broadcast
    @bd[] = array(closure(){ broadcast(colorize('Hello World!')); }, 1);

}
