package sm4_pkg;

  typedef struct packed {
    logic valid_out;
    logic [127:0] sm4_result;
  } sm4_result_req_t;    

endpackage
