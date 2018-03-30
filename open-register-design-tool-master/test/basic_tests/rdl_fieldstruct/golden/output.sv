//   Ordt 170915.01 autogenerated file 
//   Input: ./rdl_fieldstruct/test.rdl
//   Parms: ./rdl_fieldstruct/test.parms
//   Date: Fri Sep 15 10:07:49 EDT 2017
//

//
//---------- module foo_jrdl_logic
//
module foo_jrdl_logic
(
  clk,
  reset,
  d2l_areg_0_w,
  d2l_areg_0_we,
  d2l_areg_0_re,
  d2l_areg_1_w,
  d2l_areg_1_we,
  d2l_areg_1_re,
  d2l_blabla_w,
  d2l_blabla_we,
  d2l_blabla_re,
  h2l_areg_0_hier_fs_fs1_fld1_w,
  h2l_areg_0_hier_fs_fs1_fld1_we,
  h2l_areg_0_hier_fs_fs2_fld1_w,
  h2l_areg_0_hier_fs_fs2_fld1_we,
  h2l_areg_0_fs3_fld1_w,
  h2l_areg_0_fs3_fld1_we,
  h2l_areg_1_hier_fs_fs1_fld1_w,
  h2l_areg_1_hier_fs_fs1_fld1_we,
  h2l_areg_1_hier_fs_fs2_fld1_w,
  h2l_areg_1_hier_fs_fs2_fld1_we,
  h2l_areg_1_fs3_fld1_w,
  h2l_areg_1_fs3_fld1_we,
  h2l_blabla_fs1_0_fld1_w,
  h2l_blabla_fs1_0_fld1_we,
  h2l_blabla_fs1_1_fld1_w,
  h2l_blabla_fs1_1_fld1_we,
  h2l_blabla_fs1_2_fld1_w,
  h2l_blabla_fs1_2_fld1_we,
  h2l_blabla_fs3_0_fld1_w,
  h2l_blabla_fs3_0_fld1_we,
  h2l_blabla_fs3_1_fld1_w,
  h2l_blabla_fs3_1_fld1_we,

  l2d_areg_0_r,
  l2d_areg_1_r,
  l2d_blabla_r,
  l2h_areg_0_hier_fs_fs1_fld1_r,
  l2h_areg_0_hier_fs_fs1_fld2_r,
  l2h_areg_0_hier_fs_fld1_r,
  l2h_areg_0_hier_fs_fs2_fld1_r,
  l2h_areg_0_hier_fs_fs2_fld2_r,
  l2h_areg_0_fs3_fld1_r,
  l2h_areg_0_fs3_fld2_r,
  l2h_areg_1_hier_fs_fs1_fld1_r,
  l2h_areg_1_hier_fs_fs1_fld2_r,
  l2h_areg_1_hier_fs_fld1_r,
  l2h_areg_1_hier_fs_fs2_fld1_r,
  l2h_areg_1_hier_fs_fs2_fld2_r,
  l2h_areg_1_fs3_fld1_r,
  l2h_areg_1_fs3_fld2_r,
  l2h_blabla_fs1_0_fld1_r,
  l2h_blabla_fs1_0_fld2_r,
  l2h_blabla_fs1_1_fld1_r,
  l2h_blabla_fs1_1_fld2_r,
  l2h_blabla_fs1_2_fld1_r,
  l2h_blabla_fs1_2_fld2_r,
  l2h_blabla_fs3_0_fld1_r,
  l2h_blabla_fs3_0_fld2_r,
  l2h_blabla_fs3_1_fld1_r,
  l2h_blabla_fs3_1_fld2_r );

  //------- inputs
  input    clk;
  input    reset;
  input     [31:0] d2l_areg_0_w;
  input    d2l_areg_0_we;
  input    d2l_areg_0_re;
  input     [31:0] d2l_areg_1_w;
  input    d2l_areg_1_we;
  input    d2l_areg_1_re;
  input     [31:0] d2l_blabla_w;
  input    d2l_blabla_we;
  input    d2l_blabla_re;
  input     [3:0] h2l_areg_0_hier_fs_fs1_fld1_w;
  input    h2l_areg_0_hier_fs_fs1_fld1_we;
  input     [3:0] h2l_areg_0_hier_fs_fs2_fld1_w;
  input    h2l_areg_0_hier_fs_fs2_fld1_we;
  input     [3:0] h2l_areg_0_fs3_fld1_w;
  input    h2l_areg_0_fs3_fld1_we;
  input     [3:0] h2l_areg_1_hier_fs_fs1_fld1_w;
  input    h2l_areg_1_hier_fs_fs1_fld1_we;
  input     [3:0] h2l_areg_1_hier_fs_fs2_fld1_w;
  input    h2l_areg_1_hier_fs_fs2_fld1_we;
  input     [3:0] h2l_areg_1_fs3_fld1_w;
  input    h2l_areg_1_fs3_fld1_we;
  input     [3:0] h2l_blabla_fs1_0_fld1_w;
  input    h2l_blabla_fs1_0_fld1_we;
  input     [3:0] h2l_blabla_fs1_1_fld1_w;
  input    h2l_blabla_fs1_1_fld1_we;
  input     [3:0] h2l_blabla_fs1_2_fld1_w;
  input    h2l_blabla_fs1_2_fld1_we;
  input     [3:0] h2l_blabla_fs3_0_fld1_w;
  input    h2l_blabla_fs3_0_fld1_we;
  input     [3:0] h2l_blabla_fs3_1_fld1_w;
  input    h2l_blabla_fs3_1_fld1_we;

  //------- outputs
  output     [31:0] l2d_areg_0_r;
  output     [31:0] l2d_areg_1_r;
  output     [31:0] l2d_blabla_r;
  output     [3:0] l2h_areg_0_hier_fs_fs1_fld1_r;
  output    l2h_areg_0_hier_fs_fs1_fld2_r;
  output    l2h_areg_0_hier_fs_fld1_r;
  output     [3:0] l2h_areg_0_hier_fs_fs2_fld1_r;
  output    l2h_areg_0_hier_fs_fs2_fld2_r;
  output     [3:0] l2h_areg_0_fs3_fld1_r;
  output    l2h_areg_0_fs3_fld2_r;
  output     [3:0] l2h_areg_1_hier_fs_fs1_fld1_r;
  output    l2h_areg_1_hier_fs_fs1_fld2_r;
  output    l2h_areg_1_hier_fs_fld1_r;
  output     [3:0] l2h_areg_1_hier_fs_fs2_fld1_r;
  output    l2h_areg_1_hier_fs_fs2_fld2_r;
  output     [3:0] l2h_areg_1_fs3_fld1_r;
  output    l2h_areg_1_fs3_fld2_r;
  output     [3:0] l2h_blabla_fs1_0_fld1_r;
  output    l2h_blabla_fs1_0_fld2_r;
  output     [3:0] l2h_blabla_fs1_1_fld1_r;
  output    l2h_blabla_fs1_1_fld2_r;
  output     [3:0] l2h_blabla_fs1_2_fld1_r;
  output    l2h_blabla_fs1_2_fld2_r;
  output     [3:0] l2h_blabla_fs3_0_fld1_r;
  output    l2h_blabla_fs3_0_fld2_r;
  output     [3:0] l2h_blabla_fs3_1_fld1_r;
  output    l2h_blabla_fs3_1_fld2_r;


  //------- reg defines
  logic   [3:0] rg_areg_0_hier_fs_fs1_fld1;
  logic   [3:0] reg_areg_0_hier_fs_fs1_fld1_next;
  logic   [3:0] l2h_areg_0_hier_fs_fs1_fld1_r;
  logic  rg_areg_0_hier_fs_fs1_fld2;
  logic  reg_areg_0_hier_fs_fs1_fld2_next;
  logic  l2h_areg_0_hier_fs_fs1_fld2_r;
  logic  rg_areg_0_hier_fs_fld1;
  logic  reg_areg_0_hier_fs_fld1_next;
  logic  l2h_areg_0_hier_fs_fld1_r;
  logic   [3:0] rg_areg_0_hier_fs_fs2_fld1;
  logic   [3:0] reg_areg_0_hier_fs_fs2_fld1_next;
  logic   [3:0] l2h_areg_0_hier_fs_fs2_fld1_r;
  logic  rg_areg_0_hier_fs_fs2_fld2;
  logic  reg_areg_0_hier_fs_fs2_fld2_next;
  logic  l2h_areg_0_hier_fs_fs2_fld2_r;
  logic   [3:0] rg_areg_0_fs3_fld1;
  logic   [3:0] reg_areg_0_fs3_fld1_next;
  logic   [3:0] l2h_areg_0_fs3_fld1_r;
  logic  rg_areg_0_fs3_fld2;
  logic  reg_areg_0_fs3_fld2_next;
  logic  l2h_areg_0_fs3_fld2_r;
  logic   [31:0] l2d_areg_0_r;
  logic   [3:0] rg_areg_1_hier_fs_fs1_fld1;
  logic   [3:0] reg_areg_1_hier_fs_fs1_fld1_next;
  logic   [3:0] l2h_areg_1_hier_fs_fs1_fld1_r;
  logic  rg_areg_1_hier_fs_fs1_fld2;
  logic  reg_areg_1_hier_fs_fs1_fld2_next;
  logic  l2h_areg_1_hier_fs_fs1_fld2_r;
  logic  rg_areg_1_hier_fs_fld1;
  logic  reg_areg_1_hier_fs_fld1_next;
  logic  l2h_areg_1_hier_fs_fld1_r;
  logic   [3:0] rg_areg_1_hier_fs_fs2_fld1;
  logic   [3:0] reg_areg_1_hier_fs_fs2_fld1_next;
  logic   [3:0] l2h_areg_1_hier_fs_fs2_fld1_r;
  logic  rg_areg_1_hier_fs_fs2_fld2;
  logic  reg_areg_1_hier_fs_fs2_fld2_next;
  logic  l2h_areg_1_hier_fs_fs2_fld2_r;
  logic   [3:0] rg_areg_1_fs3_fld1;
  logic   [3:0] reg_areg_1_fs3_fld1_next;
  logic   [3:0] l2h_areg_1_fs3_fld1_r;
  logic  rg_areg_1_fs3_fld2;
  logic  reg_areg_1_fs3_fld2_next;
  logic  l2h_areg_1_fs3_fld2_r;
  logic   [31:0] l2d_areg_1_r;
  logic   [3:0] rg_blabla_fs1_0_fld1;
  logic   [3:0] reg_blabla_fs1_0_fld1_next;
  logic   [3:0] l2h_blabla_fs1_0_fld1_r;
  logic  rg_blabla_fs1_0_fld2;
  logic  reg_blabla_fs1_0_fld2_next;
  logic  l2h_blabla_fs1_0_fld2_r;
  logic   [3:0] rg_blabla_fs1_1_fld1;
  logic   [3:0] reg_blabla_fs1_1_fld1_next;
  logic   [3:0] l2h_blabla_fs1_1_fld1_r;
  logic  rg_blabla_fs1_1_fld2;
  logic  reg_blabla_fs1_1_fld2_next;
  logic  l2h_blabla_fs1_1_fld2_r;
  logic   [3:0] rg_blabla_fs1_2_fld1;
  logic   [3:0] reg_blabla_fs1_2_fld1_next;
  logic   [3:0] l2h_blabla_fs1_2_fld1_r;
  logic  rg_blabla_fs1_2_fld2;
  logic  reg_blabla_fs1_2_fld2_next;
  logic  l2h_blabla_fs1_2_fld2_r;
  logic   [3:0] rg_blabla_fs3_0_fld1;
  logic   [3:0] reg_blabla_fs3_0_fld1_next;
  logic   [3:0] l2h_blabla_fs3_0_fld1_r;
  logic  rg_blabla_fs3_0_fld2;
  logic  reg_blabla_fs3_0_fld2_next;
  logic  l2h_blabla_fs3_0_fld2_r;
  logic   [3:0] rg_blabla_fs3_1_fld1;
  logic   [3:0] reg_blabla_fs3_1_fld1_next;
  logic   [3:0] l2h_blabla_fs3_1_fld1_r;
  logic  rg_blabla_fs3_1_fld2;
  logic  reg_blabla_fs3_1_fld2_next;
  logic  l2h_blabla_fs3_1_fld2_r;
  logic   [31:0] l2d_blabla_r;
  
  
  //------- combinatorial assigns for areg_1 (pio read data)
  always_comb begin
    l2d_areg_1_r = 32'b0;
    l2d_areg_1_r [3:0]  = rg_areg_1_hier_fs_fs1_fld1;
    l2d_areg_1_r [4]  = rg_areg_1_hier_fs_fs1_fld2;
    l2d_areg_1_r [5]  = rg_areg_1_hier_fs_fld1;
    l2d_areg_1_r [9:6]  = rg_areg_1_hier_fs_fs2_fld1;
    l2d_areg_1_r [14]  = rg_areg_1_hier_fs_fs2_fld2;
    l2d_areg_1_r [27:24]  = rg_areg_1_fs3_fld1;
    l2d_areg_1_r [28]  = rg_areg_1_fs3_fld2;
  end
  
  //------- combinatorial assigns for blabla (pio read data)
  always_comb begin
    l2d_blabla_r = 32'b0;
    l2d_blabla_r [3:0]  = rg_blabla_fs1_0_fld1;
    l2d_blabla_r [4]  = rg_blabla_fs1_0_fld2;
    l2d_blabla_r [8:5]  = rg_blabla_fs1_1_fld1;
    l2d_blabla_r [9]  = rg_blabla_fs1_1_fld2;
    l2d_blabla_r [13:10]  = rg_blabla_fs1_2_fld1;
    l2d_blabla_r [14]  = rg_blabla_fs1_2_fld2;
    l2d_blabla_r [18:15]  = rg_blabla_fs3_0_fld1;
    l2d_blabla_r [19]  = rg_blabla_fs3_0_fld2;
    l2d_blabla_r [26:23]  = rg_blabla_fs3_1_fld1;
    l2d_blabla_r [27]  = rg_blabla_fs3_1_fld2;
  end
  
  //------- combinatorial assigns for areg_0
  always_comb begin
    reg_areg_0_hier_fs_fs1_fld1_next = rg_areg_0_hier_fs_fs1_fld1;
    l2h_areg_0_hier_fs_fs1_fld1_r = rg_areg_0_hier_fs_fs1_fld1;
    reg_areg_0_hier_fs_fs1_fld2_next = rg_areg_0_hier_fs_fs1_fld2;
    l2h_areg_0_hier_fs_fs1_fld2_r = rg_areg_0_hier_fs_fs1_fld2;
    reg_areg_0_hier_fs_fld1_next = rg_areg_0_hier_fs_fld1;
    l2h_areg_0_hier_fs_fld1_r = rg_areg_0_hier_fs_fld1;
    reg_areg_0_hier_fs_fs2_fld1_next = rg_areg_0_hier_fs_fs2_fld1;
    l2h_areg_0_hier_fs_fs2_fld1_r = rg_areg_0_hier_fs_fs2_fld1;
    reg_areg_0_hier_fs_fs2_fld2_next = rg_areg_0_hier_fs_fs2_fld2;
    l2h_areg_0_hier_fs_fs2_fld2_r = rg_areg_0_hier_fs_fs2_fld2;
    reg_areg_0_fs3_fld1_next = rg_areg_0_fs3_fld1;
    l2h_areg_0_fs3_fld1_r = rg_areg_0_fs3_fld1;
    reg_areg_0_fs3_fld2_next = rg_areg_0_fs3_fld2;
    l2h_areg_0_fs3_fld2_r = rg_areg_0_fs3_fld2;
    if (h2l_areg_0_hier_fs_fs1_fld1_we) reg_areg_0_hier_fs_fs1_fld1_next = h2l_areg_0_hier_fs_fs1_fld1_w;
    if (h2l_areg_0_hier_fs_fs2_fld1_we) reg_areg_0_hier_fs_fs2_fld1_next = h2l_areg_0_hier_fs_fs2_fld1_w;
    if (h2l_areg_0_fs3_fld1_we) reg_areg_0_fs3_fld1_next = h2l_areg_0_fs3_fld1_w;
    if (d2l_areg_0_we) reg_areg_0_hier_fs_fs1_fld1_next = d2l_areg_0_w [3:0] ;
    if (d2l_areg_0_we) reg_areg_0_hier_fs_fs1_fld2_next = d2l_areg_0_w [4] ;
    if (d2l_areg_0_we) reg_areg_0_hier_fs_fld1_next = d2l_areg_0_w [5] ;
    if (d2l_areg_0_we) reg_areg_0_hier_fs_fs2_fld1_next = d2l_areg_0_w [9:6] ;
    if (d2l_areg_0_we) reg_areg_0_hier_fs_fs2_fld2_next = d2l_areg_0_w [14] ;
    if (d2l_areg_0_we) reg_areg_0_fs3_fld1_next = d2l_areg_0_w [27:24] ;
    if (d2l_areg_0_we) reg_areg_0_fs3_fld2_next = d2l_areg_0_w [28] ;
  end
  
  //------- reg assigns for areg_0
  always_ff @ (posedge clk) begin
    if (reset) begin
      rg_areg_0_hier_fs_fs1_fld1 <= #1 4'd0;
      rg_areg_0_hier_fs_fs2_fld1 <= #1 4'd0;
      rg_areg_0_fs3_fld1 <= #1 4'd0;
    end
    else begin
      rg_areg_0_hier_fs_fs1_fld1 <= #1  reg_areg_0_hier_fs_fs1_fld1_next;
      rg_areg_0_hier_fs_fs1_fld2 <= #1  reg_areg_0_hier_fs_fs1_fld2_next;
      rg_areg_0_hier_fs_fld1 <= #1  reg_areg_0_hier_fs_fld1_next;
      rg_areg_0_hier_fs_fs2_fld1 <= #1  reg_areg_0_hier_fs_fs2_fld1_next;
      rg_areg_0_hier_fs_fs2_fld2 <= #1  reg_areg_0_hier_fs_fs2_fld2_next;
      rg_areg_0_fs3_fld1 <= #1  reg_areg_0_fs3_fld1_next;
      rg_areg_0_fs3_fld2 <= #1  reg_areg_0_fs3_fld2_next;
    end
  end
  
  //------- combinatorial assigns for areg_0 (pio read data)
  always_comb begin
    l2d_areg_0_r = 32'b0;
    l2d_areg_0_r [3:0]  = rg_areg_0_hier_fs_fs1_fld1;
    l2d_areg_0_r [4]  = rg_areg_0_hier_fs_fs1_fld2;
    l2d_areg_0_r [5]  = rg_areg_0_hier_fs_fld1;
    l2d_areg_0_r [9:6]  = rg_areg_0_hier_fs_fs2_fld1;
    l2d_areg_0_r [14]  = rg_areg_0_hier_fs_fs2_fld2;
    l2d_areg_0_r [27:24]  = rg_areg_0_fs3_fld1;
    l2d_areg_0_r [28]  = rg_areg_0_fs3_fld2;
  end
  
  //------- combinatorial assigns for areg_1
  always_comb begin
    reg_areg_1_hier_fs_fs1_fld1_next = rg_areg_1_hier_fs_fs1_fld1;
    l2h_areg_1_hier_fs_fs1_fld1_r = rg_areg_1_hier_fs_fs1_fld1;
    reg_areg_1_hier_fs_fs1_fld2_next = rg_areg_1_hier_fs_fs1_fld2;
    l2h_areg_1_hier_fs_fs1_fld2_r = rg_areg_1_hier_fs_fs1_fld2;
    reg_areg_1_hier_fs_fld1_next = rg_areg_1_hier_fs_fld1;
    l2h_areg_1_hier_fs_fld1_r = rg_areg_1_hier_fs_fld1;
    reg_areg_1_hier_fs_fs2_fld1_next = rg_areg_1_hier_fs_fs2_fld1;
    l2h_areg_1_hier_fs_fs2_fld1_r = rg_areg_1_hier_fs_fs2_fld1;
    reg_areg_1_hier_fs_fs2_fld2_next = rg_areg_1_hier_fs_fs2_fld2;
    l2h_areg_1_hier_fs_fs2_fld2_r = rg_areg_1_hier_fs_fs2_fld2;
    reg_areg_1_fs3_fld1_next = rg_areg_1_fs3_fld1;
    l2h_areg_1_fs3_fld1_r = rg_areg_1_fs3_fld1;
    reg_areg_1_fs3_fld2_next = rg_areg_1_fs3_fld2;
    l2h_areg_1_fs3_fld2_r = rg_areg_1_fs3_fld2;
    if (h2l_areg_1_hier_fs_fs1_fld1_we) reg_areg_1_hier_fs_fs1_fld1_next = h2l_areg_1_hier_fs_fs1_fld1_w;
    if (h2l_areg_1_hier_fs_fs2_fld1_we) reg_areg_1_hier_fs_fs2_fld1_next = h2l_areg_1_hier_fs_fs2_fld1_w;
    if (h2l_areg_1_fs3_fld1_we) reg_areg_1_fs3_fld1_next = h2l_areg_1_fs3_fld1_w;
    if (d2l_areg_1_we) reg_areg_1_hier_fs_fs1_fld1_next = d2l_areg_1_w [3:0] ;
    if (d2l_areg_1_we) reg_areg_1_hier_fs_fs1_fld2_next = d2l_areg_1_w [4] ;
    if (d2l_areg_1_we) reg_areg_1_hier_fs_fld1_next = d2l_areg_1_w [5] ;
    if (d2l_areg_1_we) reg_areg_1_hier_fs_fs2_fld1_next = d2l_areg_1_w [9:6] ;
    if (d2l_areg_1_we) reg_areg_1_hier_fs_fs2_fld2_next = d2l_areg_1_w [14] ;
    if (d2l_areg_1_we) reg_areg_1_fs3_fld1_next = d2l_areg_1_w [27:24] ;
    if (d2l_areg_1_we) reg_areg_1_fs3_fld2_next = d2l_areg_1_w [28] ;
  end
  
  //------- reg assigns for areg_1
  always_ff @ (posedge clk) begin
    if (reset) begin
      rg_areg_1_hier_fs_fs1_fld1 <= #1 4'd0;
      rg_areg_1_hier_fs_fs2_fld1 <= #1 4'd0;
      rg_areg_1_fs3_fld1 <= #1 4'd0;
    end
    else begin
      rg_areg_1_hier_fs_fs1_fld1 <= #1  reg_areg_1_hier_fs_fs1_fld1_next;
      rg_areg_1_hier_fs_fs1_fld2 <= #1  reg_areg_1_hier_fs_fs1_fld2_next;
      rg_areg_1_hier_fs_fld1 <= #1  reg_areg_1_hier_fs_fld1_next;
      rg_areg_1_hier_fs_fs2_fld1 <= #1  reg_areg_1_hier_fs_fs2_fld1_next;
      rg_areg_1_hier_fs_fs2_fld2 <= #1  reg_areg_1_hier_fs_fs2_fld2_next;
      rg_areg_1_fs3_fld1 <= #1  reg_areg_1_fs3_fld1_next;
      rg_areg_1_fs3_fld2 <= #1  reg_areg_1_fs3_fld2_next;
    end
  end
  
  //------- combinatorial assigns for blabla
  always_comb begin
    reg_blabla_fs1_0_fld1_next = rg_blabla_fs1_0_fld1;
    l2h_blabla_fs1_0_fld1_r = rg_blabla_fs1_0_fld1;
    reg_blabla_fs1_0_fld2_next = rg_blabla_fs1_0_fld2;
    l2h_blabla_fs1_0_fld2_r = rg_blabla_fs1_0_fld2;
    reg_blabla_fs1_1_fld1_next = rg_blabla_fs1_1_fld1;
    l2h_blabla_fs1_1_fld1_r = rg_blabla_fs1_1_fld1;
    reg_blabla_fs1_1_fld2_next = rg_blabla_fs1_1_fld2;
    l2h_blabla_fs1_1_fld2_r = rg_blabla_fs1_1_fld2;
    reg_blabla_fs1_2_fld1_next = rg_blabla_fs1_2_fld1;
    l2h_blabla_fs1_2_fld1_r = rg_blabla_fs1_2_fld1;
    reg_blabla_fs1_2_fld2_next = rg_blabla_fs1_2_fld2;
    l2h_blabla_fs1_2_fld2_r = rg_blabla_fs1_2_fld2;
    reg_blabla_fs3_0_fld1_next = rg_blabla_fs3_0_fld1;
    l2h_blabla_fs3_0_fld1_r = rg_blabla_fs3_0_fld1;
    reg_blabla_fs3_0_fld2_next = rg_blabla_fs3_0_fld2;
    l2h_blabla_fs3_0_fld2_r = rg_blabla_fs3_0_fld2;
    reg_blabla_fs3_1_fld1_next = rg_blabla_fs3_1_fld1;
    l2h_blabla_fs3_1_fld1_r = rg_blabla_fs3_1_fld1;
    reg_blabla_fs3_1_fld2_next = rg_blabla_fs3_1_fld2;
    l2h_blabla_fs3_1_fld2_r = rg_blabla_fs3_1_fld2;
    if (h2l_blabla_fs1_0_fld1_we) reg_blabla_fs1_0_fld1_next = h2l_blabla_fs1_0_fld1_w;
    if (h2l_blabla_fs1_1_fld1_we) reg_blabla_fs1_1_fld1_next = h2l_blabla_fs1_1_fld1_w;
    if (h2l_blabla_fs1_2_fld1_we) reg_blabla_fs1_2_fld1_next = h2l_blabla_fs1_2_fld1_w;
    if (h2l_blabla_fs3_0_fld1_we) reg_blabla_fs3_0_fld1_next = h2l_blabla_fs3_0_fld1_w;
    if (h2l_blabla_fs3_1_fld1_we) reg_blabla_fs3_1_fld1_next = h2l_blabla_fs3_1_fld1_w;
    if (d2l_blabla_we) reg_blabla_fs1_0_fld1_next = d2l_blabla_w [3:0] ;
    if (d2l_blabla_we) reg_blabla_fs1_0_fld2_next = d2l_blabla_w [4] ;
    if (d2l_blabla_we) reg_blabla_fs1_1_fld1_next = d2l_blabla_w [8:5] ;
    if (d2l_blabla_we) reg_blabla_fs1_1_fld2_next = d2l_blabla_w [9] ;
    if (d2l_blabla_we) reg_blabla_fs1_2_fld1_next = d2l_blabla_w [13:10] ;
    if (d2l_blabla_we) reg_blabla_fs1_2_fld2_next = d2l_blabla_w [14] ;
    if (d2l_blabla_we) reg_blabla_fs3_0_fld1_next = d2l_blabla_w [18:15] ;
    if (d2l_blabla_we) reg_blabla_fs3_0_fld2_next = d2l_blabla_w [19] ;
    if (d2l_blabla_we) reg_blabla_fs3_1_fld1_next = d2l_blabla_w [26:23] ;
    if (d2l_blabla_we) reg_blabla_fs3_1_fld2_next = d2l_blabla_w [27] ;
  end
  
  //------- reg assigns for blabla
  always_ff @ (posedge clk) begin
    if (reset) begin
      rg_blabla_fs1_0_fld1 <= #1 4'd0;
      rg_blabla_fs1_1_fld1 <= #1 4'd0;
      rg_blabla_fs1_2_fld1 <= #1 4'd0;
      rg_blabla_fs3_0_fld1 <= #1 4'd0;
      rg_blabla_fs3_1_fld1 <= #1 4'd0;
    end
    else begin
      rg_blabla_fs1_0_fld1 <= #1  reg_blabla_fs1_0_fld1_next;
      rg_blabla_fs1_0_fld2 <= #1  reg_blabla_fs1_0_fld2_next;
      rg_blabla_fs1_1_fld1 <= #1  reg_blabla_fs1_1_fld1_next;
      rg_blabla_fs1_1_fld2 <= #1  reg_blabla_fs1_1_fld2_next;
      rg_blabla_fs1_2_fld1 <= #1  reg_blabla_fs1_2_fld1_next;
      rg_blabla_fs1_2_fld2 <= #1  reg_blabla_fs1_2_fld2_next;
      rg_blabla_fs3_0_fld1 <= #1  reg_blabla_fs3_0_fld1_next;
      rg_blabla_fs3_0_fld2 <= #1  reg_blabla_fs3_0_fld2_next;
      rg_blabla_fs3_1_fld1 <= #1  reg_blabla_fs3_1_fld1_next;
      rg_blabla_fs3_1_fld2 <= #1  reg_blabla_fs3_1_fld2_next;
    end
  end
  
endmodule

//
//---------- module foo_jrdl_decode
//
module foo_jrdl_decode
(
  clk,
  reset,
  leaf_dec_wr_data,
  leaf_dec_addr,
  leaf_dec_block_sel,
  leaf_dec_valid,
  leaf_dec_wr_dvld,
  leaf_dec_cycle,
  leaf_dec_wr_width,
  l2d_areg_0_r,
  l2d_areg_1_r,
  l2d_blabla_r,

  dec_leaf_rd_data,
  dec_leaf_ack,
  dec_leaf_nack,
  dec_leaf_accept,
  dec_leaf_reject,
  dec_leaf_retry_atomic,
  dec_leaf_data_width,
  d2l_areg_0_w,
  d2l_areg_0_we,
  d2l_areg_0_re,
  d2l_areg_1_w,
  d2l_areg_1_we,
  d2l_areg_1_re,
  d2l_blabla_w,
  d2l_blabla_we,
  d2l_blabla_re );

  //------- inputs
  input    clk;
  input    reset;
  input     [31:0] leaf_dec_wr_data;
  input     [39:0] leaf_dec_addr;
  input    leaf_dec_block_sel;
  input    leaf_dec_valid;
  input    leaf_dec_wr_dvld;
  input     [1:0] leaf_dec_cycle;
  input     [2:0] leaf_dec_wr_width;
  input     [31:0] l2d_areg_0_r;
  input     [31:0] l2d_areg_1_r;
  input     [31:0] l2d_blabla_r;

  //------- outputs
  output     [31:0] dec_leaf_rd_data;
  output    dec_leaf_ack;
  output    dec_leaf_nack;
  output    dec_leaf_accept;
  output    dec_leaf_reject;
  output    dec_leaf_retry_atomic;
  output     [2:0] dec_leaf_data_width;
  output     [31:0] d2l_areg_0_w;
  output    d2l_areg_0_we;
  output    d2l_areg_0_re;
  output     [31:0] d2l_areg_1_w;
  output    d2l_areg_1_we;
  output    d2l_areg_1_re;
  output     [31:0] d2l_blabla_w;
  output    d2l_blabla_we;
  output    d2l_blabla_re;


  //------- wire defines
  logic   [31:0] pio_dec_write_data;
  logic   [3:2] pio_dec_address;
  logic  pio_dec_read;
  logic  pio_dec_write;
  logic   [39:0] block_sel_addr;
  logic  block_sel;
  logic  leaf_dec_valid_active;
  logic  leaf_dec_wr_dvld_active;
  
  //------- reg defines
  logic   [31:0] d2l_areg_0_w;
  logic  d2l_areg_0_we;
  logic  d2l_areg_0_re;
  logic   [31:0] d2l_areg_1_w;
  logic  d2l_areg_1_we;
  logic  d2l_areg_1_re;
  logic   [31:0] d2l_blabla_w;
  logic  d2l_blabla_we;
  logic  d2l_blabla_re;
  logic  leaf_dec_valid_hld1;
  logic  leaf_dec_valid_hld1_next;
  logic  leaf_dec_wr_dvld_hld1;
  logic  leaf_dec_wr_dvld_hld1_next;
  logic  pio_write_active;
  logic  pio_read_active;
  logic   [3:2] pio_dec_address_d1;
  logic   [31:0] pio_dec_write_data_d1;
  logic   [31:0] dec_pio_read_data;
  logic   [31:0] dec_pio_read_data_d1;
  logic  dec_pio_ack;
  logic  dec_pio_nack;
  logic  dec_pio_ack_next;
  logic  dec_pio_nack_next;
  logic  pio_internal_ack;
  logic  pio_internal_nack;
  logic  pio_external_ack;
  logic  pio_external_nack;
  logic  pio_external_ack_next;
  logic  pio_external_nack_next;
  logic  pio_no_acks;
  logic  pio_activate_write;
  logic  pio_activate_read;
  logic   [31:0] dec_pio_read_data_next;
  logic  external_transaction_active;
  
  
  //------- assigns
  assign  pio_dec_write_data = leaf_dec_wr_data;
  assign  dec_leaf_rd_data = dec_pio_read_data;
  assign  dec_leaf_ack = dec_pio_ack;
  assign  dec_leaf_nack = dec_pio_nack;
  assign  pio_dec_address = leaf_dec_addr [3:2] ;
  assign  block_sel_addr = 40'h0;
  assign  block_sel = leaf_dec_block_sel;
  assign  leaf_dec_wr_dvld_active = leaf_dec_wr_dvld | leaf_dec_wr_dvld_hld1;
  assign  leaf_dec_valid_active = leaf_dec_valid | leaf_dec_valid_hld1;
  assign  dec_leaf_accept = leaf_dec_valid & block_sel;
  assign  dec_leaf_reject = leaf_dec_valid & ~block_sel;
  assign  pio_dec_read = block_sel & leaf_dec_valid_active & (leaf_dec_cycle == 2'b10);
  assign  pio_dec_write = block_sel & leaf_dec_wr_dvld_active & (leaf_dec_cycle[1] == 1'b0);
  assign  dec_leaf_retry_atomic = 1'b0;
  assign  dec_leaf_data_width = 3'b0;
  
  //------- combinatorial assigns for pio read data
  always_comb begin
    dec_pio_read_data = dec_pio_read_data_d1;
  end
  
  //------- reg assigns for pio read data
  always_ff @ (posedge clk) begin
    if (reset) begin
      dec_pio_read_data_d1 <= #1  32'b0;
    end
    else begin
      dec_pio_read_data_d1 <= #1 dec_pio_read_data_next;
    end
  end
  
  //------- reg assigns for pio i/f
  always_ff @ (posedge clk) begin
    if (reset) begin
      pio_write_active <= #1  1'b0;
      pio_read_active <= #1  1'b0;
    end
    else begin
      pio_write_active <= #1  pio_write_active ? pio_no_acks : pio_activate_write;
      pio_read_active <= #1  pio_read_active ? pio_no_acks : pio_activate_read;
      pio_dec_address_d1 <= #1   pio_dec_address;
      pio_dec_write_data_d1 <= #1  pio_dec_write_data;
    end
  end
  
  //------- combinatorial assigns for leaf i/f
  always_comb begin
    leaf_dec_valid_hld1_next = leaf_dec_valid | leaf_dec_valid_hld1;
    if (dec_pio_ack_next | dec_pio_nack_next) leaf_dec_valid_hld1_next = 1'b0;
    leaf_dec_wr_dvld_hld1_next = leaf_dec_wr_dvld | leaf_dec_wr_dvld_hld1;
    if (dec_pio_ack_next | dec_pio_nack_next | leaf_dec_valid) leaf_dec_wr_dvld_hld1_next = 1'b0;
  end
  
  //------- reg assigns for leaf i/f
  always_ff @ (posedge clk) begin
    if (reset) begin
      leaf_dec_valid_hld1 <= #1  1'b0;
      leaf_dec_wr_dvld_hld1 <= #1  1'b0;
    end
    else begin
      leaf_dec_valid_hld1 <= #1 leaf_dec_valid_hld1_next;
      leaf_dec_wr_dvld_hld1 <= #1 leaf_dec_wr_dvld_hld1_next;
    end
  end
  
  //------- combinatorial assigns for pio ack/nack
  always_comb begin
    pio_internal_nack = (pio_read_active | pio_write_active) & ~pio_internal_ack & ~external_transaction_active;
    dec_pio_ack_next = (pio_internal_ack | (pio_external_ack_next & external_transaction_active));
    dec_pio_nack_next = (pio_internal_nack | (pio_external_nack_next & external_transaction_active));
    pio_no_acks = ~(dec_pio_ack | dec_pio_nack | pio_external_ack | pio_external_nack);
    pio_activate_write = (pio_dec_write & ~(dec_pio_ack | dec_pio_nack));
    pio_activate_read = (pio_dec_read & ~(dec_pio_ack | dec_pio_nack));
  end
  
  //------- reg assigns for pio ack/nack
  always_ff @ (posedge clk) begin
    if (reset) begin
      dec_pio_ack <= #1 1'b0;
      dec_pio_nack <= #1 1'b0;
      pio_external_ack <= #1  1'b0;
      pio_external_nack <= #1  1'b0;
    end
    else begin
      dec_pio_ack <= #1 dec_pio_ack ? 1'b0 : dec_pio_ack_next;
      dec_pio_nack <= #1 dec_pio_nack ? 1'b0 : dec_pio_nack_next;
      pio_external_ack <= #1 pio_external_ack_next;
      pio_external_nack <= #1 pio_external_nack_next;
    end
  end
  
  
  //------- address decode
  always_comb begin
    pio_internal_ack = 1'b0;
    external_transaction_active = 1'b0;
    pio_external_ack_next = 1'b0;
    pio_external_nack_next = 1'b0;
    dec_pio_read_data_next = 32'b0;
    
    d2l_areg_0_w = pio_dec_write_data_d1  [31:0] ;
    d2l_areg_0_we = 1'b0;
    d2l_areg_0_re = 1'b0;
    d2l_areg_1_w = pio_dec_write_data_d1  [31:0] ;
    d2l_areg_1_we = 1'b0;
    d2l_areg_1_re = 1'b0;
    d2l_blabla_w = pio_dec_write_data_d1  [31:0] ;
    d2l_blabla_we = 1'b0;
    d2l_blabla_re = 1'b0;
    
    casez(pio_dec_address_d1)
    //  Register: areg_0     Address: 0x0     External: false
    2'b00:
      begin
        d2l_areg_0_we = pio_write_active & ~dec_pio_ack;
        d2l_areg_0_re = pio_read_active & ~dec_pio_ack;
        pio_internal_ack =  pio_read_active | pio_write_active;
        dec_pio_read_data_next  [31:0]  = l2d_areg_0_r;
      end
    //  Register: areg_1     Address: 0x4     External: false
    2'b01:
      begin
        d2l_areg_1_we = pio_write_active & ~dec_pio_ack;
        d2l_areg_1_re = pio_read_active & ~dec_pio_ack;
        pio_internal_ack =  pio_read_active | pio_write_active;
        dec_pio_read_data_next  [31:0]  = l2d_areg_1_r;
      end
    //  Register: blabla     Address: 0x8     External: false
    2'b10:
      begin
        d2l_blabla_we = pio_write_active & ~dec_pio_ack;
        d2l_blabla_re = pio_read_active & ~dec_pio_ack;
        pio_internal_ack =  pio_read_active | pio_write_active;
        dec_pio_read_data_next  [31:0]  = l2d_blabla_r;
      end
    endcase
  end
  
endmodule

//
//---------- module foo_pio
//
module foo_pio
(
  clk,
  reset,
  h2l_areg_0_hier_fs_fs1_fld1_w,
  h2l_areg_0_hier_fs_fs1_fld1_we,
  h2l_areg_0_hier_fs_fs2_fld1_w,
  h2l_areg_0_hier_fs_fs2_fld1_we,
  h2l_areg_0_fs3_fld1_w,
  h2l_areg_0_fs3_fld1_we,
  h2l_areg_1_hier_fs_fs1_fld1_w,
  h2l_areg_1_hier_fs_fs1_fld1_we,
  h2l_areg_1_hier_fs_fs2_fld1_w,
  h2l_areg_1_hier_fs_fs2_fld1_we,
  h2l_areg_1_fs3_fld1_w,
  h2l_areg_1_fs3_fld1_we,
  h2l_blabla_fs1_0_fld1_w,
  h2l_blabla_fs1_0_fld1_we,
  h2l_blabla_fs1_1_fld1_w,
  h2l_blabla_fs1_1_fld1_we,
  h2l_blabla_fs1_2_fld1_w,
  h2l_blabla_fs1_2_fld1_we,
  h2l_blabla_fs3_0_fld1_w,
  h2l_blabla_fs3_0_fld1_we,
  h2l_blabla_fs3_1_fld1_w,
  h2l_blabla_fs3_1_fld1_we,
  leaf_dec_wr_data,
  leaf_dec_addr,
  leaf_dec_block_sel,
  leaf_dec_valid,
  leaf_dec_wr_dvld,
  leaf_dec_cycle,
  leaf_dec_wr_width,

  l2h_areg_0_hier_fs_fs1_fld1_r,
  l2h_areg_0_hier_fs_fs1_fld2_r,
  l2h_areg_0_hier_fs_fld1_r,
  l2h_areg_0_hier_fs_fs2_fld1_r,
  l2h_areg_0_hier_fs_fs2_fld2_r,
  l2h_areg_0_fs3_fld1_r,
  l2h_areg_0_fs3_fld2_r,
  l2h_areg_1_hier_fs_fs1_fld1_r,
  l2h_areg_1_hier_fs_fs1_fld2_r,
  l2h_areg_1_hier_fs_fld1_r,
  l2h_areg_1_hier_fs_fs2_fld1_r,
  l2h_areg_1_hier_fs_fs2_fld2_r,
  l2h_areg_1_fs3_fld1_r,
  l2h_areg_1_fs3_fld2_r,
  l2h_blabla_fs1_0_fld1_r,
  l2h_blabla_fs1_0_fld2_r,
  l2h_blabla_fs1_1_fld1_r,
  l2h_blabla_fs1_1_fld2_r,
  l2h_blabla_fs1_2_fld1_r,
  l2h_blabla_fs1_2_fld2_r,
  l2h_blabla_fs3_0_fld1_r,
  l2h_blabla_fs3_0_fld2_r,
  l2h_blabla_fs3_1_fld1_r,
  l2h_blabla_fs3_1_fld2_r,
  dec_leaf_rd_data,
  dec_leaf_ack,
  dec_leaf_nack,
  dec_leaf_accept,
  dec_leaf_reject,
  dec_leaf_retry_atomic,
  dec_leaf_data_width );

  //------- inputs
  input    clk;
  input    reset;
  input     [3:0] h2l_areg_0_hier_fs_fs1_fld1_w;
  input    h2l_areg_0_hier_fs_fs1_fld1_we;
  input     [3:0] h2l_areg_0_hier_fs_fs2_fld1_w;
  input    h2l_areg_0_hier_fs_fs2_fld1_we;
  input     [3:0] h2l_areg_0_fs3_fld1_w;
  input    h2l_areg_0_fs3_fld1_we;
  input     [3:0] h2l_areg_1_hier_fs_fs1_fld1_w;
  input    h2l_areg_1_hier_fs_fs1_fld1_we;
  input     [3:0] h2l_areg_1_hier_fs_fs2_fld1_w;
  input    h2l_areg_1_hier_fs_fs2_fld1_we;
  input     [3:0] h2l_areg_1_fs3_fld1_w;
  input    h2l_areg_1_fs3_fld1_we;
  input     [3:0] h2l_blabla_fs1_0_fld1_w;
  input    h2l_blabla_fs1_0_fld1_we;
  input     [3:0] h2l_blabla_fs1_1_fld1_w;
  input    h2l_blabla_fs1_1_fld1_we;
  input     [3:0] h2l_blabla_fs1_2_fld1_w;
  input    h2l_blabla_fs1_2_fld1_we;
  input     [3:0] h2l_blabla_fs3_0_fld1_w;
  input    h2l_blabla_fs3_0_fld1_we;
  input     [3:0] h2l_blabla_fs3_1_fld1_w;
  input    h2l_blabla_fs3_1_fld1_we;
  input     [31:0] leaf_dec_wr_data;
  input     [39:0] leaf_dec_addr;
  input    leaf_dec_block_sel;
  input    leaf_dec_valid;
  input    leaf_dec_wr_dvld;
  input     [1:0] leaf_dec_cycle;
  input     [2:0] leaf_dec_wr_width;

  //------- outputs
  output     [3:0] l2h_areg_0_hier_fs_fs1_fld1_r;
  output    l2h_areg_0_hier_fs_fs1_fld2_r;
  output    l2h_areg_0_hier_fs_fld1_r;
  output     [3:0] l2h_areg_0_hier_fs_fs2_fld1_r;
  output    l2h_areg_0_hier_fs_fs2_fld2_r;
  output     [3:0] l2h_areg_0_fs3_fld1_r;
  output    l2h_areg_0_fs3_fld2_r;
  output     [3:0] l2h_areg_1_hier_fs_fs1_fld1_r;
  output    l2h_areg_1_hier_fs_fs1_fld2_r;
  output    l2h_areg_1_hier_fs_fld1_r;
  output     [3:0] l2h_areg_1_hier_fs_fs2_fld1_r;
  output    l2h_areg_1_hier_fs_fs2_fld2_r;
  output     [3:0] l2h_areg_1_fs3_fld1_r;
  output    l2h_areg_1_fs3_fld2_r;
  output     [3:0] l2h_blabla_fs1_0_fld1_r;
  output    l2h_blabla_fs1_0_fld2_r;
  output     [3:0] l2h_blabla_fs1_1_fld1_r;
  output    l2h_blabla_fs1_1_fld2_r;
  output     [3:0] l2h_blabla_fs1_2_fld1_r;
  output    l2h_blabla_fs1_2_fld2_r;
  output     [3:0] l2h_blabla_fs3_0_fld1_r;
  output    l2h_blabla_fs3_0_fld2_r;
  output     [3:0] l2h_blabla_fs3_1_fld1_r;
  output    l2h_blabla_fs3_1_fld2_r;
  output     [31:0] dec_leaf_rd_data;
  output    dec_leaf_ack;
  output    dec_leaf_nack;
  output    dec_leaf_accept;
  output    dec_leaf_reject;
  output    dec_leaf_retry_atomic;
  output     [2:0] dec_leaf_data_width;


  //------- wire defines
  logic   [31:0] d2l_areg_0_w;
  logic  d2l_areg_0_we;
  logic  d2l_areg_0_re;
  logic   [31:0] d2l_areg_1_w;
  logic  d2l_areg_1_we;
  logic  d2l_areg_1_re;
  logic   [31:0] d2l_blabla_w;
  logic  d2l_blabla_we;
  logic  d2l_blabla_re;
  logic   [31:0] l2d_areg_0_r;
  logic   [31:0] l2d_areg_1_r;
  logic   [31:0] l2d_blabla_r;
  
  
  foo_jrdl_decode pio_decode ( .* );
    
  foo_jrdl_logic pio_logic ( .* );
    
endmodule

