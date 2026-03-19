// VGA_OUTPUT
// 	MODULE TO DETERMINE PIXEL COLOR (OBJECT VS NO OBJECT) 
//			AND THEN DISPLAY TO DATA TO SCREEN
// VERSION: 1.0.3
// LAST UPDATED: MAR 17, 2026
// AUTHOR: DOMENIC CHAO

module VGA_OUTPUT #(
	parameter BOARD_WIDTH = 640, 				// THE WIDTH OF THE BOARD
	parameter BOARD_HEIGHT = 480,				// MTHE HEIGHT OF THE BOARD
	
	parameter BALL_SIZE = 9,					// THE NUMBER OF PIXELS ANY DIRECTION AROUND THE CENTRE
	
	parameter BLOCKER_SIZE = 20,				// THE HEIGHT OF THE BLOCKER ON ONE SIDE OF CENTRE
	parameter BLOCKER_PADDING = 10,			// THE PADDING BETWEEN THE BACK SIDE OF THE BLOCKER
	parameter BLOCKER_WIDTH = 5,				// THE WIDTH OF THE BLOCK ON ONE SIDE OF CENTRE
	
	parameter CENTRE_ROW_BETWEEN = 10,		// THE NUMBER OF ROWS THAT ARE BETWEEN EACH COLOR OF THE CENTRE LINE
	parameter CENTRE_WIDTH = 5					// THE WIDTH OF THE CENTRE LINE	
)(
	input [11:0] ballX,							// THE X POSITION OF THE BALL
	input [11:0] ballY,							// THE Y POSITION OF THE BALL
		
	input [11:0] blockerOneY,					// THE Y POSITION OF THE BLOCKER FOR PLAYER ONE
	input [11:0] blockerTwoY,					// THE Y POSITION OF THE BLOCKER FOR PLAYER TWO
		
	input [6:0] scoreOne,						// PLAYER ONE SCORE
	input [6:0] scoreTwo,						// PLAYER TWO SCORE
	
	input [23:0] backgroundCol,				// THE COLOR OF THE BACKGROUND
	input [23:0] objectCol,						// THE COLOR OF THE OBJECTS ON THE BOARD

	input clk25,				// 25MHZ CLOCK
	
	input rst,					// RESET INPUT
	input paused,				// PUASE INPUT
	
	output reg [7:0] vgaR, 	// VGA RED COLOR OUTPUT (0-255)
	output reg [7:0] vgaG,	// VGA GREEN COLOR OUTPUT (0-255)
	output reg [7:0] vgaB,	// VGA BLUE COLOR OUTPUT (0-255)
	output vgaHSYNC,			// VGA HORIZONTAL SYNC OUTPUT 
	output vgaVSYNC			// VGA VERTICAL SYNC OUTPUT
	
);

	// VARIABLES FOR HEIGHT AND WIDTH
   localparam H_ACTIVE = BOARD_WIDTH;
   localparam V_ACTIVE = BOARD_HEIGHT;
	
   localparam H_FRONT_P = 16;
	localparam V_FRONT_P = 10;
	
	localparam H_SYNC = 96;
	localparam V_SYNC = 2;
	
	localparam H_BACK_P = 48;
	localparam V_BACK_P = 33;
	
	localparam H_TOTAL = H_ACTIVE + H_FRONT_P + H_SYNC + H_BACK_P;
   localparam V_TOTAL = V_ACTIVE + V_FRONT_P + V_SYNC + V_BACK_P;
	
	// TEMPORARY HEIGHT AND WIDTH VARIABLE
	reg [11:0] Hpos = 0;
	reg [11:0] Vpos = 0;
	wire videoActive;
	
	reg [5:0] rowChange = 0;
	reg centreCol = 0;
	
	reg object = 0;

	reg [11:0] xOffset = 0;
	reg [11:0] yOffset = 0;
	reg [11:0] ascii = 0;
	wire isColor;
	
	 CHAR_TO_VGA #(
		.HEIGHT(27),
		.WIDTH(15)
	) largeFont (
		.ascii(ascii),
		.xPos(xOffset),
		.yPos(yOffset),
		.isColor(isColor)
	);
	
	
	// UPDATING THE VERTICAL AND HORIZONTAL POSITION
	always @(posedge clk25) begin
		if (rst) begin
			Hpos <= 0;
			Vpos <= 0;
		end else	if (Hpos < H_TOTAL - 1) begin
			// UPDATING HORIZONTAL POSITION
			Hpos <= Hpos + 1;
		end else begin
			Hpos <= 0;
			
			// DETERMINE IF WE NEED TO DRAW THE CENTRE LINE OR NOT AT THIS ROW
			if (rowChange >= CENTRE_ROW_BETWEEN) begin
				rowChange <= 0;
				centreCol <= !centreCol;
			end else begin
				rowChange <= rowChange + 1;
			end
			
			// UPDATING VERTICAL POSITION
			if (Vpos < V_TOTAL - 1) begin
				Vpos <= Vpos + 1;
			end else begin
				rowChange <= 0;
				centreCol <= 0;
				Vpos <= 0;
			end
		end
	end
	
	// HORIZONTAL SYNCING
	assign vgaHSYNC = rst ? 1'b1 :  ~((Hpos >= (H_ACTIVE + H_FRONT_P) && Hpos < (H_ACTIVE + H_FRONT_P + H_SYNC)));
		
	// VERTICAL SYNCING
	assign vgaVSYNC = rst ? 1'b1 : ~((Vpos >= (V_ACTIVE + V_FRONT_P) && Vpos < (V_ACTIVE + V_FRONT_P + V_SYNC)));
		
	assign videoActive = (Hpos < H_ACTIVE) && (Vpos < V_ACTIVE);
	
	// COLOR LOGIC
	always @(posedge clk25) begin
		object <= 0;
		
		// DETERMINE IF THERE IS OBJECT AT THIS PIXEL OR NOT
		
		// PAUSED WORDS
		if (paused) begin
			if (Hpos >= 200 && Hpos < 215 && Vpos >= 50 && Vpos <= 77) begin
				xOffset <= Hpos - 200;
				yOffset <= Vpos - 50;
				ascii <= 12'd80;
			end else if (Hpos >= 225 && Hpos < 240 && Vpos >= 50 && Vpos <= 77) begin
				xOffset <= Hpos - 225;
				yOffset <= Vpos - 50;
				ascii <= 12'd79;
			end else if (Hpos >= 250 && Hpos < 265 && Vpos >= 50 && Vpos <= 77) begin
				xOffset <= Hpos - 250;
				yOffset <= Vpos - 50;
				ascii <= 12'd78;
			end else	if (Hpos >= 275 && Hpos < 290 && Vpos >= 50 && Vpos <= 77) begin
				xOffset <= Hpos - 275;
				yOffset <= Vpos - 50;
				ascii <= 12'd71;
			end else begin
				ascii <= 0;
			end
						
			object <= isColor;
		end
		
		// BALL
		if ((Hpos >= (ballX - BALL_SIZE)) && (Hpos <= (ballX + BALL_SIZE)) && (Vpos >= (ballY - BALL_SIZE)) && (Vpos <= (ballY + BALL_SIZE))) begin
			object <= 1;
		end
		
		// P1 BLOCKER
		if ((Hpos >= (BLOCKER_PADDING - BLOCKER_WIDTH)) && (Hpos <= BLOCKER_PADDING) 
				&& (Vpos >= (blockerOneY - BLOCKER_SIZE)) && (Vpos <= blockerOneY + BLOCKER_SIZE)) begin
			object <= 1;
		end
		
		// P2 BLOCKER
		if ((Hpos >= (H_ACTIVE - BLOCKER_PADDING)) && (Hpos <= (H_ACTIVE - BLOCKER_PADDING + BLOCKER_WIDTH)) 
				&& (Vpos >= (blockerTwoY - BLOCKER_SIZE)) && (Vpos <= blockerTwoY + BLOCKER_SIZE)) begin
			object <= 1;
		end
		
		// CENTRE LINE
		if ((Hpos >= ((H_ACTIVE/2) - CENTRE_WIDTH)) && (Hpos <= ((H_ACTIVE/2) + CENTRE_WIDTH)) && centreCol) begin
			object <= 1;
		end
		
		
		// ADDING COLOR
		if (videoActive) begin
			if (object) begin
				vgaR <= objectCol[23:16];
				vgaG <= objectCol[15:8];
				vgaB <= objectCol[7:0];
			end else begin
				vgaR <= backgroundCol[23:16];
				vgaG <= backgroundCol[15:8];
				vgaB <= backgroundCol[7:0];
			end
		end else begin
			vgaR <= 0;
			vgaG <= 0;
			vgaB <= 0;
		end
	end	
endmodule