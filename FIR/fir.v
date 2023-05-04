module firfilter #(
    parameter DATA_SIZE = 9,
    parameter N_TAPS = 3
)
(
    input clk,
    input signed [DATA_SIZE-1:0] data,
    input data_ready,

    // output reg [DATA_SIZE-1:0] res = 0,
    output reg [DATA_SIZE-1:0] summ = 0
);


reg signed [DATA_SIZE-1:0] buff[N_TAPS-1:0];
reg signed [7:0] i = 0;
reg signed [7:0] j = 0;
reg signed [DATA_SIZE-1:0] coef[N_TAPS-1:0];

wire signed [15:0] mult, m0, m1;
reg [7:0] cnt_mult = 0;

assign mult = m0*m1;
assign m0 = buff[cnt_mult];
assign m1 = coef[cnt_mult];

initial
begin
    buff[0] = 0;
    buff[1] = 0;
    buff[2] = 0;
    for(j=0; j<N_TAPS; j=j+1)
    begin
        coef[j] <= (j+i);
    end
end

// always @(posedge clk) 
// begin
//     if (data_ready) 
//     begin
//     buff[0] = buff[1];
//     buff[1] = buff[2];
//     buff[2] = data;
//     end
//     res = 0;
//     for (i=0; i<N_TAPS; i=i+1)
//     begin
//         res = res + coef[i]*buff[i];
//     end    
// end


always @(posedge clk)
begin
    if (data_ready) 
    begin
        buff[0] = buff[1];
        buff[1] = buff[2];
        buff[2] = data;
    end
    summ <= cnt_mult == 0 ? mult : summ + mult;
    cnt_mult <= data_ready == 1 ? 0 : cnt_mult + 1;
end


endmodule