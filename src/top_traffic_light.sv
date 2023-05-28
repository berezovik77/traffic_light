module top_traffic_light #(
    parameter GREEN_ON      =   40  ,
    parameter YELLOW_ON     =   5   ,
    parameter RED_ON        =   15  ,   
    parameter BLINKING      =   3
)
(
    input           clk             ,
    input           rstn            ,
    input           en_i            ,
    output  [2:0]   color_out 
);


    traffic_light #(
    .GREEN_ON       (GREEN_ON   )   ,
    .YELLOW_ON      (YELLOW_ON  )   ,
    .RED_ON         (RED_ON     )   ,
    .BLINKING       (BLINKING   )    
    )
    tr_light
    (
    .clk            (clk        )   ,
    .rstn           (rstn       )   ,
    .en_i           (en_i       )   ,
    .color_out      (color_out  )     
    );



endmodule