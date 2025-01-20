`celldefine 

/** Simplified simulation model for FDCE **/ 

module FDCE #(
  parameter [0:0] INIT = 1'b0)(
  output Q,
  
  input C,
  input CE,
  input CLR,
  input D
);
    reg Q_out = INIT;
    always @(posedge C or posedge CLR)
        if (CLR || (CLR === 1'bx && Q_out == 1'b0))
            Q_out <= 1'b0;
        else if (CE || (CE === 1'bz) || ((CE === 1'bx) && (Q_out == D)))
            Q_out <= D;
    assign Q = Q_out;

endmodule

`endcelldefine
