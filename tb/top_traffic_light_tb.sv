`timescale 10ns/1ns

`define     RST_MODULE			\
    #100						\
    rstn	=	0	;			\
    #100						\
    rstn   =	1	;               


module top_traffic_light_tb();
    localparam          GREEN_ON    =   40      ;
    localparam          YELLOW_ON   =   5       ;
    localparam          RED_ON      =   15      ;   
    localparam          BLINKING    =   3       ;

    reg                 clk         =   1'b1    ;    
    reg                 rstn        =   1'b0    ; 
    reg                 en_i        =   1'b1    ;
    wire        [2:0]   color_out               ;

    //----------------States-----------------------//
    localparam  [2:0]   GREEN       =   3'b001  ;
    localparam  [2:0]   YELLOW      =   3'b010  ;
    localparam  [2:0]   RED         =   3'b100  ;
    //------------------End------------------------//

    always #10      clk   <=  !clk     ;
    integer i = 0   ;

    task default_light;    
        begin
            
            wait (color_out == RED);
            wait (color_out == GREEN);
            $display ("Cycle counter = %d",i++);
        end
    endtask

    task test_en_i;
        input [2:0] state;
        begin
            $display ("Test enable signal = %d",state);
            wait (color_out == state);
            repeat(2) @(posedge clk);
            en_i <= 1'b0;
            repeat(10) @(posedge clk);
            en_i <= 1'b1;
        end
    endtask

    initial begin
        `RST_MODULE
        repeat(10)  @(posedge clk);
        $display ("Start Traffic_light Test");
        
        repeat(4)   default_light()      ;
        repeat(2)   test_en_i(GREEN)    ;
        repeat(2)   test_en_i(YELLOW)   ;
        repeat(2)   test_en_i(RED)      ;

        repeat(1)   test_en_i(RED)      ;
        `RST_MODULE

        #2000
        $stop;
    end

    top_traffic_light #(
    .GREEN_ON       (GREEN_ON   )   ,
    .YELLOW_ON      (YELLOW_ON  )   ,
    .RED_ON         (RED_ON     )   ,
    .BLINKING       (BLINKING   )    
    )
    traf_light
    (
    .clk            (clk        )   ,
    .rstn           (rstn       )   ,
    .en_i           (en_i       )   ,
    .color_out      (color_out  )     
    );

endmodule