import rv32i_types::*;

module cmp
(
    input branch_funct3_t cmpop,
    input logic [31:0] a, b,
    output logic br_en
);

always_comb
begin
    unique case (cmpop)
        beq:  br_en = (a==b);
        bne:  br_en = (a!=b);
        blt:  br_en = ($signed(a) < $signed(b));
        bge:  br_en = ($signed(a) >= $signed(b));
        bltu:  br_en = (a<b);
        bgeu:  br_en = (a>=b);
        default: br_en = 1'b0;
    endcase
end

endmodule : cmp
