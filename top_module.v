
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2023 01:59:34 PM
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module(
    input clk,
    input [15:0] sw,
    input btnC,
    output reg [6:0]seg = 0,
    output reg[3:0] an = 4'b1111,
    output reg bitti = 1'b0,
    output reg [1:0]p = 2'b11
    );
    
    localparam ZERO  = 7'b000_0001;  // 0
    localparam ONE   = 7'b100_1111;  // 1
    localparam TWO   = 7'b001_0010;  // 2 
    localparam THREE = 7'b000_0110;  // 3
    localparam FOUR  = 7'b100_1100;  // 4
    localparam FIVE  = 7'b010_0100;  // 5
    localparam SIX   = 7'b010_0000;  // 6
    localparam SEVEN = 7'b000_1111;  // 7
    localparam EIGHT = 7'b000_0000;  // 8
    localparam NINE  = 7'b000_0100;  // 9
    localparam A= 7'b000_1000;
    localparam b= 7'b110_0000;
    localparam C= 7'b011_0001;
    localparam d= 7'b100_0010;
    localparam E= 7'b011_0000;
    localparam F= 7'b011_1000;
    
    reg [3:0] bull;
    reg [3:0] cow;
 
    reg[15:0] sayi0 = 0;
    reg[15:0] sayi1 = 0;
    reg[15:0] tahmin = 0;
    
    reg s0 = 1'b0 ,s1 = 1'b0;
    reg bitti_next,p_next;
    reg btnC_prev = 0;
    reg sira = 0,sira_next = 0;
    reg[2:0]bull_next = 0;
    reg[2:0]cow_next = 0;
    reg gir = 0;
    integer i = 0;
    integer j = 0;
    
    always@(posedge clk) begin
        if(btnC == 1'b1 && btnC_prev == 1'b0)
            gir = 1'b1;
        else
            gir = 1'b0;
        
        btnC_prev = btnC; 
    end
    
    always@(posedge gir) begin
        
        if(btnC == 1'b1) begin
             if(s0 == 1'b0 && btnC == 1'b1) begin 
                sayi0 = sw; 
                s0 = 1'b1;              
             end
             else if(s1 == 1'b0 && btnC == 1) begin
                sayi1 = sw;
                s1 = 1'b1;
             end
             else if(btnC == 1) begin
                tahmin = sw;
             end
             
            if(bitti == 1'b0 && s1 == 1'b1 && s0 == 1'b1) begin
                bull = 0;
                cow = 0;
             
                if(sira == 1'b0) begin
                    bull = bull + &(sayi1[15:12]~^tahmin[15:12]);
                    bull = bull + &(sayi1[11:8]~^tahmin[11:8]);
                    bull = bull + &(sayi1[7:4]~^tahmin[7:4]);
                    bull = bull + &(sayi1[3:0]~^tahmin[3:0]);
              
                    for(i = 0; i<4; i = i+1) begin               
                        for(j = 0; j<4; j = j+1) begin
                             if(i != j) begin
                                cow = cow + &(tahmin[(i*4)+3 -:4]~^sayi1[4*j+3 -:4]); 
                            end
                        end
                    end
                    
                end
                    
             
             if(sira == 1'b1) begin
                bull = bull + &(sayi0[15:12]~^tahmin[15:12]);
                bull = bull + &(sayi0[11:8]~^tahmin[11:8]);
                bull = bull + &(sayi0[7:4]~^tahmin[7:4]);
                bull = bull + &(sayi0[3:0]~^tahmin[3:0]);
              
                for(i = 0; i<4; i =i+1) begin         
                    for(j = 0; j<4; j = j+1) begin
                        if(i != j) begin
                        cow = cow + &(tahmin[(i*4)+3 -:4]~^sayi0[4*j+3 -:4]); 
                        end
                    end
                end
              
              end
             
             if(bull == 3'd4) begin
                bitti = 1'b1;
             end
                if(sira == 0) begin
                    p = 2'b10;
                end
                else begin
                    p = 2'b00;
                end
                
            end
            sira = ~sira;
        end    
    end
    
    
    reg[22:0] sayac = 0;
    reg clk_yavas = 0;
    
    always@(posedge clk) begin 
        if(sayac == 499) begin
            sayac = 0;
            clk_yavas = ~clk_yavas;
        end
        else begin
            sayac = sayac +1;
         end
    end
    
    reg[1:0] k = 0;
    
    always@(posedge clk) begin // Yavaslatılmıs clock veya bc kulanabılırım
        
        
      if(k == 2'b00) begin
         an = 4'b1110;
        case(cow)
            4'h0:seg = ZERO;
            4'h1:seg = ONE;
            4'h2:seg = TWO;
            4'h3:seg = THREE;
            4'h4:seg = FOUR;
            4'h5:seg = FIVE;
            4'h6:seg = SIX;
            4'h7:seg = SEVEN;
            4'h8:seg = EIGHT;
            4'h9:seg = NINE;
            4'hA:seg = A;
            4'hB:seg = b;
            4'hC:seg = C;
            4'hD:seg = d;
            4'hE:seg = E;
            4'hF:seg = F;
        endcase
       
        
        end
        
        if(k == 2'b01) begin
            an = 4'b1101;
            seg = C;
          
            
        end
        
        if(k == 2'b10) begin  
        an = 4'b1011;
        
        case(bull)
            4'h0:seg = ZERO;
            4'h1:seg = ONE;
            4'h2:seg = TWO;
            4'h3:seg = THREE;
            4'h4:seg = FOUR;
            4'h5:seg = FIVE;
            4'h6:seg = SIX;
            4'h7:seg = SEVEN;
            4'h8:seg = EIGHT;
            4'h9:seg = NINE;
            4'hA:seg = A;
            4'hB:seg = b;
            4'hC:seg = C;
            4'hD:seg = d;
            4'hE:seg = E;
            4'hF:seg = F;
        endcase
        
        
        end
        
        if(k == 2'b11) begin
            an = 4'b0111;
            seg = b;
            
            
        end
             k = k+1;
       end
       
    
    
    
endmodule