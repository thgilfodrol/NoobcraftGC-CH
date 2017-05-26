#*****************************************************************************#
# Copyright 2013 Mark Sanders (CyaNox)                                        #
# This work is licensed under a                                               #
# Creative Commons Attribution-ShareAlike 4.0 International License.          #
# http://creativecommons.org/licenses/by-sa/4.0/                              #
#*****************************************************************************#

# The formatting was modified to fit styling with other code in the repository. 
# A copy of the original code can be found at http://paste.thezomg.com/12765/98352721/ .

proc _NBT_read(@filename){
    @ba = read_gzip_binary(@filename);
    ba_rewind(@ba);
    @tree = array();
    _NBT_traverseTag(@ba, @tree);
    return(@tree);
}
 
proc _NBT_traverseTag(@ba, @tree){
    @tagtype = _NBT_readType(@ba, 1);
    if (@tagtype == 0){
        return(false);
    }
    @tree[_NBT_readType(@ba, 8)] = _NBT_readType(@ba, @tagtype);
    return(true);
}
 
proc _NBT_readType(@ba, @type){
    switch(@type){
        case 1:
            return(ba_get_byte(@ba));
        case 2:
            return(ba_get_short(@ba));
        case 3:
            return(ba_get_int(@ba));
        case 4:
            return(ba_get_long(@ba));
        case 5:
            return(ba_get_float(@ba));
        case 6:
            return(ba_get_double(@ba));
        case 7:
            @length = ba_get_int(@ba);
            return(ba_get_bytes(@ba, @length));
        case 8:
            return(ba_get_string(@ba));
        case 9:
            @tagtype = ba_get_byte(@ba);
            @length = ba_get_int(@ba);
            @list = array();
            for(@i = 0, @i < @length, @i++){
                @list[] = _NBT_readType(@ba, @tagtype);
            }
            return(@list);
        case 10:
            @tree = array();
            while(_NBT_traverseTag(@ba, @tree),g());
            return(@tree);
        case 11:
            @length = ba_get_int(@ba);
            @list = array();
            for(@i = 0, @i < @length, @i++){
                @list[] = _NBT_readType(@ba, 3);
            }
            return(@list);
    }
}
