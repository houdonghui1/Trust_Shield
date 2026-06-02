create_pblock pblock_u_puf
add_cells_to_pblock [get_pblocks pblock_u_puf] [get_cells -quiet [list top_earlgrey/u_puf]]
resize_pblock [get_pblocks pblock_u_puf] -add {CLOCKREGION_X4Y2:CLOCKREGION_X4Y2}

