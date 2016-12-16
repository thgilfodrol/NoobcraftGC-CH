proc _create_nether_portal(@pos1, @pos2){ #expects a standard sized portal, @pos1 is 1 bottom corner and @pos2 is the other bottom corner
    # to anyone who is reading this: forgive me for the crappy code in this procedure
    if(@pos1[3] !== @pos2[3]){ #worlds don't match
        throw('InvalidWorldException', 'InvalidWorldException');
    } else{
        # base and ceiling corners
        set_block_at(@pos1, 49);
        set_block_at(@pos2, 49);
        set_block_at(@pos1[0], @pos1[1] + 4, @pos1[2], 49);
        set_block_at(@pos1[0], @pos1[1] + 4, @pos2[2], 49);
        # wall 1
        set_block_at(@pos1[0], @pos1[1] + 1, @pos1[2], 49);
        set_block_at(@pos1[0], @pos1[1] + 2, @pos1[2], 49);
        set_block_at(@pos1[0], @pos1[1] + 3, @pos1[2], 49);
        # wall 2
        set_block_at(@pos1[0], @pos1[1] + 1, @pos2[2], 49);
        set_block_at(@pos1[0], @pos1[1] + 2, @pos2[2], 49);
        set_block_at(@pos1[0], @pos1[1] + 3, @pos2[2], 49);
        # base and ceiling
        if(@pos1[2] + 3 == @pos2[2]){
            set_block_at(@pos1[0], @pos1[1], @pos1[2] + 1, 49);
            set_block_at(@pos1[0], @pos1[1], @pos1[2] + 2, 49);
            set_block_at(@pos1[0], @pos1[1] + 4, @pos1[2] + 1, 49);
            set_block_at(@pos1[0], @pos1[1] + 4, @pos1[2] + 2, 49);
            set_block_at(@pos1[0], @pos1[1] + 1, @pos1[2] + 1, 51);
            # portal blocks
            set_block_at(@pos1[0], @pos1[1] + 1, @pos1[2] + 1, 90);
            set_block_at(@pos1[0], @pos1[1] + 1, @pos1[2] + 2, 90);
            set_block_at(@pos1[0], @pos1[1] + 2, @pos1[2] + 1, 90);
            set_block_at(@pos1[0], @pos1[1] + 2, @pos1[2] + 2, 90);
            set_block_at(@pos1[0], @pos1[1] + 3, @pos1[2] + 1, 90);
            set_block_at(@pos1[0], @pos1[1] + 3, @pos1[2] + 2, 90);
            set_timeout(500, closure(){
            set_block_at(@pos1[0], @pos1[1] + 1, @pos1[2] + 1, 51);
            });
        } else{
            set_block_at(@pos1[0], @pos1[1], @pos1[2] - 1, 49);
            set_block_at(@pos1[0], @pos1[1], @pos1[2] - 2, 49);
            set_block_at(@pos1[0], @pos1[1] + 4, @pos1[2] - 1, 49);
            set_block_at(@pos1[0], @pos1[1] + 4, @pos1[2] - 2, 49);
            set_block_at(@pos1[0], @pos1[1] + 1, @pos1[2] - 1, 51);
            # portal blocks
            set_block_at(@pos1[0], @pos1[1] + 1, @pos1[2] + 1, 90);
            set_block_at(@pos1[0], @pos1[1] + 1, @pos1[2] + 2, 90);
            set_block_at(@pos1[0], @pos1[1] + 2, @pos1[2] + 1, 90);
            set_block_at(@pos1[0], @pos1[1] + 2, @pos1[2] + 2, 90);
            set_block_at(@pos1[0], @pos1[1] + 3, @pos1[2] + 1, 90);
            set_block_at(@pos1[0], @pos1[1] + 3, @pos1[2] + 2, 90);
            set_timeout(500, closure(){
            set_block_at(@pos1[0], @pos1[1] + 1, @pos1[2] + 1, 51);
            });
        }

    }
}

proc _ndestination_world(@origin){
    if(@origin === 'exploreupdate'){
        return('exploreupdate_nether');
    } else if(@origin === 'exploreupdate_nether'){
        return('exploreupdate');
    }
}

proc _can_have_nether_portal(@world){
    if(@world === 'exploreupdate' || @world === 'exploreupdate_nether'){
        return(true);
    }
    return(false);
}

proc _ndivision_factor(@destination){
    if(@destination === 'exploreupdate'){
        return(0.125);
    } else if(@destination === 'exploreupdate_nether'){
        return(8);
    } else{
        throw('InvalidWorldException', 'InvalidWorldException');
    }
}
