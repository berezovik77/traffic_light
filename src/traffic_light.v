module traffic_light #(
    parameter GREEN_ON      =   40  ,
    parameter YELLOW_ON     =   5   ,
    parameter RED_ON        =   15  ,   
    parameter BLINKING      =   3
    )
    (
    input           clk             ,
    input           rstn            ,
    input           en_i            ,
    output  [2:0]   color_out               // [2] - RED, [1] - YELLOW, [0] - GREEN 
    );

    localparam [2:0] GREEN    =   3'b001   ;
    localparam [2:0] YELLOW   =   3'b010   ;
    localparam [2:0] RED      =   3'b100   ;

    reg   [2:0]   state       =   GREEN         ;
    reg   [7:0]   timer       =   {8{1'b0}}     ;
    reg           backlight   =   1'b1          ;
    reg           reverse     =   1'b0          ;    

    always@(posedge clk)
        if (!rstn)
            begin
                state       <=  GREEN       ;
                timer       <=  {8{1'b0}}   ;
                backlight   <=  1'b0        ;
                reverse     <=  1'b0        ;
            end
        else
            case(state)
                //----------------------------------------------------//
                GREEN:
                    begin
                        if(~en_i)
                            begin
                                state       <=  GREEN       ;
                                timer       <=  timer       ;
                                backlight   <=  1'b0        ; // no backlight for traffic_light
                            end
                            else                              
                                if(timer < GREEN_ON)
                                    begin
                                        state       <=  GREEN           ;
                                        timer       <=  timer + 1'b1    ;
                                        backlight   <=  1'b1            ;
                                    end
                                else
                                    if(timer < GREEN_ON + BLINKING*2)
                                        begin
                                            state       <=  GREEN           ;
                                            timer       <=  timer + 1'b1    ;
                                            backlight   <=  ~backlight      ;
                                        end
                                    else
                                        begin
                                            state       <=  YELLOW      ;
                                            timer       <=  {8{1'b0}}   ;
                                            backlight   <=  1'b1        ;
                                            reverse     <=  1'b0        ;
                                        end
                    end
                //----------------------------------------------------//
                YELLOW:
                    begin
                        if(~en_i)
                            begin
                                state       <=  YELLOW      ;
                                timer       <=  timer       ;
                                backlight   <=  1'b0        ;
                            end
                            else 
                                if(timer < YELLOW_ON)
                                    begin
                                        state       <=  YELLOW          ;
                                        timer       <=  timer + 1'b1    ;
                                        backlight   <=  1'b1            ;
                                    end
                                else
                                    if(reverse)
                                        begin
                                            state   <=  GREEN        ;
                                            timer   <=  {8{1'b0}}    ;
                                        end   
                                    else
                                        begin
                                            state   <=  RED          ;
                                            timer   <=  {8{1'b0}}    ;
                                        end       
                    end
                //----------------------------------------------------//
                RED:
                    begin
                        if(~en_i)
                            begin
                                state       <=  RED         ;
                                timer       <=  timer       ;
                                backlight   <=  1'b0        ;
                            end
                            else                                 
                                if(timer < RED_ON)
                                    begin
                                        state       <= RED              ; 
                                        timer       <= timer + 1'b1     ;
                                        backlight   <= 1'b1             ;
                                    end
                                else
                                    if(timer < RED_ON + BLINKING*2)
                                        begin
                                            state       <=  RED          ;
                                            timer       <=  timer + 1    ;
                                            backlight   <=  ~backlight   ;
                                        end
                                    else
                                        begin
                                            state       <=  YELLOW       ;
                                            timer       <=  {8{1'b0}}    ;
                                            backlight   <=  1'b1         ;
                                            reverse     <=  1'b1         ;
                                        end       
                    end
                //----------------------------------------------------//
                default: state  <=  GREEN   ;    
            endcase
            
    assign color_out[0] = (state == GREEN)&&(backlight)     ;
    assign color_out[1] = (state == YELLOW)&&(backlight)    ;
    assign color_out[2] = (state == RED)&&(backlight)       ;


endmodule