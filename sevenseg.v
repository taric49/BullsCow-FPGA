`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/11/2023 01:16:30 PM
// Design Name: 
// Module Name: sevenseg
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


`timescale 1ns / 1ps
module BaC(

    input clk,
    input [15:0]switchgirdi,
    //Bulls and Cows gösterilirken 7-seg disp'de 
    //ilk disp'de "b", ikinci disp'de bulls sayısı
    //ucuncu disp'de "C", dorduncu disp'de cows sayısı gösterilecek
    // B x C y formatında yani (B ve C sabit olacak degerler. 
    // B = 11 C = 12 (1011 xxxx 1100 yyyy formatında olmalı)
    
    //Oyunculardan birincisi kazanınca 0001, ikincisi kazanınca 0002 gösterilecek
    output reg [6:0] ilkLed,
    
    
    
    output reg [3:0] anot,
    input reset,
    input buton
    //output reg[15:0] sonuc
);
    reg [6:0]birLed = 0;
    reg [6:0]ikiLed = 0;
    reg [6:0]ucLed = 0;
    reg [6:0]dortLed = 0;
    //Kullanıcıların seçtiği sayılar
    // 4 4 4 4 olarak bitlere bölünmeli
    reg[15:0] o1SecilenSayi;
    reg[15:0] o2SecilenSayi;
    
    //Mantık: 7 reglik 4 tane led giriliyor
    //Anot hangi ledin ışık vereceğine karar veriyor (0100 -> 2. led demek)
    //reg [3:0] anot = 4'd0;
    

    //reg reset = 0;
    
    
    //7-seg disp için local paramlar giriliyor
    // G'yi sona alacak sekilde. A = en anlamlı
    localparam sifir = 7'b0000001;
    localparam bir = 7'b1001111;
    localparam iki = 7'b0010010;
    localparam uc = 7'b0000110;
    localparam dort = 7'b1001100;
    localparam bes = 7'b0100100;
    localparam alti = 7'b0100000;
    localparam yedi = 7'b0001111;
    localparam sekiz = 7'b0000000;
    localparam dokuz = 7'b0000100;
    localparam A = 7'b0001000;
    localparam B = 7'b1100000;
    localparam C = 7'b0110001;
    localparam D = 7'b1000010;
    localparam E = 7'b0110000;
    localparam F = 7'b0111000;
    
    
    //Clock yavaşlatmak için gereken süreyi sayıyor.
    reg[31:0] sayac = 0;
    reg yavas_clk = 0;
    
    
    
    //Oyuncuların sayılarını girip girmediğini tutuyor
    reg o1GirildiMi = 0;
    reg o2GirildiMi = 0; 
    
    //Switch'e girilen değer
    //reg [15:0]switchgirdi = 16'd0; // 16-13'ü ilk sayi her sayi 4 bit
 
    reg [1:0] ledler = 2'd0;
    reg [2:0] bulls =0;
    reg [2:0] cows=0;
    reg tur = 0; // 0 -> 1. oyuncu 1->2. oyuncu
    reg yeniclock;
    reg flag;
    //Başta oyuncular sayılarını girmediği için değer ataması
    
    initial begin
            flag = 0;
            anot = 4'b0111;
            ilkLed = bir;
            
            #100000000;
            
            anot = 4'b1011;
            ilkLed = iki;
            
            #100000000;     
            anot = 4'b1101;
            ilkLed = uc;
            #100000000;
            anot = 4'b1110;
            ilkLed = dort;
            
            anot = 4'b0000;
  
        o1GirildiMi = 0;
        o2GirildiMi = 0;
        
    end
    
//    // always icinde ledleri,switch degerine göre güncelleme fikri. ledleri atyacagız tek tek
//    always@(switchgirdi,reset) begin
//           anot = 4'b0001;
           
//           //İlk 4 bit atanıyor
//           case(switchgirdi[15:12])
//                0: ilkLed = sifir; 
//                1: ilkLed = bir; 
//                2: ilkLed = iki; 
//                3: ilkLed = uc; 
//                4: ilkLed = dort; 
//                5: ilkLed = bes; 
//                6: ilkLed = alti; 
//                7: ilkLed = yedi; 
//                8: ilkLed = sekiz; 
//                9: ilkLed = dokuz; 
//                10: ilkLed = A; 
//                11: ilkLed = B; 
//                12: ilkLed = C; 
//                13: ilkLed = D; 
//                14: ilkLed = E; 
//                15: ilkLed = F; 
//           endcase      
           
//           anot = 4'b1011;
           
//           //Ikinci 4 bit atanıyor
//           case(switchgirdi[11:8])
//                0: ilkLed  = sifir; 
//                1: ilkLed = bir; 
//                2: ilkLed = iki; 
//                3: ilkLed = uc; 
//                4: ilkLed = dort; 
//                5: ilkLed = bes; 
//                6: ilkLed = alti; 
//                7: ilkLed = yedi; 
//                8: ilkLed = sekiz; 
//                9: ilkLed = dokuz; 
//                10: ilkLed = A; 
//                11: ilkLed = B; 
//                12: ilkLed = C; 
//                13: ilkLed = D; 
//                14: ilkLed = E; 
//                15: ilkLed = F;  
//           endcase 
//           anot = 4'b1101;
     
//           //Ucuncu 4 bit atanıyor
//           case(switchgirdi[7:4])
//                0: ilkLed = sifir; 
//                1: ilkLed = bir; 
//                2: ilkLed = iki; 
//                3: ilkLed = uc; 
//                4: ilkLed = dort; 
//                5: ilkLed = bes; 
//                6: ilkLed = alti; 
//                7: ilkLed = yedi; 
//                8: ilkLed = sekiz; 
//                9: ilkLed = dokuz; 
//                10: ilkLed= A; 
//                11: ilkLed= B; 
//                12: ilkLed= C; 
//                13: ilkLed= D; 
//                14: ilkLed= E; 
//                15: ilkLed= F;  
//           endcase
           
//           anot = 4'b1110;
           
//           //Dorduncu 4 bit atanıyor
//           case(switchgirdi[3:0])
//                0: ilkLed  = sifir; 
//                1: ilkLed  = bir; 
//                2: ilkLed = iki; 
//                3: ilkLed = uc; 
//                4: ilkLed = dort; 
//                5: ilkLed = bes; 
//                6: ilkLed = alti; 
//                7: ilkLed = yedi; 
//                8: ilkLed = sekiz; 
//                9: ilkLed = dokuz; 
//                10: ilkLed = A; 
//                11: ilkLed = B; 
//                12: ilkLed = C; 
//                13: ilkLed = D; 
//                14: ilkLed = E; 
//                15: ilkLed = F;  
//           endcase      
           
//    end
    reg eskibuton;
    
    reg [1:0] Led_activator;
    always@(posedge clk)begin
        if(eskibuton == 0 && buton ==1) yeniclock = 1;
        else yeniclock = 0;
        eskibuton = buton;
    end
    always@(posedge yavas_clk) begin
        Led_activator = Led_activator+1;
        case(Led_activator)
        2'b00 : begin ilkLed = birLed; anot = 4'b0111;#100;end
        2'b01 : begin ilkLed = ikiLed; anot = 4'b1011;#100;end
        2'b10 : begin ilkLed = ucLed; anot = 4'b1101;#100;end
        2'b11 : begin ilkLed = dortLed; anot = 4'b1110;#100;end
        
        endcase
        
    end
    // islemler burada yapılacak
    // reset atılırsa switchler o anki mekanik hallerinden baslayacak. anlık olarak ledler sıfırlanacak. sonra switch degerlerine atanacak
    always @(posedge yeniclock or posedge reset) begin
        if(reset == 1) begin
            
            birLed = sifir;
            
            ikiLed = sifir;
            
            ucLed = sifir;
            
            dortLed = sifir;
            
            o1SecilenSayi = 0;
            o2SecilenSayi = 0;
            
            o1GirildiMi = 0;
            o2GirildiMi = 0;
            
            
            bulls = 0;
            cows = 0;
        end
        
        //Birinci oyuncunun seçilen sayısına switch'deki değer atanacak
        else if(o1GirildiMi == 0 && buton)begin
            o1SecilenSayi= switchgirdi;
            o1GirildiMi = 1;
            $display("o1seçilen= " , o1SecilenSayi);
            //buton =0; 
        end
    
        //Ikıncı oyuncunun seçilen sayısına switch'deki değer atanacak
        else if(o2GirildiMi == 0 && buton)begin
            o2SecilenSayi= switchgirdi;
            o2GirildiMi = 1;
            $display("o2seçilen= " , o2SecilenSayi);
            //buton =0;
        end
        
        //Oyuncuların sayıları atandı ve oyuna başlandı
        else if (buton)begin
        
            bulls = 0;
            cows = 0;
            
            //Birinci oyuncunun tahmin sırasıysa
            if(~tur) begin
                cows = 0;
                bulls = 0;
                //Bulls ve Cows sayıları sayılıyor
                if(o2SecilenSayi[15:12] == switchgirdi[15:12]) begin
                    bulls = bulls+1;
                end
                
                else if(o2SecilenSayi[15:12] == switchgirdi[11:8] ||o2SecilenSayi[15:12] == switchgirdi[7:4] || o2SecilenSayi[15:12] == switchgirdi[3:0]) begin
                   cows = cows+1;
                end
                
                if(o2SecilenSayi[11:8] == switchgirdi[11:8]) begin
                   bulls = bulls+1;
                end
                
                else if(o2SecilenSayi[11:8] == switchgirdi[15:12] ||o2SecilenSayi[11:8] == switchgirdi[7:4] ||o2SecilenSayi[11:8] == switchgirdi[3:0]) begin
                   cows = cows+1;
                end
                
                if(o2SecilenSayi[7:4] == switchgirdi[7:4]) begin
                   bulls = bulls+1;
                end
                
                else if(o2SecilenSayi[7:4] == switchgirdi[15:12] ||o2SecilenSayi[7:4] == switchgirdi[11:8] ||o2SecilenSayi[7:4] == switchgirdi[3:0]) begin
                   cows = cows+1;
                end
                
                if(o2SecilenSayi[3:0] == switchgirdi[3:0]) begin
                   bulls = bulls+1;
                end
                
                else if(o2SecilenSayi[3:0] == switchgirdi[15:12] ||o2SecilenSayi[3:0] == switchgirdi[7:4] ||o2SecilenSayi[3:0] == switchgirdi[11:8]) begin
                   cows = cows+1;
                end
                
                //Birinci oyuncu sayıyı bulduysa 7-seg disp de 0001 yazıyor
                if(bulls ==3'd4) begin
                   
                   birLed = sifir;
                   
                   ikiLed = sifir;
                   
                   ucLed = sifir;
                   
                   dortLed = bir;
                   flag = 1;
                end
                
            end
            
            //Ikinci oyuncunun tahmin sırasıysa
            else begin
                
                //Bulls ve Cows sayıları sayılıyor
                if(o1SecilenSayi[15:12] == switchgirdi[15:12]) begin
                    bulls = bulls+1;
                end
                
                else if(o1SecilenSayi[15:12] == switchgirdi[11:8] ||o1SecilenSayi[15:12] == switchgirdi[7:4] || o1SecilenSayi[15:12] == switchgirdi[3:0]) begin
                   cows = cows+1;
                end
                
                if(o1SecilenSayi[11:8] == switchgirdi[11:8]) begin
                   bulls = bulls+1;
                end
                
                else if(o1SecilenSayi[11:8] == switchgirdi[15:12] ||o1SecilenSayi[11:8] == switchgirdi[7:4] ||o1SecilenSayi[11:8] == switchgirdi[3:0]) begin
                   cows = cows+1;
                end
                
                if(o1SecilenSayi[7:4] == switchgirdi[7:4]) begin
                   bulls = bulls+1;
                end
                
                else if(o1SecilenSayi[7:4] == switchgirdi[15:12] ||o1SecilenSayi[7:4] == switchgirdi[11:8] ||o1SecilenSayi[7:4] == switchgirdi[3:0]) begin
                   cows = cows+1;
                end
                
                if(o1SecilenSayi[3:0] == switchgirdi[3:0]) begin
                   bulls = bulls+1;
                end
                
                else if(o1SecilenSayi[3:0] == switchgirdi[15:12] ||o1SecilenSayi[3:0] == switchgirdi[7:4] ||o1SecilenSayi[3:0] == switchgirdi[11:8]) begin
                   cows = cows+1;
                end
                
                //Ikinci oyuncu sayıyı bulduysa 7-seg disp de 0002 yazıyor
                if(bulls ==3'd4 && flag == 0) begin
                   
                   birLed = sifir;
                   
                   ikiLed = sifir;
                   
                   ucLed = sifir;
                   
                   dortLed = iki;
                   flag = 1;
                end
            end
            
            //Kaç tane bulls ve cows olduğu ledlerde gösteriliyor
            if(flag == 1'b0)begin
            birLed = B;
            
            case(bulls)
                0: ikiLed  = sifir; 
                1: ikiLed = bir; 
                2: ikiLed = iki; 
                3: ikiLed = uc; 
                4: ikiLed = dort; 
            endcase 
            
            ucLed = C;
            
            case(cows)
                0: dortLed  = sifir; 
                1: dortLed = bir; 
                2: dortLed = iki; 
                3: dortLed = uc; 
                4: dortLed = dort; 
            endcase 
            end
            //anot = 4'b0000;
            //Tur sırası diğer oyuncuya geçiyor
            tur = ~tur;
            //buton = 0;
            end
    end
    
    
    // clk yavaslatmak. her saniyede 1 posedge olacak sekilde
    always @(posedge clk )begin
        if(sayac==10**3/2) begin
            sayac = 0;
            yavas_clk=~yavas_clk;
        end
        sayac = sayac+1;
    end
    
endmodule